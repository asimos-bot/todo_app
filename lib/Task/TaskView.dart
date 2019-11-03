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

                      Text(task.title,style: TextStyle(color: globals.secondaryForegorundColor)),
                      Divider(),
                      Text(task.description,style: TextStyle(color: globals.secondaryForegorundColor)),
                      Expanded(
                          child: Center(
                              child: ClipOval(
                                  child:Container(
                                      padding: EdgeInsets.all(4.0),
                                      color: globals.foregroundColor,
                                      child:IconButton(
                                          hoverColor: globals.secondaryForegorundColor ,
                                          highlightColor: globals.secondaryForegorundColor ,
                                          focusColor: globals.secondaryForegorundColor,
                                          color: globals.secondaryForegorundColor,

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
                      Text("No Tag associated", style: TextStyle(color: globals.secondaryForegorundColor)),
                      Text('weight: ${task.weight.toString()}', style: TextStyle(color: globals.secondaryForegorundColor)),
                      Text(task.created_at.toIso8601String(), style: TextStyle(color: globals.secondaryForegorundColor))
                    ]
                )
            )
        );
  }
}