import 'package:flutter/material.dart';
import 'package:todo_yourself/Task/Task.dart';
import 'package:sqflite/sqflite.dart';
import '../Tag/TagList.dart';

//manage database and list at the same time
class TaskList {

  TagList tagList;
  int length=-1;

  Future<Database> db;

  final titleController = TextEditingController(text: "");
  final descriptionController = TextEditingController(text: "");
  final weightController = TextEditingController(text: "");

  void updateTextControllers(){
    titleController.value = new TextEditingController.fromValue(new TextEditingValue(text: "")).value;
    descriptionController.value = new TextEditingController.fromValue(new TextEditingValue(text: "")).value;
    weightController.value = new TextEditingController.fromValue(new TextEditingValue(text: "1")).value;
  }

  void dispose(){
    titleController.dispose();
    descriptionController.dispose();
    weightController.dispose();
  }

  TaskList(this.db, this.tagList);

  Future<List<Task>> list() async {

    List<Task> list = [];

    List<Map> queryResult = await (await db).rawQuery('SELECT * FROM tasks');

    for(int i=0; i < queryResult.length; i++){

      Map taskMap = queryResult[i];
      Task task = Task(this);

      task.title = taskMap['title'];
      task.description = taskMap['description'];
      task.id = taskMap['id'];
      task.tag = taskMap['tag'] != null ? await tagList.get(taskMap['tag']) : null;
      task.weight = taskMap['weight'];

      list.add(task);
    }

    length = list.length;

    return list;
  }

  Future<Task> get(int id) async {

    List<Map> query = await (await db).query('tasks', columns: ['id', 'title', 'description', 'tag', 'weight'], where: 'id = ?', whereArgs: [id]);

    if(query.length == 0) return null;

    Map result = query[0];

    Task task = Task(this);

    task.id = result['id'];
    task.title = result['title'];
    task.description = result['description'];
    task.tag = result['tag'] != null ? await tagList.get(result['tag']) : null;
    task.weight = result['weight'];

    return task;
  }

  Future<void> add(Task task) async {

    await (await db).insert('tasks', {
      'title': task.title,
      'description': task.description,
      'tag': task.tag!=null ? task.tag.id : null,
      'weight': task.weight
    });
  }

  Future<void> delete(Task task) async {

      await (await db).delete('tasks', where: 'id = ?', whereArgs: [task.id]);
  }

  //update database
  Future<void> updateAt(int index, List<Task> list) async{

    await (await db).update('tasks', {
      'title': list[index].title,
      'description': list[index].description,
      'tag': list[index].tag != null ? list[index].tag.id : null,
      'weight': list[index].weight,
    }, where: 'id = ?', whereArgs: [list[index].id]);
  }

  Future<void> update(Task task) async {

    await (await db).update('tasks', {
      'title': task.title,
      'description': task.description,
      'tag': task.tag != null ? task.tag.id : null,
      'weight': task.weight
    }, where: 'id = ?', whereArgs: [task.id]);
  }
}