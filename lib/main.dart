import 'package:flutter/material.dart';
import 'ListEntry.dart';
import 'Category.dart';

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
  List<ListEntry> _todoItems = [];

  //will be called every time the button to add a list entry is pressed
  void _addTodoItem(){

    // Putting our code inside "setState" tells the app that our state has changed, and
    // it will automatically re-render the list
    setState((){

      int index = _todoItems.length;
      _todoItems.insert(0, new ListEntry('Item: ' + index.toString(), index));
    });
  }

  //build whole list of todoitems
  Widget _buildTodoList() {
    return new ListView.builder(
      itemBuilder: (context, index) {
        // itemBuilder will be automatically be called as many times as it takes for the
        // list to fill up its available space, which is most likely more than the
        // number of todoitems we have. So, we need to check the index is OK.
        if(index < _todoItems.length) {
          return DragTarget(
              builder: (context, List<Widget> candidateData, rejectedData){

                return _todoItems[index].toWidget();
              },
              onWillAccept: (data) {

                return true;
              }
          );
        }
      },
    );
  }

Future<String> ifAddPressed(BuildContext context){
    
  TextEditingController customController = TextEditingController();
    
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('Submit category name'),
        content: TextField(
          controller: customController,
        ),
        actions: <Widget>[
          MaterialButton(
            elevation: 4.0,
            child: new Text('Submit'),
            onPressed: (){
              Navigator.of(context).pop(customController.text.toString());
              setState(() {
              });
            }
          )
        ],
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    
    var children;
    
    var DHeader = new DrawerHeader(
      child: new Text('Categories')
    );
    
    var AddCat = new ListTile(
      leading: Icon(Icons.add),
      title: Text('Add category'),
      onTap: (){
        ifAddPressed(context).then((onValue){
            children.add(new ListTile(
              title: Text('$onValue'),
              onTap: (){}
            ));
          }
        );}
      );  

      children = [DHeader,AddCat];


    

    return new Scaffold(
      //slide bar
      drawer: new Drawer(
          child: new ListView(
            children: children
          )
      ),
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
                    child: IconButton(icon: Icon(Icons.delete))
                ),
                Expanded(
                    child: IconButton(icon: Icon(Icons.home))
                ),
                Expanded(
                    child: IconButton(icon: Icon(Icons.add), onPressed: _addTodoItem)
                ),
              ]
          )
        ),
      );
  }
}