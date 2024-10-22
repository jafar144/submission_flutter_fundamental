import 'package:flutter/material.dart';
import 'package:submission_awal_flutter_fundamental/data/db/database_helper.dart';
import 'package:submission_awal_flutter_fundamental/data/response/restaurant_response.dart';
import 'package:submission_awal_flutter_fundamental/utils/result_state.dart';

class DatabaseProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  DatabaseProvider({required this.databaseHelper}) {
    _getAllFavorites();
  }

  ResultState _state = ResultState.loading;
  ResultState get state => _state;

  String _message = '';
  String get messsage => _message;

  List<Restaurant> _favorites = [];
  List<Restaurant> get favorites => _favorites;

  void _getAllFavorites() async {
    _favorites = await databaseHelper.getFavorites();
    if (_favorites.isNotEmpty) {
      _state = ResultState.hasData;
    } else {
      _state = ResultState.noData;
      _message = 'Resto favorite kamu kosong nich';
    }
    notifyListeners();
  }

  void addFavorite(Restaurant restaurant) async {
    try {
      await databaseHelper.insertFavorite(restaurant);
      _getAllFavorites();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Terjadi kesalahan. Silahkan coba lagi';
      notifyListeners();
    }
  }

  void deleteFavorite(String id) async {
    try {
      await databaseHelper.deleteFavorite(id);
      _getAllFavorites();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Terjadi kesalahan. Silahkan coba lagi';
      notifyListeners();
    }
  }

  Future<bool> isFavorite(String id) async {
    final getFavoriteById = await databaseHelper.getFavoriteById(id);
    return getFavoriteById.isNotEmpty;
  }
}
