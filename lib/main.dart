import 'package:flutter/material.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'Task.dart';
import 'Tag.dart';
import 'TaskBuilder.dart';

void main() => runApp(new TodoApp());

//Main widget
class TodoApp extends StatelessWidget {

  @override
  Widget build(BuildContext context){

    return new MaterialApp(
      title: 'Todo Yourself', //title which appear when we minimize the app
      home: new TodoList(), //actual app stuff
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

  //actual todoList entrys, made of ListEntry classes
  List<Task> todoItems = [];

  //list of categories
  List<Tag> tags = [];

  //task builder
  var taskBuilder;

  //will be called every time the button to add a list entry is pressed
  void _addTodoItem(){

    // Putting our code inside "setState" tells the app that our state has changed, and
    // it will automatically re-render the list
    setState((){

      taskBuilder.createTask();
    });
  }

  void _addTag(){

    setState((){

      tags.add(Tag(context, tags));
    });
  }

  //build whole list of todoitems
  Widget _buildTodoList() {

    return new DragAndDropList<Task>(
      todoItems,
      itemBuilder: (BuildContext context, item) => item.toWidget(),
      onDragFinish: (before, after) {
        todoItems.insert(after, todoItems.removeAt(before));
      },
      canBeDraggedTo: (one, two) => true,
      dragElevation: 8.0,
      tilt: 0.01
    );
  }

  Widget _buildDrawer() {
    return new Drawer(
      child: new Column(
        children: <Widget> [
          DrawerHeader(
            child: Text('Tag Menu')
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text("Add Tag"),
            onTap: () => _addTag(),
          ),
          Container(
            child: Expanded(
              child: DragAndDropList<Tag>(
                tags,
                itemBuilder: (BuildContext context, item) {

                  return item.toWidget();
                },
                onDragFinish: (before, after) {

                  tags.insert(after, tags.removeAt(before));
                },
                canBeDraggedTo: (one, two) => true,
                dragElevation: 8.0,
                tilt: 0.01
              )
            )
          )
        ]
      )
    );
  }

  //create database
  Future<void> _createDatabase(Database db, int version) async {

    await db.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, description TEXT)');
    await db.execute('CREATE TABLE tags (id INTEGER PRIMARY KEY, title TEXT, description TEXT)');
  }

  //populate _todoItems with database
  Future<void> _dbGetTodoItems() async {

    var db = await openDatabase('database.db',
      //in case the database was nonexistent, create it right now
      version: 1,
      onCreate: (Database db, version) => _createDatabase(db, version),
      onOpen: (Database db) async {

        List<Map> rawTasks = await db.rawQuery('SELECT * FROM tasks');
        print(rawTasks);
      });

    await db.close();
  }

  @override
  @mustCallSuper
  void initState(){

    taskBuilder = new TaskBuilder(context, todoItems);

    _dbGetTodoItems();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      //slide bar
      drawer: _buildDrawer(),
      //top bar
      appBar: new AppBar(
          title: new Text('Todo List')
      ),
      //content in the middle of the screen
      body: _buildTodoList(),
      //bottom bar
      bottomNavigationBar: new BottomAppBar(
        //background color
        color: Colors.blue,
        shape: CircularNotchedRectangle(),
        //here we say we want a row to be inside the bottom bar (because the icons are in a row, just think about it)
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: IconButton(icon: Icon(Icons.add), onPressed: _addTodoItem)
            )
          ]
        )
      ),
    );
  }
}