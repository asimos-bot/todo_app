import 'package:flutter/material.dart';
import 'Tag.dart';
import 'TaskList.dart';
import 'TaskView.dart';

class Task {

  int id=-1;
  String title="";
  String description="";

  Tag tag=null;

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
          onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => TaskView(this)
              )
          )
        )
      )
    );
  }

  void updateTextControllers(){
    titleController.value = new TextEditingController.fromValue(new TextEditingValue(text: title)).value;
    descriptionController.value = new TextEditingController.fromValue(new TextEditingValue(text: description)).value;
  }

  void dispose(){
    titleController.dispose();
    descriptionController.dispose();
  }
}