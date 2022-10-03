import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:strudl/get/app_controller.dart';
import 'package:strudl/pages/splash_screen.dart';
import 'package:strudl/theme/strudl_ui_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  Get.put(AppController());

  // Dirty fix for - systemUIOverlayStyle not working properly when called from theme
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.dark,
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  runApp(GetMaterialApp(
    title: 'Strudl',
    theme: StrudlUiTheme.darkTheme,
    home: const SplashScreen(),
    debugShowCheckedModeBanner: false,
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    supportedLocales: const [
      Locale('en'),
      Locale('cs', 'CZ'),
    ],
  ));
}
