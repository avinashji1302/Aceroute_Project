import 'package:sqflite/sqflite.dart';
import '../../model/Status_model_database.dart';
import '../databse_helper.dart';

class StatusTable {
  static const String tableName = 'statuses';

  // Create the statuses table
  static Future<void> onCreate(Database db) async {
    print("Creating statuses table...");
    await db.execute('''
      CREATE TABLE $tableName (
        id TEXT PRIMARY KEY,
        isGroup TEXT,
        groupSequence TEXT,
        groupId TEXT,
        sequence TEXT,
        name TEXT,
        abbreviation TEXT,
        isVisible TEXT
      )
    ''');
    print("Statuses table created successfully.");
  }

  // Upgrade the statuses table when schema changes
  static Future<void> onUpgrade(
      Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      await db.execute('DROP TABLE IF EXISTS $tableName');
      await onCreate(db);
    }
  }

  // Insert JSON data into the statuses table
  static Future<void> insertStatusList(
      List<Map<String, dynamic>> statusList) async {
    final db = await DatabaseHelper().database;
    Batch batch = db.batch();
    for (var status in statusList) {
      batch.insert(
        tableName,
        status,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
    // print("Data saved successfully in statuses table.");
  }

  // Fetch all statuses data
  static Future<List<Status>> fetchStatusData() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    print("Database query result: $maps");

    return List.generate(maps.length, (i) => Status.fromJson(maps[i]));
  }

  // Fetch a single name status by ID
  static Future<Map<String, String?>> fetchNamesByIds(List<String> wkfIds) async {
    Map<String, String?> resultMap = {};
    try {
      Database db = await DatabaseHelper().database;
      for (String id in wkfIds) {
        print("id $id wkf");
        List<Map<String, dynamic>> results = await db.query(
          tableName,
          where: 'id = ?',
          whereArgs: [id],
        );
        resultMap[id] = results.isNotEmpty ? results.first['name'] as String : null;
      }
    } catch (e) {
      print("Error fetching names: $e");
    }
    return resultMap;
  }




  // Fetch the name by id (After choosing any specific status the status

// Fetch a single name by ID
  static Future<String?> fetchNameById(String id) async {
    String? name;
    try {
      // Access the database instance
      Database db = await DatabaseHelper().database;

      // Query the database for the specific ID
      List<Map<String, dynamic>> results = await db.query(
        tableName,
        where: 'id = ?',
        whereArgs: [id],
      );

      // Extract the name if the result is not empty
      if (results.isNotEmpty) {
        name = results.first['name'] as String?;

        print("name is $name");
      }
    } catch (e) {
      print("Error fetching name by ID: $e");
    }
    return name;
  }


}
