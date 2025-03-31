import 'package:ace_routes/database/databse_helper.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/orderPartsModel.dart';

class GetOrderPartTable {
  static const String tableName = 'orderPart_data';

  // Create the OrderData table
  static Future<void> onCreate(Database db) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id TEXT PRIMARY KEY,
        oid TEXT,
        tid TEXT,
        sku TEXT,
        qty TEXT,
        upd TEXT,
        by TEXT
      )
    ''');
  }

  // Insert data into the order_data table
  static Future<void> insertData(OrderParts orderData) async {
    final db = await DatabaseHelper().database;
    await db.insert(
      tableName,
      orderData.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fetch all data from the order_data table
  static Future<List<OrderParts>> fetchData() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) => OrderParts.fromMap(maps[i]));
  }

// Fetch data by OID
//   static Future<OrderParts?> fetchDataById(String id) async {
//     final db = await DatabaseHelper().database;
//
//     // Query the database
//     final List<Map<String, dynamic>> maps = await db.query(
//       tableName,
//       where: 'oid = ?',
//       whereArgs: [id],
//     );
//
//     // Check if data exists
//     if (maps.isNotEmpty) {
//       return OrderParts.fromMap(maps.first);
//     } else {
//       return null; // Return null if no data found
//     }
//   }

  static Future<List<OrderParts>> fetchDataByOid(String oid) async {
    final db = await DatabaseHelper().database;

    // Query the database for all matching records
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'oid = ?',
      whereArgs: [oid],
    );

    // Convert each map into an OrderParts object and return a list
    return maps.map((map) => OrderParts.fromMap(map)).toList();
  }

  //delete on the basis of id:::

  static Future<int> deleteById(String id) async {
    final db = await DatabaseHelper().database;

    // Delete the record with the given ID
    final int result = await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result > 0) {
      print("Successfully deleted record with ID: $id");
    } else {
      print("No record found with ID: $id");
    }

    return result; // Returns the number of rows deleted
  }

  // Clear all data from order_data table
  static Future<void> clearData() async {
    final db = await DatabaseHelper().database;
    await db.delete(tableName);
  }
}
