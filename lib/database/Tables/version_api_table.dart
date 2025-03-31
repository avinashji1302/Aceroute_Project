import 'package:ace_routes/database/databse_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ace_routes/model/login_model/version_model.dart';

class VersionApiTable {
  static const String tableName = 'api_version';

  static Future<void> onCreate(Database db) async {
    await db.execute('''
      CREATE TABLE $tableName (
        success TEXT,
        id TEXT,
        UNIQUE(id)
      )
    ''');
  }

  static Future<void> onUpgrade(Database db) async {
    await onCreate(db);
  }

  // Insert version data into api_version table
  static Future<void> insertVersionData(VersionModel version) async {
    final db = await DatabaseHelper().database;
    await clearVersionData();
    await db.insert(
      tableName,
      version.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );


  }

  // Fetch all API version data
  static Future<List<VersionModel>> fetchVersionData() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) => VersionModel.fromJson(maps[i]));
  }

  // Clear all api_version data
  static Future<void> clearVersionData() async {
    final db = await DatabaseHelper().database;
    await db.delete(tableName);
  }
}
