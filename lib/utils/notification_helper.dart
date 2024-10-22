import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:submission_awal_flutter_fundamental/common/navigation.dart';
import 'package:submission_awal_flutter_fundamental/data/response/restaurant_response.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  static NotificationHelper? _instance;

  NotificationHelper._() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._();

  Future<dynamic> initNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
  ) async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS = const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) async {
        final payload = details.payload;
        if (payload != null) {
          debugPrint('Notification payload: $payload');
        }
        selectNotificationSubject.add(payload ?? 'empty payload');
      },
    );
  }

  Future<dynamic> showNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    RestaurantResponse restaurant,
  ) async {
    var channelId = "1";
    var channelName = "reminder_restaurant";
    var channelDescription = "Reminder Restaurant Channel";

    var androidPlatformChannelSpesifics = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      styleInformation: const DefaultStyleInformation(true, true),
    );

    var iOSPlatformChannelSpesifics = const DarwinNotificationDetails();
    var platformChannelSpesifics = NotificationDetails(
      android: androidPlatformChannelSpesifics,
      iOS: iOSPlatformChannelSpesifics,
    );

    var titleNotification = "<b>Recommendation Restaurant</b>";
    var titleNews = restaurant.restaurants[0].name;

    await flutterLocalNotificationsPlugin.show(
      0,
      titleNotification,
      titleNews,
      platformChannelSpesifics,
      payload: json.encode(restaurant.toJson()),
    );
  }

  void configureSelectNotificationSubject(String route) {
    selectNotificationSubject.stream.listen((String payload) async {
      var data = RestaurantResponse.fromJson(json.decode(payload));
      var restaurant = data.restaurants[0];
      Navigation.intentWithData(route, restaurant);
    });
  }
}
