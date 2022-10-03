import 'dart:ui';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:strudl/get/app_controller.dart';
import 'package:strudl/models/course.dart';
import 'package:strudl/models/session.dart';
import 'package:strudl/models/session_type.dart';
import 'package:intl/intl_standalone.dart';
import 'package:intl/date_symbol_data_local.dart';

class AppInitService {
  static Future<void> init() async {
    await _initGetStorage();
    await _initHive();
    await _loadHiveData();
    await _initLocalizations();
  }

  static _initGetStorage() async {
    await GetStorage.init();

    String defaultLocale = await findSystemLocale();

    await GetStorage().writeIfNull("app_locale", defaultLocale);
    await GetStorage().writeIfNull("session_is_active", false);
    await GetStorage()
        .writeIfNull("session_start", DateTime.now().toIso8601String());

    AppController.to.appLocale.value = GetStorage().read("app_locale");
    AppController.to.sessionIsActive.value =
        GetStorage().read("session_is_active");
    AppController.to.sessionStartedAt.value =
        DateTime.parse(GetStorage().read("session_start"));
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

  static Future<void> _loadHiveData() async {
    AppController.to.courses.addAll(Course.getCourses());
    AppController.to.sessionTypes.addAll(SessionType.getSessionTypes());
  }

  static Future<void> _initLocalizations() async {
    var locale = AppController.to.appLocale.value.split("_");
    String language = locale[0];
    String country = locale[1];
    await initializeDateFormatting(AppController.to.appLocale.value);
    await Get.updateLocale(Locale(language, country));
  }
}
