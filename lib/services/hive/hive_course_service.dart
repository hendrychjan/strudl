import 'package:hive/hive.dart';
import 'package:strudl/models/course.dart';

class HiveCourseService {
  static final Box<Course> _box = Hive.box<Course>('courses');

  static List<Course> getCourses() {
    final courses = _box.values.toList();
    return courses;
  }

  static Future<void> addCourse(Course course) async {
    await _box.put(course.id.toString(), course);
  }

  static Future<void> updateCourse(Course course) async {
    await _box.put(course.id.toString(), course);
  }

  static Future<void> deleteCourse(Course course) async {
    await _box.delete(course.id.toString());
  }
}
