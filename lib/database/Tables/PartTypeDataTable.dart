
import 'package:ace_routes/database/databse_helper.dart';
import 'package:ace_routes/model/Ptype.dart';
import 'package:sqflite/sqflite.dart';

class PartTypeDataTable {
  static const String tableName = 'part_type';

  // Create the table
  static Future<void> onCreate(Database db) async {

    await db.execute('''
      CREATE TABLE $tableName (
        id TEXT PRIMARY KEY,
        name TEXT,
        detail TEXT,
        unitPrice TEXT,
        unit TEXT,
        updatedBy TEXT,
        updatedDate TEXT
      )
    ''');
  }

  // Upgrade table logic (if needed)
  static Future<void> onUpgrade(Database db) async {
    await onCreate(db); // Here, simply calling onCreate for upgrade as an example
  }

  // Insert part type data into part_type table
  static Future<void> insertPartTypeData(PartTypeDataModel partTypeData) async {
    final db = await DatabaseHelper().database;

    await db.insert(
      tableName,
      partTypeData.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fetch all part type data
  static Future<List<PartTypeDataModel>> fetchPartTypeData() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) => PartTypeDataModel.fromJson(maps[i]));
  }

  //Fetch part type data on the basis of id

  static Future<PartTypeDataModel?> fetchPartTypeById(String id) async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?', // SQL WHERE clause
      whereArgs: [id], // Arguments for the WHERE clause
    );
    print("success in getting $id");

    // If data exists, return the first record as a GTypeModel object
    if (maps.isNotEmpty) {
      print("success in getting $id");
      return PartTypeDataModel.fromJson(maps.first);
    }else{
      print("not availble");
    }

    // If no data found, return null
    return null;
  }


  //Fetch the id of the table
  static Future<String?> fetchIdByName(String categoryName) async {
    try {
      Database db = await DatabaseHelper().database;

      // Query for the name
      List<Map<String, dynamic>> results = await db.query(
        tableName,
        where: 'name = ? COLLATE NOCASE',  // Use NOCASE for case-insensitive search
        whereArgs: [categoryName],
      );

      // Debug logs
      print("Query result for $categoryName: $results");

      // Return the id if found, otherwise return null
      return results.isNotEmpty ? results.first['id'] as String? : null;
    } catch (e) {
      print("Error fetching id: $e");
      return null;
    }
  }


  static Future<List<PartTypeDataModel>> fetchPartTypeAllDataById(String id) async {
    final db = await DatabaseHelper().database;

    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?', // Fetch all records with the same tid
      whereArgs: [id],
    );

    print("Success in getting data for tid: $id");

    // Convert the list of maps to a list of PartTypeDataModel objects
    return maps.isNotEmpty ? maps.map((e) => PartTypeDataModel.fromJson(e)).toList() : [];
  }



  //

  // Clear all part type data from the part_type table
  static Future<void> clearPartTypeData() async {
    final db = await DatabaseHelper().database;
    await db.delete(tableName);
  }
}
