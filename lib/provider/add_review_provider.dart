import 'dart:io';

import 'package:flutter/material.dart';
import 'package:submission_awal_flutter_fundamental/data/api/api_service.dart';
import 'package:submission_awal_flutter_fundamental/data/response/detail_restaurant_response.dart';
import 'package:submission_awal_flutter_fundamental/utils/result_state.dart';

class AddReviewProvider extends ChangeNotifier {
  final ApiService apiService;

  AddReviewProvider({required this.apiService});

  late ResultState _state;
  late CustomerReview _result;
  String _message = '';

  ResultState get state => _state;
  CustomerReview get result => _result;
  String get message => _message;

  Future<dynamic> addReview(
      String idRestaurant, String name, String review) async {
    _state = ResultState.loading;
    notifyListeners();
    try {
      final result = await apiService.addReview(idRestaurant, name, review);
      if (result.error == false) {
        _state = ResultState.hasData;
        _message = result.message;
        notifyListeners();
        return _message;
      } else {
        _state = ResultState.noData;
        _message = result.message;
        notifyListeners();
        return _message;
      }
    } on SocketException catch (e) {
      _state = ResultState.error;
      _message = e.message;
      notifyListeners();
      return _message;
    } catch (e) {
      _state = ResultState.error;
      _message = "There is problem. Try Again: $e";
      notifyListeners();
      return _message;
    }
  }
}
