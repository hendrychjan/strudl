import 'package:hive/hive.dart';
import 'package:strudl/models/session_type.dart';

class HiveSessionTypeService {
  static final Box<SessionType> _box = Hive.box<SessionType>('session_types');

  static List<SessionType> getSessionTypes() {
    final sessionTypes = _box.values.toList();
    return sessionTypes;
  }

  static Future<void> addSessionType(SessionType sessionType) async {
    await _box.put(sessionType.id.toString(), sessionType);
  }

  static Future<void> updateSessionType(SessionType sessionType) async {
    await _box.put(sessionType.id.toString(), sessionType);
  }

  static Future<void> deleteSessionType(SessionType sessionType) async {
    await _box.delete(sessionType.id.toString());
  }
}
