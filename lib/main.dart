import 'package:flutter/material.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'Task.dart';
import 'Tag.dart';

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
  
  //actual todoList entrys, made of ListEntry classes
  List<Task> _todoItems = [];

  //list of categories
  List<Tag> _tags = [];

  //will be called every time the button to add a list entry is pressed
  void _addTodoItem(){

    // Putting our code inside "setState" tells the app that our state has changed, and
    // it will automatically re-render the list
    setState((){

      _todoItems.add(new Task(context, _todoItems));
    });
  }

  void _addTag(){

    setState((){

      _tags.add(Tag(context, _tags));
    });
  }

  //build whole list of todoitems
  Widget _buildTodoList() {
    return new DragAndDropList<Task>(
      _todoItems,
      itemBuilder: (BuildContext context, item) => item.toWidget(),
      onDragFinish: (before, after) {
        //_todoItems.insert(after, _todoItems.removeAt(before));
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
                _tags,
                itemBuilder: (BuildContext context, item) {

                  return item.toWidget();
                },
                onDragFinish: (before, after) {

                  _tags.insert(after, _tags.removeAt(before));
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