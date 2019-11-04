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
            body: SingleChildScrollView(
                padding: EdgeInsets.all(10.0),
                child: Column(
                    children: <Widget>[

                      Text(
                          task.title,
                          textScaleFactor: 2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: globals.secondaryForegroundColor
                          )
                      ),
                      Divider(),
                      Text(
                          task.description,
                          style: TextStyle(
                              color: globals.secondaryForegroundColor.withOpacity(0.8)
                          )
                      ),
                      Divider(),
                      task.tag != null ?
                      task.tag.toSearchWidget(context, null) :
                      Card(
                        child: ListTile(
                          title: Text(
                            "No Tag associated",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: globals.backgroundColor)
                          )
                        )
                      ),
                      Divider(),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget> [
                            Expanded(
                                child: Card(
                                    color: globals.secondaryForegroundColor,
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget> [
                                          Divider(
                                              color: globals.secondaryForegroundColor
                                          ),
                                          Text(
                                              'Weight',
                                              textScaleFactor: 1.5,
                                              style: TextStyle(color: globals.backgroundColor)
                                          ),
                                          Divider(
                                              color: globals.secondaryForegroundColor
                                          ),
                                          Text(
                                              '${task.weight.toString()}',
                                              textScaleFactor: 1.5,
                                              style: TextStyle(color: globals.backgroundColor)
                                          ),
                                          Divider(
                                              color: globals.secondaryForegroundColor
                                          )
                                        ]
                                    )
                                )
                            ),
                            Expanded(
                                child: Card(
                                    color: globals.secondaryForegroundColor,
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget> [
                                          Divider(
                                              color: globals.secondaryForegroundColor
                                          ),
                                          Text(
                                              'Priority',
                                              textScaleFactor: 1.5,
                                              style: TextStyle(color: globals.backgroundColor)
                                          ),
                                          Divider(
                                              color: globals.secondaryForegroundColor
                                          ),
                                          Text(
                                              '${task.priority.toString()}',
                                              textScaleFactor: 1.5,
                                              style: TextStyle(color: globals.backgroundColor)
                                          ),
                                          Divider(
                                              color: globals.secondaryForegroundColor
                                          )
                                        ]
                                    )
                                )
                            )
                          ]
                      ),
                    ]
                )
            )
        );
  }
}