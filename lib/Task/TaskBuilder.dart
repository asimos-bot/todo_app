import 'package:flutter/material.dart';
import 'package:todo_yourself/Task/Task.dart';
import 'package:todo_yourself/Task/TaskManager.dart';
import '../FormWidgets/FormSlider.dart';
import '../FormWidgets/TextForm.dart';
import '../FormWidgets/ModeSwitch.dart';
import '../Tag/TagSearch.dart';

class TaskBuilder extends StatefulWidget {

  final TaskManager manager;

  TaskBuilder(this.manager);

  @override
  createState() => TaskBuilderState(manager);
}

class TaskBuilderState extends State<TaskBuilder> {

  TaskManager manager;
  TagWrapper tmpTag;
  SwitchValueWrapper tmpMode = SwitchValueWrapper(false); //1 - habit, 0 - singular

  TaskBuilderState(this.manager){
    tmpTag = TagWrapper(null);
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
                appBar: AppBar(
                    title: Text('Create Task'),
                    actions: <Widget>[
                      IconButton(
                          icon: Icon(Icons.done),
                          onPressed: (){

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

                            var task = Task(manager);

                            task.title = manager.titleController.text;
                            task.description = manager.descriptionController.text;
                            task.weight = int.parse(manager.weightController.text);
                            task.tag = tmpTag.tag;
                            task.boolToTaskMode(tmpMode.value);

                            manager.add(task);

                            Navigator.pop(context);
                          }
                      )
                    ]
                ),
                body: Form(
                    child: ListView(
                        children: <Widget>[
                          TextForm(manager),
                          Divider(),
                          FutureBuilder(
                              future: manager.tagManager.list(),
                              builder: (context, snapshot) {

                                if( snapshot.connectionState == ConnectionState.done ){

                                  if( manager.tagManager.length > 0 ) {

                                    return TagSearch(snapshot.data, tmpTag, ()=>setState((){}));

                                  }else{

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
                                }else{

                                  return Center(
                                      child: CircularProgressIndicator()
                                  );
                                }
                              }
                          ),
                          FormSlider(manager, 1.0),
                          ModeSwitch(tmpMode)
                        ]
                    )
                )
            );
  }
}