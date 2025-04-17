import 'package:ace_routes/controller/event_controller.dart';
import 'package:ace_routes/database/databse_helper.dart';
import 'package:ace_routes/model/event_model.dart';
import 'package:sqflite/sqflite.dart';

class EventTable {
  static const String tableName = 'events';

  // Create the events table
  static Future<void> onCreate(Database db) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id TEXT PRIMARY KEY,
        cid TEXT,
        start_date TEXT,
        etm TEXT,
        end_date TEXT,
        nm TEXT,
        wkf TEXT,
        alt TEXT,
        po TEXT,
        inv TEXT,
        tid TEXT,
        pid TEXT,
        rid TEXT,
        ridcmt TEXT,
        dtl TEXT,
        lid TEXT,
        cntid TEXT,
        flg TEXT,
        est TEXT,
        lst TEXT,
        ctid TEXT,
        ctpnm TEXT,
        ltpnm TEXT,
        cnm TEXT,
        address TEXT,
        geo TEXT,
        cntnm TEXT,
        tel TEXT,
        ordfld1 TEXT,
        ttid TEXT,
        cfrm TEXT,
        cprt TEXT,
        xid TEXT,
        cxid TEXT,
        tz TEXT,
        zip TEXT,
        fmeta TEXT,
        cimg TEXT,
        caud TEXT,
        csig TEXT,
        cdoc TEXT,
        cnot TEXT,
        dur TEXT,
        val TEXT,
        rgn TEXT,
        upd TEXT,
        "by" TEXT,
        znid TEXT
      )
    ''');
  }

  // Upgrade logic for the events table
  static Future<void> onUpgrade(Database db) async {
    await onCreate(db); // Re-create the table if upgrading
  }

  // Insert event into the events table
  static Future<void> insertEvent(Event event) async {
    final db = await DatabaseHelper().database;
    fetchEvents();
    await db.insert(
      tableName,
      event.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fetch all events
  static Future<List<Event>> fetchEvents() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) => Event.fromJson(maps[i]));
  }

  // Fetch event by ID
  static Future<Event?> fetchEventById(String id) async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?', // SQL WHERE clause
      whereArgs: [id], // Arguments for the WHERE clause
    );

    // If data exists, return the first record as an Event object
    if (maps.isNotEmpty) {
      return Event.fromJson(maps.first);
    }

    // If no data found, return null
    return null;
  }

  // Update order by ID
  static Future<int> updateOrder(String orderId, String newWkf) async {
    final db = await DatabaseHelper().database;

    // Define the SQL UPDATE statement
    int result = await db.update(
      'events', // Replace with your table name
      {
        'wkf': newWkf
      }, // Replace 'column_name' with the name of the column to update
      where: 'id = ?', // SQL WHERE clause to match the order ID
      whereArgs: [orderId], // Arguments for the WHERE clause
    );

    return result; // Returns the number of rows affected
  }

  //updating some data in event from vehicle details

// Update order by ID
  static Future<void> updateVehicle(
      String orderId, Map<String, String> updatedData) async {
    final db = await DatabaseHelper().database;

    // Define the SQL UPDATE statement
    int result = await db.update(
      'events', // Replace with your table name
      {
        'dtl': updatedData['details'], // Update the 'wkf' column
        'po': updatedData['registration'], // Update the 'status' column
        'inv': updatedData['odometer'],
        'alt': updatedData['faultDesc'], // Update the 'amount' column
      },
      where: 'id = ?', // SQL WHERE clause to match the order ID
      whereArgs: [orderId], // Arguments for the WHERE clause
    );

    print("succesfullt ${updatedData['notes']}");
  }

//update via pubnub
  static Future<void> patchEventFields(
      String eventId, Map<String, dynamic> updatedFields) async {
    final db = await DatabaseHelper().database;
    print(updatedFields);
    print(eventId);
    int result = await db.update(
      tableName,
      updatedFields,
      where: 'id = ?',
      whereArgs: [eventId],
    );

    if (result > 0) {
      print('✅ Event $eventId updated with: $updatedFields');
    } else {
      print('⚠️ Failed to update event $eventId. Maybe not found?');
    }
  }

  //DEleteing an event via pubnub

  Future<void> deleteEvent(String id) async {
    final db = await DatabaseHelper().database;

    final response =
        await db.delete(tableName, where: 'id = ?', whereArgs: [id]);

    print("$response successfully deleted");
  }

  // Clear all events
  static Future<void> clearEvents() async {
    final db = await DatabaseHelper().database;
    await db.delete(tableName);
  }
}
