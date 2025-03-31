import 'package:ace_routes/database/databse_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ace_routes/model/login_model/token_api_response.dart';

class ApiDataTable {
  static const String tableName = 'api_data';

  static Future<void> onCreate(Database db) async {
    await db.execute('''
      CREATE TABLE $tableName (
        requestId TEXT PRIMARY KEY,
        responderName TEXT,
        geoLocation TEXT,
        nspId TEXT,
        gpsSync TEXT,
        locationChange TEXT,
        shiftDateLock TEXT,
        shiftError TEXT,
        endValue TEXT,
        speed TEXT,
        multiLeg TEXT,
        uiConfig TEXT,
        token TEXT
      )
    ''');
  }

  // Insert data into the api_data table
  static Future<void> insertData(TokenApiReponse response) async {
    final db = await DatabaseHelper().database;
    await db.insert(
      tableName,
      response.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fetch all data from the api_data table
  static Future<List<TokenApiReponse>> fetchData() async {
    final db = await DatabaseHelper().database;

    final List<Map<String, dynamic>> maps = await db.query(tableName);

    if (maps.isEmpty) {
      print("No data found in the table.");
    }
    return List.generate(maps.length, (i) => TokenApiReponse.fromMap(maps[i]));
  }

  // Clear all data from api_data table
  static Future<void> clearData() async {
    final db = await DatabaseHelper().database;
    await db.delete(tableName);
  }
}
