import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:strudl/get/app_controller.dart';
import 'package:strudl/services/local_data_service.dart';
import 'package:strudl/services/ui_helper.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _backupInProgress = false;
  bool _restoreInProgress = false;

  void _handleBackupData() async {
    setState(() {
      _backupInProgress = true;
    });

    await LocalDataService.backupData();
    Get.snackbar(
      "Success",
      "Backup file created successfully!",
      snackPosition: SnackPosition.BOTTOM,
    );

    setState(() {
      _backupInProgress = false;
    });
  }

  void _handleRestoreData() async {
    setState(() {
      _restoreInProgress = true;
    });

    try {
      await LocalDataService.restoreData();
      Get.snackbar(
        "Success",
        "Synchronized with the backup file!",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    setState(() {
      _restoreInProgress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiHelper.renderPageAppBar(
        "Settings",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                (!_backupInProgress && !_restoreInProgress)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: _handleBackupData,
                            child: Column(
                              children: const [
                                Icon(Icons.upload_rounded),
                                Text("Backup data"),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _handleRestoreData,
                            child: Column(
                              children: const [
                                Icon(Icons.download_rounded),
                                Text("Restore data"),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [CircularProgressIndicator()],
                        ),
                      ),
              ],
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(
                  () => Text(
                    AppController.to.appVersion.string,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    "OSS with ❤️ by Jan Hendrych",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
