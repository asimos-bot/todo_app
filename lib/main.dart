import 'package:flutter/material.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'Task.dart';
import 'Tag.dart';
import 'TaskBuilder.dart';
import 'TagBuilder.dart';
import 'TaskList.dart';
import 'TagList.dart';

TaskList tasks = TaskList();

//list of categories
TagList tags = TagList();

//builders
var taskBuilder;
var tagBuilder;

//database
Database db;

void main() => runApp(new TodoApp());

//Main widget
class TodoApp extends StatelessWidget {
  final purple = const Color(0xFF6A1B9A);
  final black = const Color(0xDD000000);

  @override
  Widget build(BuildContext context){

    return new MaterialApp(
      title: 'ToDo Yourself', //title which appear when we minimize the app
      home: new TodoList(), //actual app stuff
      theme: ThemeData(primaryColor: purple, scaffoldBackgroundColor: black),
      routes: <String, WidgetBuilder> {

      }
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

    tasks.updateTextControllers();

    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => TaskBuilder(tasks)
        )
    );
  }

  void _addTag(){

    tags.updateTextControllers();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TagBuilder(tags)
      )
    );
  }

  //build whole list of todoitems
  Widget _buildTodoList() {

    return tasks.list.length > 1 ? DragAndDropList<Task>(
      tasks.list,
      itemBuilder: (BuildContext context, item) => item.toWidget(context),
      onDragFinish: (before, after) {
        tasks.list.insert(after, tasks.list.removeAt(before));
      },
      canBeDraggedTo: (one, two) => true,
      dragElevation: 8.0,
      tilt: 0.01,
    ) : ListView.builder(itemCount: tasks.list.length, itemBuilder: (context, index) => tasks.get(index).toWidget(context));
  }

  Widget _buildDrawer() {
    return new Drawer(
      child: Container(decoration: BoxDecoration(color: Color(0xFF6A1B9A)),child: new Column(  //Column
        //padding: EdgeInsets.zero,
        children: <Widget> [
          DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF6A1B9A)),
            child: Text('Categories Menu',style: TextStyle(color: Colors.white),)
          ),
          ListTile(
            leading: Icon(Icons.add,color: Colors.white),
            title: Text("Add category",style: TextStyle(color: Colors.white),),
            onTap: () => _addTag(),
          ),
          Container(
            child: Expanded(
              child: tags.list.length > 1 ? DragAndDropList<Tag>(
                tags.list,
                itemBuilder: (BuildContext context, item) {

                  return item.toWidget(context);
                },
                onDragFinish: (before, after) {

                  tags.list.insert(after, tags.list.removeAt(before));
                },
                canBeDraggedTo: (one, two) => true,
                dragElevation: 8.0,
                tilt: 0.01
                //if one or none tag is present
              ) : ListView.builder(itemCount: tags.list.length, itemBuilder: (context, index) => tags.get(index).toWidget(context) )
            )
          )
        ]
      )
    ));
  }

  //create database
  Future<void> _createDatabase(Database db, int version) async {

    await db.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, description TEXT)');
    await db.execute('CREATE TABLE tags (id INTEGER PRIMARY KEY, title TEXT, description TEXT, color INT)');
  }

  //populate _todoItems with database
  Future<void> _dbGetTodoItems() async {

    db = await openDatabase('database.db',
      //in case the database was nonexistent, create it right now
      version: 1,
      onCreate: (Database db, version) => _createDatabase(db, version),
      onOpen: (Database db) async {

        List<Map> rawTasks = await db.rawQuery('SELECT * FROM tasks');
        List<Map> rawTags = await db.rawQuery('SELECT * FROM tags');
        print(rawTasks);
        print(rawTags);
        setState(() {
          tasks.create(context, db, rawTasks);
          tags.create(context, db, rawTags);
        });
      });
  }

  @override
  @mustCallSuper
  void initState(){

    taskBuilder = new TaskBuilder(tasks);
    tagBuilder = new TagBuilder(tags);

    _dbGetTodoItems();

    super.initState();
  }

  @override
  @mustCallSuper
  void dispose(){

    () async => await db.close();

    tags.dispose();
    tasks.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      //slide bar
      drawer: _buildDrawer(),
      //top bar
      appBar: new AppBar(
          title: new Text('Your tasks')
      ),
      //content in the middle of the screen
      body: _buildTodoList(),
      //bottom bar
      bottomNavigationBar: new BottomAppBar(
        //background color
        color: Color(0xFF6A1B9A),
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