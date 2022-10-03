import 'package:hive/hive.dart';
import 'package:strudl/models/session.dart';

class HiveSessionService {
  static final Box<Session> _box = Hive.box<Session>('sessions');

  static List<Session> getSessions([Map? filter]) {
    List<Session> sessions = _box.values.where((session) {
      // No filters
      if (filter == null) return true;

      // Filter by course
      if (filter.containsKey("courses")) {
        if (!(filter["courses"] as List).contains(session.courseId)) {
          return false;
        }
      }

      // Filter by sessionType
      if (filter.containsKey("sessionTypes")) {
        if (!(filter["sessionTypes"] as List).contains(session.sessionTypeId)) {
          return false;
        }
      }

      // Filter by start
      if (filter.containsKey("range")) {
        if (filter["range"] == "alltime") {
          // Do nothing
        } else if (filter["range"] == "year") {
          if (session.start.year != filter["rangeTargetDate"].year) {
            return false;
          }
        } else if (filter["range"] == "month") {
          if (session.start.year != filter["rangeTargetDate"].year ||
              session.start.month != filter["rangeTargetDate"].month) {
            return false;
          }
        } else if (filter["range"] == "week") {
          DateTime base = filter["rangeTargetDate"] as DateTime;

          // Get the start of the first day of the current week
          DateTime firstDayOfWeek = DateTime(base.year, base.month, base.day)
              .subtract(Duration(days: base.weekday - 1));

          // Get the start of the last day of the current week
          DateTime lastDayOfWeek = DateTime(base.year, base.month, base.day)
              .add(Duration(days: 7 - base.weekday));

          // Filter the sessions by the current week
          if (session.start.isBefore(firstDayOfWeek) ||
              session.start.isAfter(lastDayOfWeek)) {
            return false;
          }
        } else if (filter["range"] == "custom") {
          if (session.start.isBefore((filter["customRangeDateFrom"] as DateTime)
                  .add(const Duration(days: 1))) ||
              session.start.isAfter((filter["customRangeDateTo"] as DateTime)
                  .subtract(const Duration(days: 1)))) {
            return false;
          }
        }
      }

      return true;
    }).toList();

    return sessions;
  }

  static Session getSession(int id) {
    return _box.values.firstWhere((session) => session.id == id);
  }

  static Future<void> addSession(Session session) async {
    await _box.put(session.id.toString(), session);
  }

  static Future<void> updateSession(Session session) async {
    await _box.put(session.id.toString(), session);
  }

  static Future<void> deleteSession(Session session) async {
    await _box.delete(session.id.toString());
  }
}
