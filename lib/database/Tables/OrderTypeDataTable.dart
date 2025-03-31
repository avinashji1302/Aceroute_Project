import 'package:ace_routes/model/OrderTypeModel.dart';
import 'package:sqflite/sqflite.dart';

import '../databse_helper.dart';

class OrderTypeDataTable {
  static const String tableName = 'order_types';

  // Create the table
  // Create the table
  static Future<void> onCreate(Database db) async {
    await db.execute('''
      CREATE TABLE $tableName (
       id TEXT PRIMARY KEY,
      name TEXT,
      abbreviation TEXT,
      duration TEXT,
      capacity TEXT,
      parentId TEXT,
      customTimeSlot TEXT,
      elapseTimeSlot TEXT,
      value TEXT,
      externalId TEXT,
      updateTimestamp TEXT,
      updatedBy TEXT
      )
    ''');
  }

  // Insert order type data
  static Future<void> insertOrderTypeData( OrderTypeModel orderType) async {
    final db = await DatabaseHelper().database;

    await db.insert(
      tableName,
      orderType.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fetch all order type data
  static Future<List<OrderTypeModel>> fetchAllOrderTypes() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return maps.map((map) => OrderTypeModel.fromMap(map)).toList();
  }


 // Getting Category name

  static Future<Map<String, String?>> fetchCategoriesByIds(List<String> tidIds) async {
    Map<String, String?> resultMap = {};
    try {
      Database db = await DatabaseHelper().database;
      for (String id in tidIds) {
        print("tid search $id");

        // Query for the id
        List<Map<String, dynamic>> results = await db.query(
          tableName,
          where: 'id = ? COLLATE NOCASE',  // Use NOCASE for case-insensitive search
          whereArgs: [id],
        );

        // Debug logs
        print("Query result for $id: $results");

        // Assign the value to the result map
        resultMap[id] = results.isNotEmpty ? (results.first['name'] ?? '') : null;
      }
    } catch (e) {
      print("Error fetching categories: $e");
    }
    return resultMap;
  }




  // Clear all data
  static Future<void> clearOrderTypeData() async {
    final db = await DatabaseHelper().database;
    await db.delete(tableName);
  }
}
