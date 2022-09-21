import 'package:hive/hive.dart';
import 'package:strudl/get/app_controller.dart';
import 'package:strudl/services/hive/hive_course_service.dart';

// hive_generate command: flutter packages pub run build_runner build
part 'course.g.dart';

@HiveType(typeId: 1)
class Course extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? description;

  @HiveField(3)
  String color;

  Course({
    required this.id,
    required this.title,
    this.description,
    required this.color,
  });

  static List<Course> getCourses() {
    return HiveCourseService.getCourses();
  }

  Future<void> create({forceId = false}) async {
    if (!forceId) {
      id = DateTime.now().millisecondsSinceEpoch;
    }

    await HiveCourseService.addCourse(this);

    AppController.to.courses.add(this);
  }

  Future<void> update() async {
    await HiveCourseService.updateCourse(this);

    final index = AppController.to.courses.indexWhere((c) => c.id == id);
    AppController.to.courses[index] = this;
  }

  Future<void> remove() async {
    await HiveCourseService.deleteCourse(this);

    AppController.to.courses.removeWhere((c) => c.id == id);
  }
}
