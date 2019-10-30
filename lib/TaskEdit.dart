import 'package:flutter/material.dart';
import 'Task.dart';
import 'Tag.dart';
import 'TaskList.dart';

class TaskEdit extends StatefulWidget {

  final Task task;

  TaskEdit(this.task);

  @override
  createState() => TaskEditState(task);
}

class TaskEditState extends State<TaskEdit> {

  Task task;

  TaskEditState(this.task);

  @override
  Widget build(BuildContext context){

    return Scaffold(
        appBar: AppBar(
            title: Text('Task Edit'),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.done),
                  onPressed: (){

                    task.title = task.titleController.text;
                    task.description = task.descriptionController.text;

                    task.list.update(task);

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
                    controller: task.titleController,
                  ),
                  Divider(),
                  TextFormField(
                      decoration: InputDecoration(filled: true, fillColor: Colors.white,hintText: "Description"),
                      style: TextStyle(color: Colors.black),
                      controller: task.descriptionController
                  )
                ]
            )
        )
    );
  }
}