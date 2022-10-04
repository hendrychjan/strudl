import 'package:hive/hive.dart';
import 'package:strudl/get/app_controller.dart';
import 'package:strudl/services/hive/hive_session_type_service.dart';

// hive_generate command: flutter packages pub run build_runner build
part 'session_type.g.dart';

@HiveType(typeId: 2)
class SessionType extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String color;

  SessionType({
    required this.id,
    required this.title,
    required this.color,
  });

  factory SessionType.fromMap(Map<String, dynamic> map) {
    return SessionType(
      id: int.parse(map['id']),
      title: map['title'],
      color: map['color'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id.toString(),
      'title': title,
      'color': color,
    };
  }

  static List<SessionType> getSessionTypes() {
    return HiveSessionTypeService.getSessionTypes();
  }

  Future<void> create({forceId = false}) async {
    if (!forceId) {
      id = DateTime.now().millisecondsSinceEpoch;
    }

    await HiveSessionTypeService.addSessionType(this);

    AppController.to.sessionTypes.add(this);
  }

  Future<void> update() async {
    await HiveSessionTypeService.updateSessionType(this);

    final index = AppController.to.sessionTypes.indexWhere((c) => c.id == id);
    AppController.to.sessionTypes[index] = this;
  }

  Future<void> remove() async {
    await HiveSessionTypeService.deleteSessionType(this);

    AppController.to.sessionTypes.removeWhere((c) => c.id == id);
  }

  bool existsIn(List<SessionType> target) {
    return target.where((st) => st.id == id).isNotEmpty;
  }
}
