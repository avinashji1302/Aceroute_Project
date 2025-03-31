import 'package:sqflite/sqflite.dart';
import '../../model/order_note_model.dart';
import '../databse_helper.dart';

class OrderNoteTable {
  static const String tableName = "orderNote";

  // Create the table
  static Future<void> onCreate(Database db) async {
    await db.execute(
      '''
      CREATE TABLE $tableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        data TEXT
      )
      ''',
    );
  }

  // Handle table upgrades
  static Future<void> onUpgrade(Database db) async {
    await onCreate(db);
  }

  // Insert a single value into the OrderNote table
  static Future<void> insertOrderNote(OrderNoteModel orderNoteModel) async {
    final db = await DatabaseHelper().database;
    // Clear existing records before inserting new data
    await clearOrderNote();
    await db.insert(
      tableName,
      orderNoteModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fetch all records
  static Future<List<OrderNoteModel>> fetchOrderNote() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(
      maps.length,
          (i) => OrderNoteModel.fromMap(maps[i]),
    );
  }

  // Clear all records
  static Future<void> clearOrderNote() async {
    final db = await DatabaseHelper().database;
    await db.delete(tableName);
  }
}
