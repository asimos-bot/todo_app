import 'package:flutter/material.dart';
import 'package:todo_yourself/Task/Task.dart';
import 'package:todo_yourself/Task/TaskEdit.dart';
import '../globals.dart' as globals;

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
                title: Text(task.title, overflow: TextOverflow.fade),
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
                                      color: globals.foregroundColor,
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
                                                            onPressed: () async {

                                                              await task.manager.delete(task);

                                                              setState(() {});

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
                      ),
                      task.tag != null ? task.tag.toSearchWidget(context, null) :
                      Text("No Tag associated", style: TextStyle(color: Colors.white)),
                      Text('weight: ${task.weight.toString()}', style: TextStyle(color: Colors.white)),
                      Text(task.created_at.toIso8601String())
                    ]
                )
            )
        );
  }
}