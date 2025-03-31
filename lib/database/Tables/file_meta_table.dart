import 'package:ace_routes/model/file_meta_model.dart';
import 'package:sqflite/sqflite.dart';

import '../databse_helper.dart';

class FileMetaTable {
  static const String tableName = "file_meta";

  static Future<void> onCreate(Database db) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id TEXT PRIMARY KEY,
        fname TEXT,
        oid TEXT,
        tid TEXT,
        mime TEXT,
        dtl TEXT,
        geo TEXT,
        frmkey TEXT,
        frmfldid TEXT,
        upd TEXT,
        by TEXT
      )
    ''');
  }

  static Future<void> insertFileMeta(FileMetaModel fileMeta, Database db) async {
    await db.insert(
      tableName,
      fileMeta.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> insertMultipleFileMeta(List<FileMetaModel> fileMetas, Database db) async {
    final batch = db.batch();
    for (var fileMeta in fileMetas) {
      batch.insert(
        tableName,
        fileMeta.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  static Future<List<FileMetaModel>> fetchAllFileMeta(Database db) async {
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return maps.map((map) => FileMetaModel.fromJson(map)).toList();
  }

  static Future<List<FileMetaModel>> getAllFileMeta() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return maps.map((map) => FileMetaModel.fromJson(map)).toList();
  }


}