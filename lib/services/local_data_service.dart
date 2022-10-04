import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:strudl/models/course.dart';
import 'package:strudl/models/session.dart';
import 'package:strudl/models/session_type.dart';

class LocalDataService {
  static Future<void> backupData() async {
    DateTime timestamp = DateTime.now().toLocal();
    Map<String, dynamic> exportMap = {
      "sessions": [],
      "courses": [],
      "sessionTypes": [],
      "date": timestamp.toIso8601String(),
    };

    // Export all courses and session types
    List<Map> courses = Course.getCourses().map((e) => e.toMap()).toList();
    List<Map> sessionTypes =
        SessionType.getSessionTypes().map((e) => e.toMap()).toList();
    (exportMap["courses"] as List).addAll(courses);
    (exportMap["sessionTypes"] as List).addAll(sessionTypes);

    // Export all session and populate their children
    List<Map> sessions = Session.getSessions().map((e) => e.toMap()).toList();
    for (Map session in sessions) {
      session["course"] =
          courses.firstWhere((c) => c["id"] == session["courseId"]);
      session["sessionType"] =
          sessionTypes.firstWhere((st) => st["id"] == session["sessionTypeId"]);
    }
    (exportMap["sessions"] as List).addAll(sessions);

    // Encode the export to a temp local file
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String fileName = "strudl_backup_${timestamp.millisecondsSinceEpoch}.json";
    String path = join(documentsDir.path, fileName);
    String exportEncoded = jsonEncode(exportMap);

    // Present the backup file to a user and then delete the temp file
    await File(path).writeAsString(exportEncoded);
    await Share.shareFiles([path]);
    await File(path).delete();
  }

  static Future<void> restoreData() async {
    // Load the backup file
    FilePickerResult? res = await FilePicker.platform.pickFiles();
    if (res == null) {
      throw throw "File not provided";
    }

    File backupFile = File(res.files.single.path!);
    Map backupMap = jsonDecode(await backupFile.readAsString());

    // Check the backup format
    if (backupMap["sessions"] is! List) {
      throw "Failed to parse: sessions missing in backup file";
    }
    if (backupMap["courses"] is! List) {
      throw "Failed to parse: courses missing in backup file";
    }
    if (backupMap["sessionTypes"] is! List) {
      throw "Failed to parse: session types missing in backup file";
    }

    // Load courses
    List<Course> existingCourses = Course.getCourses();
    for (Map<String, dynamic> courseMap in (backupMap["courses"] as List)) {
      try {
        Course course = Course.fromMap(courseMap);
        if (!course.existsIn(existingCourses) && course.id != 0) {
          await course.create(forceId: true);
          existingCourses.add(course);
        }
      } catch (e) {
        throw "Failed to parse: wrong course format";
      }
    }

    // Load session types
    List<SessionType> existingSessionTypes = SessionType.getSessionTypes();
    for (Map<String, dynamic> sessionTypeMap
        in (backupMap["sessionTypes"] as List)) {
      try {
        SessionType sessionType = SessionType.fromMap(sessionTypeMap);
        if (!sessionType.existsIn(existingSessionTypes) &&
            sessionType.id != 0) {
          await sessionType.create(forceId: true);
          existingSessionTypes.add(sessionType);
        }
      } catch (e) {
        throw "Failed to parse: wrong session type format";
      }
    }

    // Load sessions
    List<Session> existingSessions = Session.getSessions();
    for (Map<String, dynamic> sessionMap in (backupMap["sessions"] as List)) {
      Session session = Session.fromMap(sessionMap);

      if (!session.childExistsIn(existingCourses)!) {
        throw "Falied to parse: missing course";
      }

      if (!session.childExistsIn(existingSessionTypes)!) {
        throw "Falied to parse: missing session type";
      }

      if (!session.existsIn(existingSessions)) {
        await session.create(forceId: true);
        existingSessions.add(session);
      }
    }
  }
}
