import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:strudl/get/app_controller.dart';
import 'package:strudl/pages/main/analyze_page.dart';
import 'package:strudl/pages/main/courses_page.dart';
import 'package:strudl/pages/main/session_page.dart';
import 'package:strudl/pages/main/session_types_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PageController _pageController = PageController();

  void _handlePageChange(int index) {
    AppController.to.selectedPageIndex.value = index;
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 100), curve: Curves.ease);
  }

  Widget _renderNavigationItem({
    required IconData icon,
    required int index,
  }) {
    return GestureDetector(
      onTap: () => _handlePageChange(index),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Icon(
            icon,
            color: (AppController.to.selectedPageIndex.value == index)
                ? Get.theme.primaryColor
                : Colors.grey[300],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _renderNavigationItem(icon: Icons.timer_rounded, index: 0),
              _renderNavigationItem(icon: Icons.bar_chart_rounded, index: 1),
              _renderNavigationItem(icon: Icons.category_rounded, index: 2),
              _renderNavigationItem(icon: Icons.menu_book_rounded, index: 3),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: PageView(
          onPageChanged: (value) =>
              AppController.to.selectedPageIndex.value = value,
          controller: _pageController,
          children: const [
            SessionPage(),
            AnalyzePage(),
            SessionTypesPage(),
            CoursesPage()
          ],
        ),
      ),
    );
  }
}
