import 'package:hive_flutter/hive_flutter.dart';
import 'package:strudl/get/app_controller.dart';
import 'package:strudl/models/course.dart';
import 'package:strudl/models/session.dart';
import 'package:strudl/models/session_type.dart';

class AppInitService {
  static Future<void> init() async {
    await _initHive();

    _loadHiveData();
  }

  static Future<void> _initHive() async {
    await Hive.initFlutter();

    Hive.registerAdapter(CourseAdapter());
    Hive.registerAdapter(SessionTypeAdapter());
    Hive.registerAdapter(SessionAdapter());

    await Hive.openBox<Course>('courses');
    await Hive.openBox<SessionType>('session_types');
    await Hive.openBox<Session>('sessions');
  }

  static void _loadHiveData() {
    AppController.to.courses.addAll(Course.getCourses());
    AppController.to.sessionTypes.addAll(SessionType.getSessionTypes());
  }
}
