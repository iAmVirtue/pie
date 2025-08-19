import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/habit_event.dart';

class DBHelper {
  static Future<Database> _open() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'ai_companion.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE events (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            timestamp TEXT,
            lat REAL,
            lng REAL
          )
        ''');
      },
    );
  }

  static Future<int> insertEvent(HabitEvent event) async {
    final db = await _open();
    return db.insert('events', event.toMap());
  }

  static Future<List<HabitEvent>> getEvents() async {
    final db = await _open();
    final rows = await db.query('events', orderBy: 'timestamp DESC');
    return rows.map((r) => HabitEvent.fromMap(r)).toList();
  }
}
