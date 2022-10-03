import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:strudl/forms/course_form.dart';
import 'package:strudl/get/app_controller.dart';
import 'package:strudl/models/course.dart';
import 'package:strudl/services/ui_helper.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  void _displayCourseDialog(Widget formContent) async {
    await Get.dialog(
      AlertDialog(
        contentPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
        content: formContent,
      ),
    );
  }

  Future<void> _handleSubmitNew(Course newCourse) async {
    await newCourse.create();
    Get.back();
  }

  Future<void> _handleSubmitUpdate(Course updatedCourse) async {
    await updatedCourse.update();
    Get.back();
  }

  Future<void> _handleSubmitDelete(Course deletedCourse) async {
    await deletedCourse.remove();
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiHelper.renderPageAppBar("Courses", actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _displayCourseDialog(
            CourseForm(handleSubmit: _handleSubmitNew),
          ),
        ),
      ]),
      body: Obx(
        () => ListView.builder(
          itemCount: AppController.to.courses.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _displayCourseDialog(
                CourseForm(
                  handleSubmit: _handleSubmitUpdate,
                  handleDelete: _handleSubmitDelete,
                  initialState: AppController.to.courses[index],
                ),
              ),
              child: Card(
                child: ListTile(
                  title: Text(
                    AppController.to.courses[index].title,
                    style: TextStyle(
                        color: UiHelper.hexStringToColor(
                            AppController.to.courses[index].color)),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
