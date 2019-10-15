import 'package:flutter/material.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'ListEntry.dart';

void main() => runApp(new TodoApp());

//Main widget
class TodoApp extends StatelessWidget {

  @override
  Widget build(BuildContext context){

    return new MaterialApp(
      title: 'Todo Yourself', //title which appear when we minimize the app
      home: new TodoList() //actual app stuff
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
  List<ListEntry> _todoItems = [];

  //will be called every time the button to add a list entry is pressed
  void _addTodoItem(){

    // Putting our code inside "setState" tells the app that our state has changed, and
    // it will automatically re-render the list
    setState((){

      int index = _todoItems.length;
      _todoItems.add(new ListEntry(context, _todoItems));
    });
  }

  //build whole list of todoitems
  Widget _buildTodoList() {
    return new DragAndDropList<ListEntry>(
      _todoItems,
      itemBuilder: (BuildContext context, item) {
        // itemBuilder will be automatically be called as many times as it takes for the
        // list to fill up its available space, which is most likely more than the
        // number of todoitems we have. So, we need to check the index is OK.
        return item.toWidget();
      },
      onDragFinish: (before, after) {

        _todoItems.insert(after, _todoItems.removeAt(before));
      },
      canBeDraggedTo: (one, two) => true,
      dragElevation: 8.0,
      tilt: 0.01
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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