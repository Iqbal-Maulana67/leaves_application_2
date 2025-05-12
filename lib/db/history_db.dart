import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class HistoryDatabase {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'history.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  static Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        leaf_name TEXT,
        location_name TEXT,
        timestamp TEXT
      )
    ''');
  }

  static Future<void> _upgradeDB(
      Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE history ADD COLUMN accuracy TEXT');
    }
  }

  static Future<void> insertHistory(
      String leaf_name, String location, String accuracy) async {
    final db = await database;
    await db.insert('history', {
      'leaf_name': leaf_name,
      'location_name': location,
      'accuracy': accuracy,
      'timestamp': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    });
  }

  static Future<List<Map<String, dynamic>>> getHistory() async {
    final db = await database;
    return await db.query('history', orderBy: 'timestamp DESC');
  }

  static Future<List<Map<String, dynamic>>> getDetailHistory(int id) async {
    final db = await database;
    return await db.query('history',
        orderBy: 'timestamp DESC', where: 'id = ${id}');
  }

  static Future<void> deleteAllHistory() async {
    final db = await database;
    await db.delete('history');
  }
}
