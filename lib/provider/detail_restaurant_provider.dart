import 'dart:io';

import 'package:flutter/material.dart';
import 'package:submission_awal_flutter_fundamental/data/api/api_service.dart';
import 'package:submission_awal_flutter_fundamental/data/response/detail_restaurant_response.dart';
import 'package:submission_awal_flutter_fundamental/utils/result_state.dart';

class DetailRestaurantProvider extends ChangeNotifier {
  final ApiService apiService;
  final String idRestaurant;

  DetailRestaurantProvider(this.idRestaurant, {required this.apiService}) {
    _state = ResultState.loading;
    _result = null;
  }

  late ResultState _state;
  late DetailRestaurantResponse? _result;
  String _message = "";

  ResultState get state => _state;
  DetailRestaurantResponse? get result => _result;
  String get message => _message;

  Future<dynamic> getDetailRestaurant(String idRestaurant) async {
    _state = ResultState.loading;
    notifyListeners();
    try {
      final detailRestaurant =
          await apiService.getDetailRestaurant(idRestaurant);
      if (detailRestaurant == null) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = "No Data";
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _result = detailRestaurant;
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
