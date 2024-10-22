import 'package:flutter/material.dart';
import 'package:submission_awal_flutter_fundamental/ui/favorite_screen.dart';
import 'package:submission_awal_flutter_fundamental/ui/list_restaurant_screen.dart';
import 'package:submission_awal_flutter_fundamental/ui/setting_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _bottomNavigationIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _listBottomNavigation[_bottomNavigationIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _bottomNavigationIndex,
        onTap: (selected) {
          setState(() {
            _bottomNavigationIndex = selected;
          });
        },
        selectedItemColor: Colors.purple,
      ),
    );
  }

  final List<Widget> _listBottomNavigation = [
    const ListRestaurantScreen(),
    const FavoriteScreen(),
    const SettingScreen(),
  ];
}
