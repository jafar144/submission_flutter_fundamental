import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_awal_flutter_fundamental/provider/database_provider.dart';
import 'package:submission_awal_flutter_fundamental/utils/result_state.dart';
import 'package:submission_awal_flutter_fundamental/widgets/card_restaurant.dart';

class FavoriteScreen extends StatelessWidget {
  static String routeName = '/favorites';

  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _listFavoriteRestaurant(),
      ),
    );
  }

  Widget _listFavoriteRestaurant() {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        if (provider.state == ResultState.hasData) {
          return ListView.builder(
            itemBuilder: (context, index) {
              return cardRestaurant(context, provider.favorites[index]);
            },
            itemCount: provider.favorites.length,
          );
        } else if (provider.state == ResultState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Center(child: Text(provider.messsage));
        }
      },
    );
  }
}
