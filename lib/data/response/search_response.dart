import 'package:submission_awal_flutter_fundamental/data/response/restaurant_response.dart';

class SearchRestaurantResponse {
  final bool error;
  final int founded;
  final List<Restaurant> restaurants;

  SearchRestaurantResponse({
    required this.error,
    required this.founded,
    required this.restaurants,
  });

  factory SearchRestaurantResponse.fromJson(Map<String, dynamic> json) =>
      SearchRestaurantResponse(
        error: json["error"],
        founded: json["founded"],
        restaurants: List<Restaurant>.from(
            json["restaurants"].map((x) => Restaurant.fromJson(x))),
      );
}
