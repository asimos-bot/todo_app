import 'package:flutter/material.dart';
import 'package:todo_yourself/Task/Task.dart';
import '../FormWidgets/FormSlider.dart';
import '../FormWidgets/TextForm.dart';
import '../FormWidgets/ModeSwitch.dart';
import '../Tag/TagSearch.dart';
import '../globals.dart' as globals;

class TaskEdit extends StatefulWidget {

  final Task task;

  TaskEdit(this.task);

  @override
  createState() => TaskEditState(task, SwitchValueWrapper(task.taskModeToBool()));
}

class TaskEditState extends State<TaskEdit> {

  Task task;
  TagWrapper tmpTag;
  SwitchValueWrapper tmpMode;

  TaskEditState(this.task, this.tmpMode){
    tmpTag = TagWrapper(task.tag);
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
        appBar: AppBar(
            title: Text(task.title, overflow: TextOverflow.ellipsis),
            actions: <Widget>[
              IconButton(
                  hoverColor: globals.secondaryForegroundColor ,
                  highlightColor: globals.secondaryForegroundColor ,
                  focusColor: globals.secondaryForegroundColor,
                  color: globals.secondaryForegroundColor,

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

                                      //pop to root
                                      Navigator.popUntil(context, (route) => route.isFirst);
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
              ),
              IconButton(
                  icon: Icon(Icons.done),
                  onPressed: () async {

                    //check if task is not in habit mode and doesn't have a tag
                    if( tmpMode.value == true && tmpTag == null ){

                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                                title: Text("Invalid Tag"),
                                content: Text("A tag can't be in habit mode and have no tag associated"),
                                actions: <Widget> [
                                  FlatButton(
                                      child: Text("Ok"),
                                      onPressed: () => Navigator.of(context).pop()
                                  )
                                ]
                            );
                          }
                      );

                      return;
                    }

                    task.title = task.titleController.text;
                    task.description = task.descriptionController.text;
                    task.weight = int.parse(task.weightController.text);
                    task.tag = tmpTag.tag;
                    task.boolToTaskMode(tmpMode.value);

                    if( task.tag != null && task.checked){

                      await task.tag.manager.changeTotalPoints(
                          task.tag,
                          task.weight
                      );
                    }

                    if( task.mode == TaskMode.habit ) task.checked = false;

                    task.manager.update(task);

                    Navigator.of(context).pop();
                  }
              )
            ]
        ),
        body: Form(
            child: ListView(
                  children: <Widget>[
                    TextForm(task),
                    Divider(),
                    FutureBuilder(
                      future: task.manager.tagManager.list(),
                      builder: (context, snapshot) {

                        if (snapshot.connectionState == ConnectionState.done) {

                          if (task.manager.tagManager.length > 0) {

                            //appear when there are tags to select
                            return TagSearch(snapshot.data, tmpTag, ()=>setState((){}));

                          } else {

                            //appears when there is not tag to select
                            return Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Card(
                                child: Container(
                                  width: 200,
                                  height: 50,
                                  child: Center(
                                    child: Text("No Tag Available")
                                  )
                                )
                              )
                            );
                          }
                        } else {
                          //appears while loading future
                          return Center(
                              child: CircularProgressIndicator()
                          );
                        }
                      }
                    ),
                    FormSlider(task, task.weight.toDouble()),
                    ModeSwitch(tmpMode)
                ]
            )
        )
    );
  }
}