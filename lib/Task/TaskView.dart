import 'package:flutter/material.dart';
import 'package:todo_yourself/Task/Task.dart';
import 'package:todo_yourself/Task/TaskEdit.dart';
import 'TaskManager.dart';
import '../globals.dart' as globals;

class TaskView extends StatefulWidget {

  final int task;
  final TaskManager manager;

  TaskView(this.task, this.manager);

  @override
  createState() => TaskViewState(manager.get(task));
}

class TaskViewState extends State<TaskView> {

  Future<Task> futureTask;

  TaskViewState(this.futureTask);

  @override
  Widget build(BuildContext context){

    return FutureBuilder(
      future: futureTask,
      builder: (context, snapshot) {

        if(snapshot.connectionState == ConnectionState.done){

          Task task = snapshot.data;

          return Scaffold(
              appBar: AppBar(
                  title: Text(task.title, overflow: TextOverflow.ellipsis),
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

                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            task.title,
                            textScaleFactor: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: globals.secondaryForegroundColor
                            )
                          )
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                              task.description,
                              style: TextStyle(
                                  color: globals.secondaryForegroundColor.withOpacity(0.8)
                              )
                          )
                        ),
                        Divider(),
                        task.tag != null ?
                        task.tag.toSearchWidget(context, (){}) :
                        Card(
                            child: ListTile(
                                title: Text(
                                    "No Tag associated",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: globals.backgroundColor)
                                )
                            )
                        ),
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
                                                'Created In',
                                                textScaleFactor: 1.5,
                                                style: TextStyle(color: globals.backgroundColor)
                                            ),
                                            Divider(
                                                color: globals.secondaryForegroundColor
                                            ),
                                            Text(
                                                '${task.created_at.day}/${task.created_at.month}/${task.created_at.year.toString().substring(2,4)}'
                                                    ' ${task.created_at.hour}:${task.created_at.minute}',
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

        return Center(
          child: CircularProgressIndicator()
        );
      }
    );
  }
}