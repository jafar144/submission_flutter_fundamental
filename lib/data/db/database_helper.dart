import 'package:sqflite/sqflite.dart';
import 'package:submission_awal_flutter_fundamental/data/response/restaurant_response.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._() {
    _instance = this;
  }

  factory DatabaseHelper() => _instance ?? DatabaseHelper._();

  final String _dbName = 'restaurant.db';
  final String _tableFavorite = 'favorites';

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    return openDatabase(
      '$path/$_dbName',
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableFavorite (
            id TEXT PRIMARY KEY,
            name TEXT,
            description TEXT,
            pictureId TEXT,
            city TEXT,
            rating REAL
          )
        ''');
      },
      version: 1,
    );
  }

  Future<Database> get database async => _database ?? await _initializeDb();

  Future<List<Restaurant>> getFavorites() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(_tableFavorite);

    return results
        .map((restaurant) => Restaurant.fromJson(restaurant))
        .toList();
  }

  Future<Map<String, dynamic>> getFavoriteById(String id) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      _tableFavorite,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    }
    return {};
  }

  Future insertFavorite(Restaurant restaurant) async {
    final db = await database;
    await db.insert(_tableFavorite, restaurant.toJson());
  }

  Future deleteFavorite(String id) async {
    final db = await database;
    await db.delete(
      _tableFavorite,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
