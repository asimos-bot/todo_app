import 'package:flutter/material.dart';
import 'Task.dart';
import 'Tag.dart';
import 'TaskList.dart';

class TaskBuilder {

  TaskList list;

  //disposed when task is deleted
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  TaskBuilder(this.list);

  void createTask(context){

    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => Scaffold(
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
            )
        )
    );
  }

  void close(){

    titleController.dispose();
    descriptionController.dispose();
  }
}