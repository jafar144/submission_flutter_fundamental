import 'dart:isolate';
import 'dart:ui';

import 'package:submission_awal_flutter_fundamental/data/api/api_service.dart';
import 'package:submission_awal_flutter_fundamental/main.dart';
import 'package:submission_awal_flutter_fundamental/utils/notification_helper.dart';

final ReceivePort port = ReceivePort();

class BackgroundService {
  static BackgroundService? _instance;
  static const String _isolateName = 'isolate';
  static SendPort? _uiSendPort;

  BackgroundService._() {
    _instance = this;
  }

  factory BackgroundService() => _instance ?? BackgroundService._();

  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      _isolateName,
    );
  }

  static Future<void> callback() async {
    final NotificationHelper notificationHelper = NotificationHelper();
    var result = await ApiService().getRestaurants();
    await notificationHelper.showNotification(
      flutterLocalNotificationsPlugin,
      result,
    );

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }
}
