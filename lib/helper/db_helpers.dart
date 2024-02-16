import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'database.db'),
        onCreate: (db, version) {
      db.execute(
          "CREATE TABLE note (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL,"
              " content TEXT, created DATETIME NOT NULL, color TEXT");
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
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
