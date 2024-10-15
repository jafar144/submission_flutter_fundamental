import 'dart:io';

import 'package:flutter/material.dart';
import 'package:submission_awal_flutter_fundamental/data/api/api_service.dart';
import 'package:submission_awal_flutter_fundamental/data/response/restaurant_response.dart';
import 'package:submission_awal_flutter_fundamental/utils/result_state.dart';

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantProvider({required this.apiService}) {
    _getRestaurants();
  }

  late ResultState _state;
  String _message = "";
  late RestaurantResponse _result;

  ResultState get state => _state;
  String get message => _message;
  RestaurantResponse get result => _result;

  Future<dynamic> _getRestaurants() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurants = await apiService.getRestaurants();
      if (restaurants.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Restaurant is empty. Please check another time';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _result = restaurants;
      }
    } on SocketException catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = e.message;
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = "There is problem. Try Again: $e";
    }
  }
}
