import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:submission_awal_flutter_fundamental/model/restaurant_response.dart';
import 'package:submission_awal_flutter_fundamental/ui/detail_screen.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("My Restaurants"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<String>(
          future: DefaultAssetBundle.of(context)
              .loadString('assets/restaurant.json'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("Error Loading Data"),
              );
            } else if (snapshot.hasData) {
              final List<Restaurant> restaurants =
                  restaurantResponseFromJson(snapshot.data.toString())
                      .restaurants;
              return ListView.builder(
                itemCount: restaurants.length,
                itemBuilder: (context, index) {
                  return _buildRestaurantItem(context, restaurants[index]);
                },
              );
            } else {
              return const Center(
                child: Text("No data available"),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildRestaurantItem(BuildContext context, Restaurant restaurant) {
    return GestureDetector(
      child: Card(
        color: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              restaurant.pictureId,
              height: 130,
              fit: BoxFit.cover,
              errorBuilder: (context, error, _) =>
                  const Center(child: Icon(Icons.error)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        restaurant.name,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'images/star.svg',
                            width: 15,
                            height: 15,
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            restaurant.rating.toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'images/clock.svg',
                            width: 12,
                            height: 12,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 6.0),
                            child: Text(
                              "25 mins",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.0),
                        child: Text("•"),
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'images/dollar.svg',
                            width: 12,
                            height: 12,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 6.0),
                            child: Text(
                              "\$\$\$",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 1,
                      ),
                      SvgPicture.asset(
                        'images/location.svg',
                        height: 12,
                        width: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 6.0),
                        child: Text(
                          restaurant.city,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () => Navigator.pushNamed(context, DetailScreen.routeName,
          arguments: restaurant),
    );
  }
}
