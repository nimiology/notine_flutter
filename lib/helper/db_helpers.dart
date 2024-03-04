import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await getDatabasesPath();
    if (Platform.isWindows) {
      return databaseFactory.openDatabase(
        path.join(dbPath, 'database.db'),
        options: OpenDatabaseOptions(
          onCreate: _onCreate,
          version: 1,
        ),
      );
    }
    return await openDatabase(
        path.join(dbPath, 'database.db'),
        onCreate: _onCreate,
        version: 1);
  }

  static _onCreate(db, version) async {
    await db.execute('''
          CREATE TABLE note(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            server_id INTEGER,
            title TEXT NOT NULL,
            content TEXT,
            created DATETIME NOT NULL,
            updated DATETIME NOT NULL,
            color TEXT,
            category_title TEXT NOT NULL,
            FOREIGN KEY (category_title) REFERENCES category(title)
          )
        ''');

    await db.execute('''
          CREATE TABLE category(
            title TEXT PRIMARY KEY
          )
        ''');

    await db.execute('''
          CREATE TABLE sync_queue(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            action TEXT NOT NULL,
            table_name TEXT NOT NULL,
            data TEXT,
            synced INTEGER NOT NULL DEFAULT 0
          )
        ''');
  }

  static Future<int> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    return db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }

  static Future deleteWithID(
    String tableName,
    int where,
  ) async {
    final db = await DBHelper.database();
    await db.rawDelete(
      'DELETE FROM $tableName WHERE id = ?',
      [where],
    );
  }

  static Future deleteWithTitle(
    String tableName,
    String where,
  ) async {
    final db = await DBHelper.database();
    await db.rawDelete(
      'DELETE FROM $tableName WHERE title = ?',
      [where],
    );
  }

  static Future<List<Map<String, dynamic>>> getDataWithQuery(
      String query) async {
    final db = await DBHelper.database();
    return await db.rawQuery(query);
  }
}
