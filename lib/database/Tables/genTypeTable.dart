import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../../model/GTypeModel.dart';
import '../databse_helper.dart';

class GTypeTable {
  static const String tableName = 'gen_type';

  // Create the gen_type table
  static Future<void> onCreate(Database db) async {
    await db.execute('''
    CREATE TABLE $tableName (
      id TEXT PRIMARY KEY,    
      name TEXT,
      typeId TEXT,
      capacity TEXT,   
      details TEXT,
      externalId TEXT,
      updateTimestamp TEXT,
      updatedBy TEXT
    )
  ''');
  }

  // Upgrade logic for the gen_type table
  static Future<void> onUpgrade(Database db) async {
    await onCreate(db); // Re-create the table if upgrading
  }

  // Insert GType into the gen_type table
  static Future<void> insertGType(GTypeModel gtype) async {
    final db = await DatabaseHelper().database;
    //  fetchGTypes(); // Optional: Refresh GTypes after insertion

    // Convert details map to JSON string
    String detailsJson = jsonEncode(gtype.details);

    // print("database details :: $detailsJson");

    // Prepare data to insert
    final gtypeMap = gtype.toJson();
    gtypeMap['details'] = detailsJson; // Ensure 'details' is a valid string

    await db.insert(
      tableName,
      gtypeMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fetch all GTypes
  static Future<List<GTypeModel>> fetchGTypes() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) => GTypeModel.fromJson(maps[i]));
  }

  // Fetch GType by ID
  static Future<GTypeModel?> fetchGTypeById(String id) async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?', // SQL WHERE clause
      whereArgs: [id], // Arguments for the WHERE clause
    );

    // If data exists, return the first record as a GTypeModel object
    if (maps.isNotEmpty) {
    //  print("success in getting $id");
      return GTypeModel.fromJson(maps.first);
    } else {
      print("mot found");
    }

    // If no data found, return null
    return null;
  }

  // Fetch GType by TID
  // Fetch GType by TID (matching any of the IDs in the 'capacity' column)
// Fetch GType by TID (matching any of the IDs in the 'capacity' column)
//   static Future<List<GTypeModel>> fetchGTypeByTid(String tid) async {
//     final db = await DatabaseHelper().database;
//
//     // Create a list of patterns to check for the matching 'tid' in 'capacity'
//     List<String> patterns = [
//       '%|$tid|%', // Match tid surrounded by pipe symbols (e.g., |1045582131|)
//       '$tid|%',   // Match tid at the start (e.g., 1045582131|)
//       '%|$tid',   // Match tid at the end (e.g., |1045582131)
//       '$tid'      // Match tid alone (e.g., 1045582131)
//     ];
//
//     // Create a query with an OR condition to check if any of the patterns match
//     final List<Map<String, dynamic>> maps = await db.query(
//       tableName,
//       where: 'capacity LIKE ? OR capacity LIKE ? OR capacity LIKE ? OR capacity LIKE ?',
//       whereArgs: patterns, // Pass the patterns list as arguments
//     );
//
//     // If data exists, convert each map to a GTypeModel and return a list
//     if (maps.isNotEmpty) {
//       print("Success in getting records for typeId: $tid");
//       return List.generate(maps.length, (i) => GTypeModel.fromJson(maps[i]));
//     } else {
//       print("No records found for typeId: $tid");
//     }
//
//     // If no data found, return an empty list
//     return [];
//   }

  static Future<List<GTypeModel>> fetchGTypeByTid(String tid) async {
    final db = await DatabaseHelper().database;

    // Create a list of patterns to check for the matching 'tid' in 'capacity'
    List<String> patterns = [
      '%|$tid|%', // Match tid surrounded by pipe symbols (e.g., |1045582131|)
      '$tid|%', // Match tid at the start (e.g., 1045582131|)
      '%|$tid', // Match tid at the end (e.g., |1045582131)
      '$tid' // Match tid alone (e.g., 1045582131)
    ];

    // Debug: Log the patterns being used
  //  print("Debug: Patterns for tid: $patterns");

    // Update the query to include an additional condition for empty 'capacity'
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: '''
      capacity LIKE ? OR capacity LIKE ? OR capacity LIKE ? OR capacity LIKE ? 
      OR capacity IS NULL OR TRIM(capacity) = ''
    ''', // Use TRIM to handle spaces in the capacity field
      whereArgs: patterns, // Pass the patterns list as arguments
    );

    // Debug: Log the raw results from the database query
   // print("Debug: Raw database query results for tid $tid: $maps");

    // If data exists, convert each map to a GTypeModel and return a list
    if (maps.isNotEmpty) {
      print("Debug: Success in getting records for typeId: $tid");
      return List.generate(maps.length, (i) => GTypeModel.fromJson(maps[i]));
    } else {
      print("Debug: No records found for typeId: $tid");
    }

    // If no data found, return an empty list
    return [];
  }

  // Clear all GTypes
  static Future<void> clearGTypes() async {
    final db = await DatabaseHelper().database;
    await db.delete(tableName);
  }
}
