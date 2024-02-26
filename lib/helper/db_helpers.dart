import 'dart:convert';

import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'databasee.db'),
      onCreate: (db, version) async {
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
      },
      version: 4,
    );
  }

  static Future<int> insert(String table,
      Map<String, Object> data) async {
    final db = await DBHelper.database();
    return db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>>
  getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }

  static Future delete(
    String tableName,
    int where,
  ) async {
    final db = await DBHelper.database();
    await db.rawDelete(
      'DELETE FROM $tableName WHERE id = ?',
      [where],
    );
  }

  static Future<List<Map<String, dynamic>>> getDataWithQuery(
      String query) async {
    final db = await DBHelper.database();
    return await db.rawQuery(query);
  }
}
