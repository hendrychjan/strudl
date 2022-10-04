import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:strudl/forms/session_form.dart';
import 'package:strudl/get/app_controller.dart';
import 'package:strudl/models/session.dart';
import 'package:strudl/pages/session/sessions_overview_page.dart';
import 'package:strudl/pages/settings_page.dart';
import 'package:strudl/services/ui_helper.dart';
import 'package:strudl/theme/sprite_painter.dart';

class SessionPage extends StatefulWidget {
  const SessionPage({Key? key}) : super(key: key);

  @override
  State<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Timer _timer;
  int _sessionLength = 1;
  late DateTime _sessionStartedAt;
  bool _sessionIsRunning = false;

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

  void _startSession([DateTime? sessionStart]) {
    setState(() {
      // Start the animation
      _controller.repeat(period: const Duration(seconds: 1));

      // Start the timer
      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (t) => setState(
          () {
            _sessionLength++;
          },
        ),
      );

      // Starting a new session
      if (sessionStart == null) {
        // Update the app state
        AppController.to.sessionIsActive.value = true;
        AppController.to.sessionStartedAt.value = DateTime.now();

        // Update the page state
        _sessionIsRunning = true;
        _sessionStartedAt = DateTime.now();

        GetStorage().write("session_is_active", true);
        GetStorage().write("session_start", DateTime.now().toIso8601String());
      }

      // Restoring a session
      else {
        // Update the page state
        _sessionIsRunning = true;
        _sessionStartedAt = sessionStart;
        _sessionLength = DateTime.now().difference(sessionStart).inSeconds;
      }
    });
  }

  void _endSession() {
    setState(() {
      // Stop the animation
      _controller.reset();

      // Stop the timer
      _timer.cancel();

      // Update the app state
      AppController.to.sessionIsActive.value = false;
      GetStorage().write("session_is_active", false);
      _sessionIsRunning = false;
      _sessionLength = 0;
    });
  }

  Widget _renderTimerControl(
      {required IconData icon, required Color color, required Function onTap}) {
    return SizedBox(
      height: 40,
      width: 40,
      child: IconButton(
        padding: const EdgeInsets.all(0),
        icon: Icon(
          icon,
          size: 40,
          color: color,
        ),
        onPressed: () => onTap(),
      ),
    );
  }

  Future<void> _handleSubmitNew(Session newSession) async {
    await newSession.create();
    Get.back();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    // An empty timer just to initialize the field
    _timer = Timer(const Duration(hours: 1), () {});

    // Session was active in the background - restore it
    if (AppController.to.sessionIsActive.value) {
      _startSession(AppController.to.sessionStartedAt.value);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiHelper.renderPageAppBar(
        "Session",
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _displaySessionDialog(
              SessionForm(
                handleSubmit: _handleSubmitNew,
                onCancel: Get.back,
              ),
            ),
          ),
        ],
        leading: IconButton(
          onPressed: () => Get.to(() => const SettingsPage()),
          icon: const Icon(Icons.settings),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: UniqueKey(),
        onPressed: () => Get.to(() => const SessionsOverviewPage()),
        child: const Icon(Icons.history_rounded),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_sessionIsRunning)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: CustomPaint(
                  painter: SpritePainter(_controller),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    // height: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Text(
                        Session.formatSessionTime(_sessionLength),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            if (_sessionIsRunning)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _renderTimerControl(
                    icon: Icons.clear_rounded,
                    color: Colors.red[200]!,
                    onTap: () {
                      _endSession();
                    },
                  ),
                  _renderTimerControl(
                    icon: Icons.done_rounded,
                    color: Get.theme.primaryColor,
                    onTap: () {
                      // Save the result session
                      _displaySessionDialog(
                        SessionForm(
                          handleSubmit: (Session session) async {
                            _handleSubmitNew(session);
                            _endSession();
                          },
                          initialState: Session(
                            id: 0,
                            start: _sessionStartedAt,
                            end: DateTime.now(),
                            courseId: AppController.to.courses.first.id,
                            sessionTypeId:
                                AppController.to.sessionTypes.first.id,
                            note: "",
                          ),
                          onCancel: () {
                            Get.back();
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            if (!_sessionIsRunning)
              GestureDetector(
                onTap: _startSession,
                child: const Icon(
                  Icons.play_arrow_rounded,
                  size: 200,
                  shadows: [
                    BoxShadow(
                      offset: Offset(0, 0),
                      spreadRadius: -10,
                      blurRadius: 80,
                      color: Color.fromRGBO(45, 164, 78, 0.5),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
