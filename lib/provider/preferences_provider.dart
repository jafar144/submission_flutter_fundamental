import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:submission_awal_flutter_fundamental/data/shared_preferences/preferences_helper.dart';
import 'package:submission_awal_flutter_fundamental/utils/background_service.dart';
import 'package:submission_awal_flutter_fundamental/utils/date_time_helper.dart';

class PreferencesProvider extends ChangeNotifier {
  final PreferencesHelper preferencesHelper;

  PreferencesProvider({required this.preferencesHelper}) {
    _getDailyReminderPreferences();
  }

  bool _isDailyReminder = false;
  bool get isDailyReminder => _isDailyReminder;

  Future _getDailyReminderPreferences() async {
    _isDailyReminder = await preferencesHelper.isDailyReminder;
    notifyListeners();
  }

  Future<bool> enableDailyReminder(bool value) async {
    debugPrint('Nilai yang diberikan switch ke enable: $value');
    await preferencesHelper.setDailyReminder(value);
    await _getDailyReminderPreferences();
    debugPrint('Sekarang nilai _isDailyReminder: $_isDailyReminder');

    if (_isDailyReminder) {
      debugPrint('Penjadwalan notif restaurant berhasil diaktifkan');
      return await AndroidAlarmManager.periodic(
        const Duration(hours: 24),
        1,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      debugPrint('Penjadwalan notif restaurant di nonaktifkan');
      notifyListeners();
      return AndroidAlarmManager.cancel(1);
    }
  }
}
