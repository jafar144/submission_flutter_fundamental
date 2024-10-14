import 'package:flutter/foundation.dart';
import 'package:submission_awal_flutter_fundamental/data/api/dio_config.dart';
import 'package:submission_awal_flutter_fundamental/data/response/detail_restaurant_response.dart';
import 'package:submission_awal_flutter_fundamental/data/response/restaurant_response.dart';
import 'package:submission_awal_flutter_fundamental/data/response/search_response.dart';

class ApiService {
  // [GET] All Restaurant
  Future<RestaurantResponse> getRestaurants() async {
    var dioConfig = DioConfig();
    try {
      final response = await dioConfig.request('list', DioMethod.get);
      if (response.statusCode == 200) {
        debugPrint('Berhasil masuk');
        debugPrint(response.data.runtimeType.toString());
        debugPrint('Response data ${response.data}');
        return RestaurantResponse.fromJson(response.data);
      } else {
        throw Exception(response.statusMessage);
      }
    } catch (e) {
      throw Exception('There\'s problem: $e');
    }
  }

  // [GET] Detail Restaurant
  Future<DetailRestaurantResponse> getDetailRestaurant(
      String idRestaurant) async {
    var dioConfig = DioConfig();
    try {
      final response =
          await dioConfig.request('detail/$idRestaurant', DioMethod.get);
      if (response.statusCode == 200) {
        return DetailRestaurantResponse.fromJson(response.data);
      } else {
        throw Exception(response.statusMessage);
      }
    } catch (e) {
      throw Exception('There\'s problem: $e');
    }
  }

  // [GET] Search Restaurant
  Future<SearchRestaurantResponse> searchRestaurant(String query) async {
    var dioConfig = DioConfig();
    try {
      final response = await dioConfig.request(
        'search',
        DioMethod.get,
        param: {'q': query},
      );
      if (response.statusCode == 200) {
        return SearchRestaurantResponse.fromJson(response.data);
      } else {
        throw Exception(response.statusMessage);
      }
    } catch (e) {
      throw Exception('There\'s problem: $e');
    }
  }
}
