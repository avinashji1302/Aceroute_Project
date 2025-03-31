import 'package:ace_routes/database/databse_helper.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/priority_model.dart';

class PriorityTable {
  static const String tableName = 'priority';

  static Future<void> onCreate(Database db) async {
    await db.execute('''
    create Table $tableName(
      id TEXT PRIMARY KEY, 
      name TEXT, 
      color TEXT
    )
  ''');
  }

  // Upgrade table logic (if needed)
  static Future<void> onUpgrade(Database db) async {
    await onCreate(
        db); // Here, simply calling onCreate for upgrade as an example
  }

  // Insert Data
  static Future<void> insertPriority(Priority priority) async {
    final db = await DatabaseHelper().database;
    await db.insert(tableName, priority.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

// Fetch priority names for a list of IDs
  static Future<Map<String, String?>> fetchPrioritiesByIds(
      List<String> priorityIds) async {
    Map<String, String?> resultMap = {};
    try {
      Database db = await DatabaseHelper().database;

      for (String id in priorityIds) {
        print("Fetching priority for ID: $id");

        // Query database for each ID
        List<Map<String, dynamic>> results = await db.query(
          tableName,
          columns: ['id', 'name'], // Fetch only required columns
          where: 'id = ? COLLATE NOCASE', // Case-insensitive search
          whereArgs: [id],
        );

        // Debug log
        print("Query result for $id: $results");

        // Add to result map
        resultMap[id] =
            results.isNotEmpty ? results.first['name'] as String? : null;
      }
    } catch (e) {
      print("Error fetching priorities: $e");
    }
    return resultMap;
  }

  // Fetch priority colors for a list of IDs
  static Future<Map<String, String?>> fetchPrioritiesColorsByIds(
      List<String> priorityIds) async {
    Map<String, String?> resultMap = {};
    try {
      Database db = await DatabaseHelper().database;

      for (String id in priorityIds) {
        print("Fetching priority for ID: $id");

        // Query database for each ID
        List<Map<String, dynamic>> results = await db.query(
          tableName,
          columns: ['id', 'color'], // Fetch only required columns
          where: 'id = ? COLLATE NOCASE', // Case-insensitive search
          whereArgs: [id],
        );

        // Debug log
        print("Query result for $id: $results");

        // Add to result map
        resultMap[id] =
        results.isNotEmpty ? results.first['color'] as String? : null;
      }
    } catch (e) {
      print("Error fetching priorities: $e");
    }
    return resultMap;
  }
}
