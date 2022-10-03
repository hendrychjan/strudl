import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:strudl/forms/session_type_form.dart';
import 'package:strudl/get/app_controller.dart';
import 'package:strudl/models/session_type.dart';
import 'package:strudl/services/ui_helper.dart';

class SessionTypesPage extends StatefulWidget {
  const SessionTypesPage({super.key});

  @override
  State<SessionTypesPage> createState() => _SessionTypesPageState();
}

class _SessionTypesPageState extends State<SessionTypesPage> {
  void _displaySessionTypeDialog(Widget formContent) async {
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

  Future<void> _handleSubmit(SessionType newSessionType) async {
    await newSessionType.create();
    Get.back();
  }

  Future<void> _handleSubmitUpdate(SessionType updatedSessionType) async {
    await updatedSessionType.update();
    Get.back();
  }

  Future<void> _handleSubmitDelete(SessionType deletedSessionType) async {
    await deletedSessionType.remove();
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiHelper.renderPageAppBar("Session Types", actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _displaySessionTypeDialog(
            SessionTypeForm(handleSubmit: _handleSubmit),
          ),
        ),
      ]),
      body: Obx(
        () => ListView.builder(
          itemCount: AppController.to.sessionTypes.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _displaySessionTypeDialog(
                SessionTypeForm(
                  handleSubmit: _handleSubmitUpdate,
                  handleDelete: _handleSubmitDelete,
                  initialState: AppController.to.sessionTypes[index],
                ),
              ),
              child: Card(
                child: ListTile(
                  title: Text(
                    AppController.to.sessionTypes[index].title,
                    style: TextStyle(color: Get.theme.primaryColor),
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
