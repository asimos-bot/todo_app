import 'package:flutter/material.dart';
import 'package:todo_yourself/Task/Task.dart';
import '../Tag/Tag.dart';
import 'package:selection_menu/selection_menu.dart';
import 'package:selection_menu/components_configurations.dart';
import '../FormWidgets/WeightSlider.dart';
import '../FormWidgets/TextForm.dart';

class TaskEdit extends StatefulWidget {

  final Task task;

  TaskEdit(this.task);

  @override
  createState() => TaskEditState(task);
}

class TaskEditState extends State<TaskEdit> {

  Task task;

  TaskEditState(this.task);

  @override
  Widget build(BuildContext context){

    return Scaffold(
        appBar: AppBar(
            title: Text('Task Edit'),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.done),
                  onPressed: (){

                    task.title = task.titleController.text;
                    task.description = task.descriptionController.text;

                    task.list.update(task);

                    Navigator.pop(context);
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
                      future: task.list.tagList.list(),
                      builder: (context, snapshot) {

                        if (snapshot.connectionState == ConnectionState.done) {

                          if (task.list.tagList.length > 0) {

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
                                task.tag = tag;
                              },
                              itemBuilder: (BuildContext context, Tag tag,
                                  OnItemTapped onItemTapped) =>
                                  tag.toSearchWidget(context, onItemTapped),
                              componentsConfiguration: DialogComponentsConfiguration<
                                  Tag>(
                                  triggerComponent: TriggerComponent(
                                      builder: (TriggerComponentData data) {
                                        //widget of the button that calls the menu

                                        if( task.tag == null ) {
                                          //when no tag is selected for this task
                                          return Center(
                                              child: RaisedButton(
                                                  onPressed: data.triggerMenu,
                                                  child: Text("Choose Tag")
                                              )
                                          );
                                        }else{

                                          return task.tag.toMenuButtonWidget(context, data);
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
                    WeightSlider(task, task.weight.toDouble())
                ]
            )
        )
    );
  }
}