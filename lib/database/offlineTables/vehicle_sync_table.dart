import 'package:ace_routes/database/databse_helper.dart';
import 'package:sqflite/sqflite.dart';

class VehicleSyncTable {
  static const String tableName = 'vehicle_sync'; // Fixed typo from 'vehicke_sync'

  /// Create table
  static Future<void> onCreate(Database db) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_id TEXT NOT NULL,
        alt TEXT,
        po TEXT,
        dtl TEXT,
        inv TEXT,
        note TEXT,
        synced INTEGER DEFAULT 0
      )
    ''');
    print("✅ Vehicle details sync table created.");
  }

  /// Insert unsynced data
  static Future<void> insert(String oid, Map<String, String> updatedData) async {
    final db = await DatabaseHelper().database;

    await db.insert(
      tableName,
      {
        'order_id': oid,
        'alt': updatedData['faultDesc'] ?? '',
        'po': updatedData['registration'] ?? '',
        'dtl': updatedData['details'] ?? '',
        'inv': updatedData['odometer'] ?? '',
        'note': updatedData['notes'] ?? '',
        'synced': 0
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    print("✅ Inserted vehicle details for order_id: $oid");
  }

  /// Fetch unsynced records
  static Future<List<Map<String, dynamic>>> getUnsynced() async {
    final db = await DatabaseHelper().database;

    return await db.query(
      tableName,
      where: 'synced = ?',
      whereArgs: [0],
    );
  }

  /// Mark record as synced
  static Future<void> markSynced(int id) async {
    final db = await DatabaseHelper().database;

    await db.update(
      tableName,
      {'synced': 1},
      where: 'id = ?',
      whereArgs: [id],
    );

    print("✅ Marked vehicle sync record $id as synced.");
    await clearSynced(); // Optional cleanup
  }

  /// Optional: clear all synced records
  static Future<void> clearSynced() async {
    final db = await DatabaseHelper().database;

    await db.delete(
      tableName,
      where: 'synced = ?',
      whereArgs: [1],
    );

    print("🧹 Cleared all synced vehicle records.");
  }
}
