import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission_awal_flutter_fundamental/common/navigation.dart';
import 'package:submission_awal_flutter_fundamental/data/api/api_service.dart';
import 'package:submission_awal_flutter_fundamental/data/db/database_helper.dart';
import 'package:submission_awal_flutter_fundamental/data/shared_preferences/preferences_helper.dart';
import 'package:submission_awal_flutter_fundamental/provider/add_review_provider.dart';
import 'package:submission_awal_flutter_fundamental/provider/database_provider.dart';
import 'package:submission_awal_flutter_fundamental/provider/detail_restaurant_provider.dart';
import 'package:submission_awal_flutter_fundamental/provider/preferences_provider.dart';
import 'package:submission_awal_flutter_fundamental/provider/restaurant_provider.dart';
import 'package:submission_awal_flutter_fundamental/provider/search_provider.dart';
import 'package:submission_awal_flutter_fundamental/ui/add_review_screen.dart';
import 'package:submission_awal_flutter_fundamental/ui/detail_screen.dart';
import 'package:submission_awal_flutter_fundamental/ui/home_screen.dart';
import 'package:submission_awal_flutter_fundamental/ui/search_screen.dart';
import 'package:submission_awal_flutter_fundamental/utils/background_service.dart';
import 'package:submission_awal_flutter_fundamental/utils/notification_helper.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper notificationHelper = NotificationHelper();
  final BackgroundService service = BackgroundService();

  service.initializeIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await notificationHelper.initNotification(flutterLocalNotificationsPlugin);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RestaurantProvider(apiService: ApiService()),
        ),
        ChangeNotifierProvider(
          create: (_) => SearchProvider(apiService: ApiService()),
        ),
        ChangeNotifierProvider(
          create: (_) => AddReviewProvider(apiService: ApiService()),
        ),
        ChangeNotifierProvider(
          create: (_) => DatabaseProvider(databaseHelper: DatabaseHelper()),
        ),
        ChangeNotifierProvider(
          create: (_) => PreferencesProvider(
            preferencesHelper: PreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        initialRoute: HomeScreen.routeName,
        navigatorKey: navigatorKey,
        routes: {
          HomeScreen.routeName: (context) => const HomeScreen(),
          DetailScreen.routeName: (context) {
            final idRestaurant =
                ModalRoute.of(context)?.settings.arguments as String;
            return ChangeNotifierProvider(
              create: (_) => DetailRestaurantProvider(
                ModalRoute.of(context)?.settings.arguments as String,
                apiService: ApiService(),
              ),
              child: DetailScreen(idRestaurant: idRestaurant),
            );
          },
          SearchScreen.routeName: (context) => const SearchScreen(),
          AddReviewScreen.routeName: (context) => AddReviewScreen(
                idRestaurant:
                    ModalRoute.of(context)?.settings.arguments as String,
              ),
        },
      ),
    );
  }
}
