import 'package:flutter/material.dart';
import 'Tag.dart';

class Task {

  String _title="";
  String _description="";

  BuildContext context;

  //global list with all the ListEntries
  List<Task> list;

  //disposed when task is deleted
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  //prompt for creating an entry
  Task(this.context, this.list){

    TaskEdit('Create Task');
  }

  //return this entry in widget form
  Widget toWidget(){

    return new SizedBox(
      child: new Card(
        child: new ListTile(
          title: new Text(_title, overflow: TextOverflow.ellipsis),
          subtitle: new Text(_description, overflow: TextOverflow.ellipsis),
          onTap: () => TaskView(),
        )
      )
    );
  }

  //edit ListEntry
  void TaskEdit(String appBarTitle){

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
              title: Text(appBarTitle),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.done),
                  onPressed: (){

                    _title = titleController.text;
                    _description = descriptionController.text;

                    Navigator.pop(context);
                  }
                )
              ]
          ),
          body: Form(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(filled: true, fillColor: Colors.white,hintText: "Title"),
                  style: TextStyle(color: Colors.black),
                  controller: titleController,
                ),
                Divider(),
                TextFormField(
                  decoration: InputDecoration(filled: true, fillColor: Colors.white,hintText: "Description"),
                  style: TextStyle(color: Colors.black),
                  controller: descriptionController
                )
              ]
            )
          )
        )
      )
    );
  }

  //view ListEntry content, has a button to go to ListEntryEdit
  void TaskView(){

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text("Task description"),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => TaskEdit('Edit')
              )
            ]
          ),
          body: Container(
            padding: EdgeInsets.all(30.0),
            child: Column(
              children: <Widget>[
                Text(_title,style: TextStyle(color: Colors.white)),
                Divider(),
                Text(_description,style: TextStyle(color: Colors.white)),
                ClipOval(child:Container(padding: EdgeInsets.all(4.0),color: Color(0xFF6A1B9A),child:IconButton(
                  hoverColor: Colors.white ,
                  highlightColor:Colors.white ,
                  focusColor: Colors.white,
                  color: Colors.white,
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Are you sure you want to delete this task?'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Yes'),
                              onPressed: () {
                                titleController.dispose();
                                descriptionController.dispose();

                                list.remove(this);

                                Navigator.pop(context);
                                Navigator.pop(context);
                              }
                            ),
                            FlatButton(
                              child: Text('No'),
                              onPressed: () {

                                Navigator.pop(context);
                              }
                            )
                          ]
                        );
                      }
                    );
                  }
                )))
              ]
            )
          )
        )
      )
    );
  }
}