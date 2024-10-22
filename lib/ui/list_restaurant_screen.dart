import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_awal_flutter_fundamental/common/navigation.dart';
import 'package:submission_awal_flutter_fundamental/provider/restaurant_provider.dart';
import 'package:submission_awal_flutter_fundamental/ui/search_screen.dart';
import 'package:submission_awal_flutter_fundamental/utils/result_state.dart';
import 'package:submission_awal_flutter_fundamental/widgets/card_restaurant.dart';

class ListRestaurantScreen extends StatelessWidget {
  const ListRestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("My Restaurants"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: InkWell(
              child: const Icon(Icons.search),
              // onTap: () => Navigator.pushNamed(context, SearchScreen.routeName),
              onTap: () => Navigation.intentWithoutData(SearchScreen.routeName),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildRestaurantList(context),
      ),
    );
  }

  Widget _buildRestaurantList(BuildContext context) {
    return Consumer<RestaurantProvider>(
      builder: (context, provider, _) {
        switch (provider.state) {
          case ResultState.loading:
            return const Center(child: CircularProgressIndicator());
          case ResultState.hasData:
            return ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: ListView.builder(
                itemCount: provider.result.restaurants.length,
                itemBuilder: (context, index) {
                  return cardRestaurant(
                    context,
                    provider.result.restaurants[index],
                  );
                },
              ),
            );
          case ResultState.noData:
            return const Center(
              child: Text('No tidak ada data'),
            );
          case ResultState.error:
            return Center(
              child: Text(
                provider.message,
                textAlign: TextAlign.center,
              ),
            );
        }
      },
    );
  }
}
