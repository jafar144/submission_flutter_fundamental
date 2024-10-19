import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_awal_flutter_fundamental/data/api/api_service.dart';
import 'package:submission_awal_flutter_fundamental/provider/detail_restaurant_provider.dart';
import 'package:submission_awal_flutter_fundamental/provider/restaurant_provider.dart';
import 'package:submission_awal_flutter_fundamental/ui/add_review_screen.dart';
import 'package:submission_awal_flutter_fundamental/ui/detail_screen.dart';
import 'package:submission_awal_flutter_fundamental/ui/home_screen.dart';
import 'package:submission_awal_flutter_fundamental/ui/search_screen.dart';

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
        HomeScreen.routeName: (context) => ChangeNotifierProvider(
              create: (_) => RestaurantProvider(apiService: ApiService()),
              child: const HomeScreen(),
            ),
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
    );
  }
}
