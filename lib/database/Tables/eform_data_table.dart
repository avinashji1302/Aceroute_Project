import 'dart:convert';
import 'package:ace_routes/database/databse_helper.dart';
import 'package:ace_routes/model/eform_data_model.dart';
import 'package:sqflite/sqflite.dart';

class EFormDataTable {
  static const String tableName = 'eFormsDataTable';

  // Table creation method
  static Future<void> onCreate(Database db) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id TEXT PRIMARY KEY,
        oid TEXT,
        ftid TEXT,
        frmKey TEXT,
        formFields TEXT,
        updatedTimestamp TEXT,
        updatedBy TEXT
      )
    ''');
  }

  // Insert data method - Serialize formFields to JSON string before saving
  static Future<void> insertEForm(EFormDataModel eForm) async {
    final db = await DatabaseHelper().database;
    // Convert formFields to JSON string before saving
    final formFieldsJson = json.encode(eForm.formFields);
    final data = {
      'id': eForm.id,
      'oid': eForm.oid,
      'ftid': eForm.ftid,
      'frmKey': eForm.frmKey,
      'formFields': formFieldsJson,
      'updatedTimestamp': eForm.updatedTimestamp,
      'updatedBy': eForm.updatedBy,
    };

    await db.insert(tableName, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> insertMultipleEForms(List<EFormDataModel> eForms) async {
    final db = await DatabaseHelper().database;
    final batch = db.batch();
    for (var eForm in eForms) {
      final formFieldsJson = json.encode(eForm.formFields);
      final data = {
        'id': eForm.id,
        'oid': eForm.oid,
        'ftid': eForm.ftid,
        'frmKey': eForm.frmKey,
        'formFields': formFieldsJson,
        'updatedTimestamp': eForm.updatedTimestamp,
        'updatedBy': eForm.updatedBy,
      };

      // Add insert operation to batch
      batch.insert(tableName, data,
          conflictAlgorithm: ConflictAlgorithm.ignore);
    }

    // Execute all the operations in the batch
    await batch.commit();
  }

  // Fetch all EForms
  static Future<List<Map<String, dynamic>>> fetchEForms() async {
    final db = await DatabaseHelper().database;
    return await db.query(tableName);
  }

  // Fetch EForm by ID
  static Future<Map<String, dynamic>?> fetchEFormById(String id) async {
    final db = await DatabaseHelper().database;
    final result = await db.query(tableName, where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  // Fetch and deserialize EForm by ID
  static Future<EFormDataModel?> getEFormById(String id) async {
    try {
      final result = await fetchEFormById(id);
      if (result != null) {
        // Deserialize formFields from JSON string to Map<String, dynamic>
        final formFieldsJson = result['formFields'];
        final formFields =
            formFieldsJson != null ? json.decode(formFieldsJson) : {};

        return EFormDataModel(
          id: result['id'],
          oid: result['oid'],
          ftid: result['ftid'],
          frmKey: result['frmKey'],
          formFields: formFields, // Store as Map<String, dynamic>
          updatedTimestamp: result['updatedTimestamp'],
          updatedBy: result['updatedBy'],
        );
      }
    } catch (e) {
      print('Error while fetching EForm from the database: $e');
    }
    return null;
  }

  static Future<int> getEFormCountByTid(String tid) async {
    final db = await DatabaseHelper().database;
    final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM $tableName WHERE ftid = ?', [tid]);

    return Sqflite.firstIntValue(result) ?? 0;
  }
}
