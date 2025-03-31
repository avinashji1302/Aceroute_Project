import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


Future<Database> getBackgroundDatabase() async {
  return await openDatabase(
    join(await getDatabasesPath(), 'api_data.db'),
    version: 1,
  );
}