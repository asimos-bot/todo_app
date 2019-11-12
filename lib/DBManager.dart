import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'Task/TaskManager.dart';
import 'Tag/TagManager.dart';

class DBManager {

  Future<Database> db;

  DBManager (){

    db = initializeDatabase();
  }

  Future<void> createTables(Database db, int version) async {

    await db.execute(
        'CREATE TABLE tags ('
            'id INTEGER PRIMARY KEY AUTOINCREMENT,'
            'title TEXT NOT NULL,'
            'description TEXT NOT NULL,'
            'color INT NOT NULL,'
            'weight INT NOT NULL,'
            'created_at TEXT NOT NULL,'
            'priority INT,'
            'total_points INT NOT NULL'
        ')'
    );

    await db.execute(
        'CREATE TABLE tasks ('
            'id INTEGER PRIMARY KEY AUTOINCREMENT,'
            'title TEXT NOT NULL,'
            'description TEXT NOT NULL,'
            'weight INT NOT NULL,'
            'tag INT,'
            'created_at TEXT NOT NULL,'
            'checked INT NOT NULL,'
            'mode INT NOT NULL,'
            'priority INT,'
            'FOREIGN KEY (tag) REFERENCES tags(id)'
        ')'
    );

    await db.execute(
        'CREATE TABLE points ('
            'tag INT NOT NULL,'
            'created_at TEXT NOT NULL,'
            'points INT NOT NULL,'
            'FOREIGN KEY (tag) REFERENCES tags(id)'
        ')'
    );
  }

  Future<Database> initializeDatabase() {

    return openDatabase('database.db',
      //in case the database was nonexistent, create it right now
      version: 1,
      onCreate: (Database database, version) => createTables(database, version),
    );
  }

  Future<void> dispose() async {

    await (await db).close();
  }
}