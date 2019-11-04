import 'package:flutter/material.dart';
import 'package:todo_yourself/Task/Task.dart';
import '../Tag/Tag.dart';
import 'package:selection_menu/selection_menu.dart';
import 'package:selection_menu/components_configurations.dart';
import '../FormWidgets/WeightSlider.dart';
import '../FormWidgets/TextForm.dart';
import '../FormWidgets/ModeSwitch.dart';
import '../globals.dart' as globals;

class TaskEdit extends StatefulWidget {

  final Task task;

  TaskEdit(this.task);

  @override
  createState() => TaskEditState(task, SwitchValueWrapper(task.taskModeToBool()));
}

class TaskEditState extends State<TaskEdit> {

  Task task;
  Tag tmpTag;
  SwitchValueWrapper tmpMode;

  TaskEditState(this.task, this.tmpMode){
    tmpTag = task.tag;
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
        appBar: AppBar(
            title: Text(task.title, overflow: TextOverflow.fade),
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
                    task.tag = tmpTag;
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
                            return SelectionMenu<Tag>(
                              itemsList: snapshot.data,
                              itemSearchMatcher: (String query, Tag tag) {
                                query = query.trim().toLowerCase();
                                return tag.title.toLowerCase().trim().contains(
                                    query) || tag.description.trim()
                                    .toLowerCase()
                                    .contains(query);
                              },
                              searchLatency: Duration(milliseconds: 500),
                              onItemSelected: (Tag tag) {
                                tmpTag = tag;
                              },
                              itemBuilder:
                                  (BuildContext context, Tag tag, OnItemTapped onItemTapped) => tag.toSearchWidget(context, onItemTapped),

                              componentsConfiguration: DialogComponentsConfiguration<Tag>(
                                  triggerComponent: TriggerComponent(
                                      builder: (TriggerComponentData data) {
                                        //widget of the button that calls the menu

                                        if( tmpTag == null ) {

                                          //when no tag is selected for this task
                                          return Center(
                                              child: RaisedButton(
                                                  onPressed: data.triggerMenu,
                                                  child: Text("Choose Tag")
                                              )
                                          );

                                        }else{

                                          return tmpTag.toMenuButtonWidget(context, data);
                                        }
                                      }
                                  )
                              ),
                            );
                          } else {

                            //appears when there is not tag to select
                            return Card(
                                child: Center(
                                    child: Text("No Tag Available")
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
                    WeightSlider(task, task.weight.toDouble()),
                    ModeSwitch(tmpMode)
                ]
            )
        )
    );
  }
}