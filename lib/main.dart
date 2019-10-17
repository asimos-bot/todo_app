import 'package:flutter/material.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'Task.dart';
import 'Tag.dart';
import 'TaskBuilder.dart';
import 'TagBuilder.dart';
import 'TaskList.dart';

void main() => runApp(new TodoApp());

//Main widget
class TodoApp extends StatelessWidget {
  var Purple = const Color(0xFF6A1B9A);
  var Black = const Color(0xDD000000);

  @override
  Widget build(BuildContext context){

    return new MaterialApp(
      title: 'ToDo Yourself', //title which appear when we minimize the app
      home: new TodoList(), //actual app stuff
      theme: ThemeData(primaryColor: Purple, scaffoldBackgroundColor: Black),
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

  TaskList todoItems = TaskList();

  //list of categories
  List<Tag> tags = [];

  //builders
  var taskBuilder;
  var tagBuilder;

  //database
  Database db;

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

      tagBuilder.createTag();
    });
  }

  //build whole list of todoitems
  Widget _buildTodoList() {

    return new DragAndDropList<Task>(
      todoItems.list,
      itemBuilder: (BuildContext context, item) => item.toWidget(),
      onDragFinish: (before, after) {
        todoItems.list.insert(after, todoItems.list.removeAt(before));
      },
      canBeDraggedTo: (one, two) => true,
      dragElevation: 8.0,
      tilt: 0.01
    );
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
            leading: Icon(Icons.add,color: Colors.white,),
            title: Text("Add category",style: TextStyle(color: Colors.white),),
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
    ));
  }

  //create database
  Future<void> _createDatabase(Database db, int version) async {

    await db.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, description TEXT)');
    await db.execute('CREATE TABLE tags (id INTEGER PRIMARY KEY, title TEXT, description TEXT)');
  }

  //populate _todoItems with database
  Future<void> _dbGetTodoItems() async {

    db = await openDatabase('database.db',
      //in case the database was nonexistent, create it right now
      version: 1,
      onCreate: (Database db, version) => _createDatabase(db, version),
      onOpen: (Database db) async {

        List<Map> rawTasks = await db.rawQuery('SELECT * FROM tasks');
        print(rawTasks);
        setState(() => todoItems.create(context, db, rawTasks));
      });
  }

  @override
  @mustCallSuper
  void initState(){

    taskBuilder = new TaskBuilder(context, todoItems);
    tagBuilder = new TagBuilder(context, tags);

    _dbGetTodoItems();

    super.initState();
  }

  @override
  @mustCallSuper
  void dispose(){

    () async => await db.close();

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
              child: IconButton(icon: Icon(Icons.add), onPressed: _addTodoItem, color: Colors.white)
            )
          ]
        )
      ),
    );
  }
}