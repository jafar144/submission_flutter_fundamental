import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_awal_flutter_fundamental/provider/preferences_provider.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<PreferencesProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Switch.adaptive(
              value: provider.isDailyReminder,
              onChanged: (value) async {
                if (Platform.isIOS) {
                  _alertDialogForIos(context);
                } else {
                  provider.enableDailyReminder(value);
                }
              },
            ),
          );
        },
      ),
    );
  }

  void _alertDialogForIos(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Not Available'),
          content: const Text('This feature not available on this device'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Ok'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}

class Navigation {}
