import 'package:flutter/material.dart';
import 'Tag.dart';
import 'TaskList.dart';

class Task {

  int id=-1;
  String title="";
  String description="";

  //global list with all the ListEntries
  TaskList list;

  //disposed when task is deleted
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  //prompt for crating a entry
  Task(this.list);

  //return this entry in widget form
  Widget toWidget(context){

    return new SizedBox(
      child: new Card(
        child: new ListTile(
          title: new Text(title, overflow: TextOverflow.ellipsis),
          subtitle: new Text(description, overflow: TextOverflow.ellipsis),
          onTap: () => taskView(context),
        )
      )
    );
  }

  //edit ListEntry
  void taskEdit(context){

    titleController.value = new TextEditingController.fromValue(new TextEditingValue(text: title)).value;
    descriptionController.value = new TextEditingController.fromValue(new TextEditingValue(text: description)).value;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
              title: Text('Edit'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.done),
                  onPressed: (){

                    title = titleController.text;
                    description = descriptionController.text;

                    list.update(this);

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
  void taskView(context){

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text("Task description"),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => taskEdit(context)
              )
            ]
          ),
          body: Container(
            padding: EdgeInsets.all(30.0),
            child: Column(
              children: <Widget>[

                Text(title,style: TextStyle(color: Colors.white)),
                Divider(),
                Text(description,style: TextStyle(color: Colors.white)),
                Expanded(
                  child: Center(
                    child: ClipOval(
                      child:Container(
                        padding: EdgeInsets.all(4.0),
                        color: Color(0xFF6A1B9A),
                        child:IconButton(
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
                        )
                      )
                    )
                  )
                )
              ]
            )
          )
        )
      )
    );
  }
}