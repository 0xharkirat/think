

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseHelper {
  DatabaseHelper._(); // private constructor to prevent instantiation

  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'think.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // create selected_apps table
        await db.execute('''
          CREATE TABLE selected_apps (
            name TEXT, 
            package_name TEXT PRIMARY KEY,
            icon BLOB
          )
        ''');

      },
    );
  }


}



