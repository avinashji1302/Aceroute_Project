import 'dart:async';
import 'package:ace_routes/database/Tables/eform_data_table.dart';
import 'package:ace_routes/database/Tables/file_meta_table.dart';
import 'package:ace_routes/database/Tables/prority_table.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Import all required tables
import 'Tables/genTypeTable.dart';
import 'Tables/OrderTypeDataTable.dart';
import 'Tables/PartTypeDataTable.dart';
import 'Tables/api_data_table.dart';
import 'Tables/login_response_table.dart';
import 'Tables/getOrderPartTable.dart';
import 'Tables/order_note_table.dart';
import 'Tables/terms_data_table.dart';
import 'Tables/version_api_table.dart';
import 'Tables/event_table.dart';
import 'Tables/status_table.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'api_data.db');

    // Optionally delete the existing database for a fresh start
    await deleteDatabase(path);

    return await openDatabase(
      path,
      version: 8, // Increment version to ensure `statuses` table is created
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await Future.wait([
      ApiDataTable.onCreate(db),
      VersionApiTable.onCreate(db),
      LoginResponseTable.onCreate(db),
      TermsDataTable.onCreate(db),
      EventTable.onCreate(db),
      PartTypeDataTable.onCreate(db),
      OrderTypeDataTable.onCreate(db),
      GTypeTable.onCreate(db),
      StatusTable.onCreate(db), // Create statuses table
      OrderNoteTable.onCreate(db),
      GetOrderPartTable.onCreate(db),
      EFormDataTable.onCreate(db),
      FileMetaTable.onCreate(db),
      PriorityTable.onCreate(db)
    ]);
    print("All tables created successfully.");
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // print("Upgrading database...");

    if (oldVersion < 12) {
      await PriorityTable.onCreate(db);
    }
    if (oldVersion < 11) {
      await FileMetaTable.onCreate(db);
    }
    if (oldVersion < 10) {
      await EFormDataTable.onCreate(db); // Add OrderDataTable if upgrading
    }

    if (oldVersion < 9) {
      await GetOrderPartTable.onCreate(db); // Add OrderDataTable if upgrading
    }

    if (oldVersion < 8) {
      await StatusTable.onCreate(
          db); // Create statuses table if upgrading from older version
    }
    if (oldVersion < 7) {
      await OrderTypeDataTable.onCreate(db);
    }
    if (oldVersion < 6) {
      await PartTypeDataTable.onCreate(db);
    }
    if (oldVersion < 5) {
      await EventTable.onUpgrade(db);
    }
    print("Database upgrade complete.");
  }
}
