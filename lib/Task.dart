import 'package:flutter/material.dart';
import 'Tag.dart';
import 'TaskList.dart';

class Task {

  int id=-1;
  String title="";
  String description="";

  BuildContext context;

  //global list with all the ListEntries
  TaskList list;

  //disposed when task is deleted
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  //prompt for crating a entry
  Task(this.context, this.list);

  //return this entry in widget form
  Widget toWidget(){

    return new SizedBox(
      child: new Card(
        child: new ListTile(
          title: new Text(title, overflow: TextOverflow.ellipsis),
          subtitle: new Text(description, overflow: TextOverflow.ellipsis),
          onTap: () => taskView(),
        )
      )
    );
  }

  //edit ListEntry
  void taskEdit(){

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

                    Navigator.pop(context);
                  }
                )
              ]
          ),
          body: Form(
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: titleController
                ),
                Divider(),
                TextFormField(
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
  void taskView(){

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => taskEdit()
              )
            ]
          ),
          body: Container(
            child: Column(
              children: <Widget>[
                Text(title),
                Divider(),
                Text(description),
                IconButton(
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
              ]
            )
          )
        )
      )
    );
  }
}