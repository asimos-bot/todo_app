import 'package:flutter/material.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:todo_yourself/Task/Task.dart';
import 'package:todo_yourself/Tag/Tag.dart';
import 'package:todo_yourself/Task/TaskBuilder.dart';
import 'package:todo_yourself/Tag/TagBuilder.dart';
import 'package:todo_yourself/Task/TaskManager.dart';
import 'package:todo_yourself/Tag/TagManager.dart';
import 'DBManager.dart';
import 'globals.dart' as globals;

DBManager db;

TaskManager tasks;
TagManager tags;

//builders
var taskBuilder;
var tagBuilder;

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

  //build whole list of tasks
  Future<Widget> _buildTaskList() async {

    List<Task> list = await tasks.list();

    return list.length > 1 ? DragAndDropList<Task>(
      list,
      itemBuilder: (BuildContext context, item) => item.toWidget(null),
      onDragFinish: (before, after) {
        list.insert(after, list.removeAt(before));
      },
      canBeDraggedTo: (one, two) => true,
      dragElevation: 8.0,
      tilt: 0.01,
    ) : ListView.builder(itemCount: list.length, itemBuilder: (context, index) => list[index].toWidget(null));
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
                child: Text('Tags Menu',style: TextStyle(color: globals.secondaryForegroundColor, fontSize: 20, fontStyle: FontStyle.italic))
              )
            ),
            ListTile(
              leading: Icon(Icons.add,color: globals.secondaryForegroundColor),
              title: Text("Add Tag",style: TextStyle(color: globals.secondaryForegroundColor)),
              onTap: () {
                tags.clearTextControllers();

                Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => TagBuilder(tags)
                    )
                );
              },
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

  @override
  @mustCallSuper
  void initState() {

    super.initState();

    //TODO: for debugging only, comment it later
    Sqflite.devSetDebugModeOn(true);

    taskBuilder = new TaskBuilder(tasks);
    tagBuilder = new TagBuilder(tags);

    db = DBManager();

    tags = TagManager(db.db);
    tasks = TaskManager(db.db);

    tags.taskManager = tasks;
    tasks.tagManager = tags;
  }

  @override
  @mustCallSuper
  void dispose() async {

    await db.dispose();

    tags.dispose();
    tasks.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    //disable screen rotation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);

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

              if( snapshot.hasError ) {
                print(snapshot.error);
                return Text("Error: check debug output");
              }

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
      bottomNavigationBar: BottomAppBar(
        //background color
        color: globals.foregroundColor,
        shape: CircularNotchedRectangle(),
        //here we say we want a row to be inside the bottom bar (because the icons are in a row, just think about it)
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: IconButton(icon: Icon(Icons.add),
                  onPressed: () {
                    tasks.clearTextControllers();

                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => TaskBuilder(tasks)
                        )
                    );
                  },
                  color: globals.secondaryForegroundColor
              )
            )
          ]
        )
      ),
    );
  }
}