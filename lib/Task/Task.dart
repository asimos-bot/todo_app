import 'package:flutter/material.dart';
import '../Tag/Tag.dart';
import 'package:todo_yourself/Task/TaskList.dart';
import 'package:todo_yourself/Task/TaskView.dart';
import '../FormWidgets/Controller.dart';

class Task extends Controller {

  int id=-1;

  Tag tag=null;

  //global list with all the ListEntries
  TaskList list;

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
}