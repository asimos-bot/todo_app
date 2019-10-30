import 'package:flutter/material.dart';
import 'Task.dart';
import 'Tag.dart';
import 'package:sqflite/sqflite.dart';

//manage database and list at the same time
class TaskList {

  List<Task> list = [];
  Database db;
  BuildContext context;

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

  void create(context, db, List<Map> queryResult){

    this.db = db;
    this.context = context;

    for(int i=0; i < queryResult.length; i++){

      Map taskMap = queryResult[i];
      Task task = Task(this);

      task.title = taskMap['title'];
      task.description = taskMap['description'];
      task.id = taskMap['id'];

      list.add(task);
    }
  }

  void add(Task task){

    list.add(task);

    db.insert('tasks', {'title': task.title, 'description': task.description});
  }

  Task get(int index){

    if( index >= list.length || index < 0 ) throw("Index out of bounds in TaskList");

    return list[index];
  }

  Task removeAt(int index) {

    Task tmp = this.get(index);

    list.removeAt(index);

    db.delete('tasks', where: 'id = ?', whereArgs: [tmp.id]);

    return tmp;
  }

  Task remove(Task task){

    if( list.remove(task) ){

      db.delete('tasks', where: 'id = ?', whereArgs: [task.id]);
    }

    return task;
  }

  void delete(Task task){

    Task tmp = remove(task);

    tmp.dispose();
  }

  void deleteAt(int index){

    Task tmp = removeAt(index);

    tmp.dispose();
  }

  //update database
  void updateAt(int index){

    if( index >= list.length || index < 0 ) throw("Index out of bounds in TaskList");

    db.update('tasks', {'title': list[index].title, 'description': list[index].description}, where: 'id = ?', whereArgs: [list[index].id]);
  }

  void update(Task task){

    updateAt( list.indexOf(task) );
  }
}