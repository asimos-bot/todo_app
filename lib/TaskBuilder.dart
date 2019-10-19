import 'package:flutter/material.dart';
import 'Task.dart';
import 'Tag.dart';
import 'TaskList.dart';

class TaskBuilder extends StatefulWidget {

  final TaskList list;

  TaskBuilder(this.list);

  @override
  createState() => TaskBuilderState(list);
}

class TaskBuilderState extends State<TaskBuilder> {

  TaskList list;

  TaskBuilderState(this.list);

  @override
  Widget build(BuildContext context){

    //disposed when task is deleted
    final titleController = TextEditingController(text: "");
    final descriptionController = TextEditingController(text: "");

    return Scaffold(
                appBar: AppBar(
                    title: Text('Create Task'),
                    actions: <Widget>[
                      IconButton(
                          icon: Icon(Icons.done),
                          onPressed: (){

                            var task = Task(list);

                            task.title = titleController.text;
                            task.description = descriptionController.text;

                            list.add(task);

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
            );
  }
}