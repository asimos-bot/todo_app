import 'package:flutter/material.dart';
import 'Task.dart';
import 'TaskEdit.dart';

class TaskView extends StatefulWidget {

  final Task task;

  TaskView(this.task);

  @override
  createState() => TaskViewState(task);
}

class TaskViewState extends State<TaskView> {

  Task task;

  TaskViewState(this.task);

  @override
  Widget build(BuildContext context){

    return Scaffold(
            appBar: AppBar(
                title: Text("Task description"),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        task.updateTextControllers();
                        Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => TaskEdit(task)
                            )
                        );
                      }
                  )
                ]
            ),
            body: Container(
                padding: EdgeInsets.all(30.0),
                child: Column(
                    children: <Widget>[

                      Text(task.title,style: TextStyle(color: Colors.white)),
                      Divider(),
                      Text(task.description,style: TextStyle(color: Colors.white)),
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
                                                              task.list.delete(task);

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
        );
  }
}