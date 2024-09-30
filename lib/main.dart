import 'package:flutter/material.dart';
import 'package:submission_awal_flutter_fundamental/model/restaurant_response.dart';
import 'package:submission_awal_flutter_fundamental/ui/detail_screen.dart';
import 'package:submission_awal_flutter_fundamental/ui/home_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => const HomeScreen(),
        DetailScreen.routeName: (context) => DetailScreen(
              restaurant:
                  ModalRoute.of(context)?.settings.arguments as Restaurant,
            )
      },
    );
  }
}
