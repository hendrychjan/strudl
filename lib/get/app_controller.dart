import 'package:get/get.dart';
import 'package:strudl/models/course.dart';
import 'package:strudl/models/session_type.dart';

class AppController extends GetxController {
  static AppController get to => Get.find();

  // Data state
  var courses = List<Course>.empty(growable: true).obs;
  var sessionTypes = List<SessionType>.empty(growable: true).obs;

  // App state
  var appLocale = ''.obs;
  var selectedPageIndex = 0.obs;
  var sessionIsActive = false.obs;
  var sessionStartedAt = DateTime(2000).obs;

  var updateHook = 1.obs;

  var appVersion = "".obs;
}
