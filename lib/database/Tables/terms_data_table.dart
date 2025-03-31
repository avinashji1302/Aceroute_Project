import 'package:ace_routes/database/databse_helper.dart';
import 'package:ace_routes/model/terms_model.dart';
// Adjust the import path as needed
import 'package:sqflite/sqflite.dart';
// Adjust the import path as needed

class TermsDataTable {
  static const String tableName = 'get_terms';

  // Create the table
  static Future<void> onCreate(Database db) async {

    await db.execute('''
      CREATE TABLE $tableName (
        namespace TEXT,
        locationCode TEXT,
        formName TEXT,
        partName TEXT,
        assetName TEXT,
        pictureLabel TEXT,
        audioLabel TEXT,
        signatureLabel TEXT,
        fileLabel TEXT,
        workLabel TEXT,
        customerLabel TEXT,
        orderLabel TEXT,
        customerReferenceLabel TEXT,
        registrationLabel TEXT,
        odometerLabel TEXT,
        detailsLabel TEXT,
        faultDescriptionLabel TEXT,
        notesLabel TEXT,
        summaryLabel TEXT,
        orderGroupLabel TEXT,
        fieldOrderRules TEXT,
        invoiceEmailLabel TEXT
      )
    ''');
  }

  // Upgrade table logic (if needed)
  static Future<void> onUpgrade(Database db) async {
    await onCreate(db); // In this case, simply calling the create function
  }

  // Insert terms data into get_terms table
  static Future<void> insertTermsData(TermsDataModel termsData) async {
    final db = await DatabaseHelper().database;
    await clearTermsData(); // Clear the existing data before inserting new one
    await db.insert(
      tableName,
      termsData.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fetch all terms data
  static Future<List<TermsDataModel>> fetchTermsData() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) => TermsDataModel.fromJson(maps[i]));
  }

  // Clear all terms data from the get_terms table
  static Future<void> clearTermsData() async {
    final db = await DatabaseHelper().database;
    await db.delete(tableName);
  }
}
