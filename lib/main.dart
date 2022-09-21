import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:strudl/get/app_controller.dart';
import 'package:strudl/pages/splash_screen.dart';
import 'package:strudl/theme/strudl_ui_theme.dart';

void main() {
  Get.put(AppController());

  runApp(GetMaterialApp(
    title: 'Strudl',
    theme: StrudlUiTheme.darkTheme,
    home: const SplashScreen(),
  ));
}
