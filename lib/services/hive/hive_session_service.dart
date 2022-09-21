import 'package:hive/hive.dart';
import 'package:strudl/models/session.dart';

class HiveSessionService {
  static final Box<Session> _box = Hive.box<Session>('sessions');

  static List<Session> getSessions() {
    final sessions = _box.values.toList();
    return sessions;
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
