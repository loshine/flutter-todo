import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const tableTask = "task";
const columnId = "_id";
const columnTitle = "title";
const columnDescription = "description";
const columnCompleted = "completed";

const dbName = "tasks.db";

const String createDB = '''
create table $tableTask ( 
  $columnId integer primary key autoincrement, 
  $columnTitle text not null,
  $columnDescription text,
  $columnCompleted integer not null)
''';

class Task {
  Task();

  int id;
  String title;
  String description;
  bool completed;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnTitle: title,
      columnDescription: description,
      columnCompleted: completed == true ? 1 : 0,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Task.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    title = map[columnTitle];
    description = map[columnDescription];
    completed = map[columnCompleted] == 1;
  }
}

class TaskProvider {
  static Database _db;

  Future<Database> get db async {
    if (_db == null) {
      var databasePath = await getDatabasesPath();
      String path = join(databasePath, dbName);
      _db = await open(path);
    }
    return _db;
  }

  Future<Database> open(String path) async {
    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(createDB);
    });
  }

  Future<Task> insert(Task task) async {
    var d = await db;
    task.id = await d.insert(tableTask, task.toMap());
    return task;
  }

  Future<Task> get(int id) async {
    var d = await db;
    List<Map> maps = await d.query(tableTask,
        columns: [columnId, columnTitle, columnDescription, columnCompleted],
        where: "$columnId = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return new Task.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Task>> getAll() async {
    var d = await db;
    List<Map<String, dynamic>> maps = await d.query(tableTask,
        columns: [columnId, columnTitle, columnDescription, columnCompleted]);
    return maps.map((it) => Task.fromMap(it)).toList();
  }

  Future<int> delete(int id) async {
    var d = await db;
    return await d.delete(tableTask, where: "$columnId = ?", whereArgs: [id]);
  }

  Future<int> clearCompleted() async {
    var d = await db;
    return d.delete(tableTask, where: "$columnCompleted = 1");
  }

  Future<int> update(Task task) async {
    var d = await db;
    return await d.update(tableTask, task.toMap(),
        where: "$columnId = ?", whereArgs: [task.id]);
  }

  Future close() async {
    await _db?.close();
  }
}
