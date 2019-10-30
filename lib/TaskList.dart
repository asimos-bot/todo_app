import 'package:flutter/material.dart';
import 'Task.dart';
import 'package:sqflite/sqflite.dart';

//manage database and list at the same time
class TaskList {

  Future<Database> db;

  final titleController = TextEditingController(text: "");
  final descriptionController = TextEditingController(text: "");

  void updateTextControllers(){
    titleController.value = new TextEditingController.fromValue(new TextEditingValue(text: "")).value;
    descriptionController.value = new TextEditingController.fromValue(new TextEditingValue(text: "")).value;
  }

  void dispose(){
    titleController.dispose();
    descriptionController.dispose();
  }

  TaskList(this.db);

  Future<List<Task>> list() async {

    List<Task> list = [];

    List<Map> queryResult = await (await db).rawQuery('SELECT * FROM tasks');

    for(int i=0; i < queryResult.length; i++){

      Map taskMap = queryResult[i];
      Task task = Task(this);

      task.title = taskMap['title'];
      task.description = taskMap['description'];
      task.id = taskMap['id'];

      list.add(task);
    }

    return list;
  }

  Future<Task> get(int id) async {

    List<Map> query = await (await db).query('tasks', columns: ['id', 'title', 'description'], where: 'id = ?', whereArgs: [id]);

    Map result = query[0];

    Task task = Task(this);

    task.id = result['id'];
    task.title = result['title'];
    task.description = result['description'];

    return task;
  }

  Future<void> add(Task task) async {

    await (await db).insert('tasks', {
      'title': task.title,
      'description': task.description
    });
  }

  Future<Task> removeAt(int index, List<Task> list) async {

    await (await db).delete('tasks', where: 'id = ?', whereArgs: [list[index].id]);

    return list.removeAt(index);
  }

  Future<void> delete(Task task) async {

      await (await db).delete('tasks', where: 'id = ?', whereArgs: [task.id]);
  }

  //update database
  Future<void> updateAt(int index, List<Task> list) async{

    await (await db).update('tasks', {
      'title': list[index].title,
      'description': list[index].description
    }, where: 'id = ?', whereArgs: [list[index].id]);
  }

  Future<void> update(Task task) async {

    await (await db).update('tasks', {
      'title': task.title,
      'description': task.description
    }, where: 'id = ?', whereArgs: [task.id]);
  }
}