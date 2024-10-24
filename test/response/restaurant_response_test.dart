import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:submission_awal_flutter_fundamental/data/response/restaurant_response.dart';

void main() {
  group('Restaurant Model Test', () {
    test('Parsing from JSON to Restaurant', () {
      // arrange
      const restaurantId = "rqdv5juczeskfw1e867";
      const jsonInString =
          '{"id": "$restaurantId", "name": "Hotpot", "description": "Lorem ipsum dolor asit amet", "pictureId": "25", "city": "Gorontalo", "rating": 4}';

      // act
      final restaurant = Restaurant.fromJson(json.decode(jsonInString));

      // assert
      expect(restaurant.id, restaurantId);
    });
  });
}
