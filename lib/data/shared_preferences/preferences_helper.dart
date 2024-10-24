import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  final Future<SharedPreferences> sharedPreferences;

  PreferencesHelper({required this.sharedPreferences});

  static const dailyReminder = 'DAILY_REMINDER';

  Future setDailyReminder(bool isReminder) async {
    final prefs = await sharedPreferences;
    prefs.setBool(dailyReminder, isReminder);
  }

  Future<bool> get isDailyReminder async {
    final prefs = await sharedPreferences;
    return prefs.getBool(dailyReminder) ?? false;
  }
}
