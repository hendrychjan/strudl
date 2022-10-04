import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:strudl/forms/session_form.dart';
import 'package:strudl/forms/sessions_overview_filter_form.dart';
import 'package:strudl/get/app_controller.dart';
import 'package:strudl/models/course.dart';
import 'package:strudl/models/session.dart';
import 'package:strudl/models/session_type.dart';
import 'package:strudl/services/ui_helper.dart';

class SessionsOverviewPage extends StatefulWidget {
  const SessionsOverviewPage({super.key});

  @override
  State<SessionsOverviewPage> createState() => _SessionsOverviewPageState();
}

class _SessionsOverviewPageState extends State<SessionsOverviewPage> {
  late Map _filter = {};
  final List<Session> _sessions = [];

  void _filterExpenses() {
    List<Session> filteredSessions = [];

    if (_filter.isEmpty) {
      filteredSessions = Session.getSessions();
    } else {
      filteredSessions = Session.getSessions(_filter);
    }

    setState(() {
      _sessions.clear();
      _sessions.addAll(filteredSessions);
    });
  }

  void _displayFilterDialog() async {
    await Get.dialog(
      AlertDialog(
        contentPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
        content: SessionsOverviewFilterForm(
          initialState: _filter,
          handleSubmit: (filter) {
            setState(() {
              _filter = filter;
            });

            Get.back();

            _filterExpenses();
          },
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _handleUpdate(Session updatedSession) async {
    await updatedSession.update();
    _filterExpenses();
    Get.back();
  }

  Future<void> _handleDelete(Session deletedSession) async {
    await deletedSession.delete();
    _filterExpenses();
    Get.back();
  }

  void _displaySessionDialog(Widget formContent) async {
    await Get.dialog(
      AlertDialog(
        contentPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
        content: formContent,
      ),
      barrierDismissible: false,
    );
  }

  @override
  void initState() {
    super.initState();

    // Set the default filters
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    _filter = {
      "range": "alltime",
      "rangeTargetDate": today,
      "customRangeDateFrom": today,
      "customRangeDateTo": today,
      "courses": AppController.to.courses.map((e) => e.id).toList(),
      "sessionTypes": AppController.to.sessionTypes.map((e) => e.id).toList(),
    };

    Future.delayed(Duration.zero, _displayFilterDialog);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: UiHelper.renderPageAppBar(
          "Sessions",
          actions: [
            IconButton(
                icon: const Icon(Icons.filter_list_alt),
                onPressed: _displayFilterDialog),
          ],
        ),
        body: Column(
          children: [
            if (_sessions.isEmpty)
              const Expanded(
                child: Center(
                  child: Text("No results match the filter"),
                ),
              )
            else
              Obx(() {
                AppController.to.updateHook.value;

                return Expanded(
                    child: ListView.builder(
                  itemCount: _sessions.length,
                  itemBuilder: (context, index) {
                    final session = _sessions[index];

                    final Course sessionCourse =
                        AppController.to.courses.firstWhere(
                      (course) => course.id == session.courseId,
                    );

                    final SessionType sessionType = AppController
                        .to.sessionTypes
                        .firstWhere((sessionType) =>
                            sessionType.id == session.sessionTypeId);

                    final int sessionDuration =
                        session.end.difference(session.start).inSeconds;

                    return GestureDetector(
                      onTap: () {
                        _displaySessionDialog(
                          SessionForm(
                            initialState: session,
                            handleSubmit: (Session updatedSession) async {
                              await _handleUpdate(updatedSession);
                            },
                            handleDelete: (Session sessionToDelete) async {
                              await _handleDelete(sessionToDelete);
                            },
                            onCancel: () => Get.back(),
                          ),
                        );
                      },
                      child: Card(
                        key: UniqueKey(),
                        child: ListTile(
                          key: UniqueKey(),
                          title: Text(
                            sessionCourse.title,
                            style: TextStyle(
                              color: UiHelper.hexStringToColor(
                                  sessionCourse.color),
                            ),
                          ),
                          subtitle: Text(sessionType.title),
                          trailing: Text(
                            Session.formatSessionTime(sessionDuration),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ));
              }),
          ],
        ));
  }
}
