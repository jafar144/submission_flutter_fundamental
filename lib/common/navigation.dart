import 'package:flutter/cupertino.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class Navigation {
  static intentWithData(String routeName, Object arguments) {
    navigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
  }

  static intentWithoutData(String routeName) =>
      navigatorKey.currentState?.pushNamed(routeName);

  static backWithData(bool result) => navigatorKey.currentState?.pop(result);

  static back() => navigatorKey.currentState?.pop();
}
