import 'package:flutter/material.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:todo_yourself/Task/Task.dart';
import 'package:todo_yourself/Tag/Tag.dart';
import 'package:todo_yourself/Task/TaskBuilder.dart';
import 'package:todo_yourself/Tag/TagBuilder.dart';
import 'package:todo_yourself/Task/TaskList.dart';
import 'package:todo_yourself/Tag/TagList.dart';
import 'globals.dart' as globals;

TaskList tasks;
TagList tags;

//builders
var taskBuilder;
var tagBuilder;

//database
Future<Database> db;

void main() => runApp(new TodoApp());

//Main widget
class TodoApp extends StatelessWidget {

  @override
  Widget build(BuildContext context){

    return new MaterialApp(
      title: 'ToDo Yourself', //title which appear when we minimize the app
      home: new TodoList(), //actual app stuff
      theme: ThemeData(primaryColor: globals.foregroundColor, scaffoldBackgroundColor: globals.backgroundColor)
    );
  }
}

//the content of the main widget
class TodoList extends StatefulWidget {

  @override
  createState() => new TodoListState();
}

//describe states of todoList
class TodoListState extends State<TodoList> {

  void _addTask(){

    tasks.clearTextControllers();

    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => TaskBuilder(tasks)
        )
    );
  }

  void _addTag(){

    tags.clearTextControllers();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TagBuilder(tags)
      )
    );
  }

  //build whole list of tasks
  Future<Widget> _buildTaskList() async {

    List<Task> list = await tasks.list();

    return list.length > 1 ? DragAndDropList<Task>(
      list,
      itemBuilder: (BuildContext context, item) => item.toWidget(),
      onDragFinish: (before, after) {
        list.insert(after, list.removeAt(before));
      },
      canBeDraggedTo: (one, two) => true,
      dragElevation: 8.0,
      tilt: 0.01,
    ) : ListView.builder(itemCount: list.length, itemBuilder: (context, index) => list[index].toWidget());
  }

  Future<Widget> _buildTagList() async {

    List<Tag> list = await tags.list();

    return list.length > 1 ? DragAndDropList<Tag>(
        list,
        itemBuilder: (BuildContext context, item) {

          return item.toWidget(context);
        },
        onDragFinish: (before, after) {

          list.insert(after, list.removeAt(before));
        },
        canBeDraggedTo: (one, two) => true,
        dragElevation: 8.0,
        tilt: 0.01
      //if one or none tag is present
    ) : ListView.builder(itemCount: list.length, itemBuilder: (context, index) => list[index].toWidget(context) );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(color: globals.foregroundColor),
        child: Column(  //Column
        //padding: EdgeInsets.zero,
          children: <Widget> [
            DrawerHeader(
              decoration: BoxDecoration(color: globals.foregroundColor),
              child: Center(
                child: Text('Tags Menu',style: TextStyle(color: Colors.white, fontSize: 20, fontStyle: FontStyle.italic))
              )
            ),
            ListTile(
              leading: Icon(Icons.add,color: Colors.white),
              title: Text("Add Tag",style: TextStyle(color: Colors.white)),
              onTap: () => _addTag(),
            ),
            Container(
              child: Expanded(
                child: FutureBuilder(
                  future: _buildTagList(),
                  builder: (context, snapshot) {

                    if( snapshot.connectionState == ConnectionState.done ){

                      return snapshot.data;
                    }else{
                      return Center(
                        child: CircularProgressIndicator()
                      );
                    }
                  }
                )
              )
            )
          ]
        )
      )
    );
  }

  //create database
  Future<void> _createDatabase(Database db, int version) async {

    await db.execute(
        'CREATE TABLE tags ('
        'id INTEGER PRIMARY KEY AUTOINCREMENT,'
        'title TEXT NOT NULL,'
        'description TEXT NOT NULL,'
        'color INT NOT NULL,'
        'weight INT NOT NULL,'
        'created_at TEXT NOT NULL'
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
        'FOREIGN KEY (tag) REFERENCES tags(id)'
        ')'
    );

    await db.execute(
      'CREATE TABLE points ('
      'tag INT NOT NULL,'
      'datetime TEXT NOT NULL,'
      'points INT NOT NULL,'
      'FOREIGN KEY (tag) REFERENCES tags(id)'
      ')'
    );
  }

  @override
  @mustCallSuper
  void initState() {

    //TODO: for debugging only, comment it later
    Sqflite.devSetDebugModeOn(true);

    db = openDatabase('database.db',
          //in case the database was nonexistent, create it right now
          version: 1,
          onCreate: (Database db, version) => _createDatabase(db, version),
        );

    taskBuilder = new TaskBuilder(tasks);
    tagBuilder = new TagBuilder(tags);

    tags = TagList(db);
    tasks = TaskList(db, tags);

    super.initState();
  }

  @override
  @mustCallSuper
  void dispose() async {

    await (await db).close();

    tags.dispose();
    tasks.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      //slide bar
      drawer: _buildDrawer(),
      //top bar
      appBar: AppBar(
          title: Text('Your tasks')
      ),
      //content in the middle of the screen
      body: FutureBuilder(
        future: _buildTaskList(),
        builder: (context, snapshot) {
          if( snapshot.connectionState == ConnectionState.done ){

              return snapshot.data;

          } else {
            return
                Center(
                  child: CircularProgressIndicator()
                );
          }
        }
      ),
      //bottom bar
      bottomNavigationBar: new BottomAppBar(
        //background color
        color: globals.foregroundColor,
        shape: CircularNotchedRectangle(),
        //here we say we want a row to be inside the bottom bar (because the icons are in a row, just think about it)
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: IconButton(icon: Icon(Icons.add),
                  onPressed: _addTask,
                  color: Colors.white
              )
            )
          ]
        )
      ),
    );
  }
}