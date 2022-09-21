import 'package:hive/hive.dart';
import 'package:strudl/get/app_controller.dart';
import 'package:strudl/services/hive/hive_session_service.dart';

// hive_generate command: flutter packages pub run build_runner build
part 'session.g.dart';

@HiveType(typeId: 3)
class Session extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  DateTime start;

  @HiveField(2)
  DateTime end;

  @HiveField(3)
  String? note;

  @HiveField(4)
  int courseId;

  @HiveField(5)
  int sessionTypeId;

  Session({
    required this.id,
    required this.start,
    required this.end,
    this.note,
    required this.courseId,
    required this.sessionTypeId,
  });

  static List<Session> getSessions() {
    return HiveSessionService.getSessions();
  }

  Future<void> create({forceId = false}) async {
    if (!forceId) {
      id = DateTime.now().millisecondsSinceEpoch;
    }

    await HiveSessionService.addSession(this);
  }

  Future<void> update() async {
    await HiveSessionService.updateSession(this);
  }

  Future<void> remove() async {
    await HiveSessionService.deleteSession(this);
  }
}
