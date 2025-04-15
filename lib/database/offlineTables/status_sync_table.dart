import 'package:ace_routes/database/databse_helper.dart';
import 'package:sqflite/sqflite.dart';

class StatusSyncTable {
  static const String tableName = 'sync_queue';

  // Create table
  static Future<void> onCreate(Database db) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_id TEXT NOT NULL,
        new_wkf TEXT NOT NULL,
        synced INTEGER DEFAULT 0
      )
    ''');
    print("Table '$tableName' created successfully.");
  }

  // Insert new offline data
  static Future<void> insert(String orderId, String newWkf) async {
    final db = await DatabaseHelper().database;

    await db.insert(
      tableName,
      {
        'order_id': orderId,
        'new_wkf': newWkf,
        'synced': 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    print("Inserted offline sync data for order_id: $orderId");
  }

  // Get all unsynced records
  static Future<List<Map<String, dynamic>>> getUnsynced() async {
    final db = await DatabaseHelper().database;

    return await db.query(
      tableName,
      where: 'synced = ?',
      whereArgs: [0],
    );
  }

  // Mark a record as synced
  static Future<void> markSynced(int id) async {
    final db = await DatabaseHelper().database;

    await db.update(
      tableName,
      {'synced': 1},
      where: 'id = ?',
      whereArgs: [id],
    );

    print("Marked id $id as synced.");
    clearSynced();
  }

  // Optional: Clear all synced data
  static Future<void> clearSynced() async {
    final db = await DatabaseHelper().database;

    await db.delete(
      tableName,
      where: 'synced = ?',
      whereArgs: [1],
    );

    print("Cleared all synced data.");
  }
}
