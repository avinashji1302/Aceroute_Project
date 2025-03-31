import 'package:ace_routes/database/databse_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ace_routes/model/login_model/login_response.dart';

class LoginResponseTable {
  static const String tableName = 'login_response';

  static Future<void> onCreate(Database db) async {
    await db.execute('''
      CREATE TABLE $tableName (
   subkey TEXT,
    nsp TEXT,
    url TEXT,
    UNIQUE(nsp, url)
      )
    ''');
  }

  static Future<void> onUpgrade(Database db) async {
    await onCreate(db);
  }

  // Insert login response data into login_response table
  static Future<void> insertLoginResponse(LoginResponse loginResponse) async {
    final db = await DatabaseHelper().database;
    await clearLoginResponse();
    await db.insert(
      tableName,
      loginResponse.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fetch login response data
  static Future<List<LoginResponse>> fetchLoginResponses() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) => LoginResponse.fromMap(maps[i]));
  }

  // Clear all login response data
  static Future<void> clearLoginResponse() async {
    final db = await DatabaseHelper().database;
    await db.delete(tableName);
  }
}
