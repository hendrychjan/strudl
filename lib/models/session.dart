import 'package:hive/hive.dart';
import 'package:strudl/models/course.dart';
import 'package:strudl/models/session_type.dart';
import 'package:strudl/services/hive/hive_session_service.dart';

// hive_generate command: flutter packages pub run build_runner build
part 'session.g.dart';

@HiveType(typeId: 3)
class Session extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  DateTime start;

  @HiveField(2)
  DateTime end;

  @HiveField(3)
  String? note;

  @HiveField(4)
  int courseId;

  @HiveField(5)
  int sessionTypeId;

  Session({
    required this.id,
    required this.start,
    required this.end,
    this.note,
    required this.courseId,
    required this.sessionTypeId,
  });

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      id: int.parse(map['id']),
      start: DateTime.parse(map['start']),
      end: DateTime.parse(map['end']),
      note: map['note'],
      courseId: int.parse(map['courseId']),
      sessionTypeId: int.parse(map['sessionTypeId']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id.toString(),
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
      'note': note,
      'courseId': courseId.toString(),
      'sessionTypeId': sessionTypeId.toString(),
    };
  }

  static List<Session> getSessions([Map? filter]) {
    return HiveSessionService.getSessions(filter);
  }

  static Session getSessionById(int id) {
    return HiveSessionService.getSession(id);
  }

  Future<void> create({forceId = false}) async {
    if (!forceId) {
      id = DateTime.now().millisecondsSinceEpoch;
    }

    await HiveSessionService.addSession(this);
  }

  Future<void> update() async {
    await HiveSessionService.updateSession(this);
  }

  Future<void> remove() async {
    await HiveSessionService.deleteSession(this);
  }

  static String formatSessionTime(int sessionLength) {
    Duration sessionDuration = Duration(seconds: sessionLength);

    String hours = sessionDuration.inHours.toString().padLeft(0, '2');
    String minutes =
        sessionDuration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds =
        sessionDuration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  bool existsIn(List<Session> target) {
    return target.where((s) => s.id == id).isNotEmpty;
  }

  bool? childExistsIn(List<dynamic> target) {
    if (target is List<Course>) {
      return target.where((c) => c.id == courseId).isNotEmpty;
    }

    if (target is List<SessionType>) {
      return target.where((st) => st.id == sessionTypeId).isNotEmpty;
    }

    return null;
  }
}
