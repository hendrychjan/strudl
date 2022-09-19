import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:strudl/pages/home_page.dart';
import 'package:strudl/services/app_init_service.dart';

/// Splash screen that runs the appInit method
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Run the appInit method in the background and then navigate to the home page
  void _runInit() {
    Future.delayed(
      const Duration(seconds: 2),
      () => AppInitService.init(),
    ).then(
      (v) => Get.off(
        () => const HomePage(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _runInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
