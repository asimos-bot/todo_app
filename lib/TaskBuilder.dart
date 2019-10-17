import 'package:flutter/material.dart';
import 'Task.dart';

class TaskBuilder {

  BuildContext context;
  List<Task> list;

  //disposed when task is deleted
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  TaskBuilder(this.context, this.list);

  void createTask(){

    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => Scaffold(
                appBar: AppBar(
                    title: Text('Create Task'),
                    actions: <Widget>[
                      IconButton(
                          icon: Icon(Icons.done),
                          onPressed: (){

                            var title = titleController.text;
                            var _description = descriptionController.text;

                            var task = Task(context, list);

                            task.title = title;
                            task.description = _description;

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
}