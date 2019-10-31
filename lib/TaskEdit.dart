import 'package:flutter/material.dart';
import 'Task.dart';
import 'Tag.dart';
import 'package:selection_menu/selection_menu.dart';
import 'package:selection_menu/components_configurations.dart';

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
                    TextFormField(

                      autofocus: true,
                      decoration: InputDecoration(filled: true, fillColor: Colors.white,hintText: "Title"),
                      style: TextStyle(color: Colors.black),
                      controller: task.titleController,
                    ),
                    Divider(),
                    TextFormField(
                        decoration: InputDecoration(filled: true, fillColor: Colors.white,hintText: "Description"),
                        style: TextStyle(color: Colors.black),
                        controller: task.descriptionController
                    ),
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
                                        return Center(
                                            child: RaisedButton(
                                                onPressed: data.triggerMenu,
                                                child: Text("Choose Tag")
                                            )
                                        );
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
                    )
                ]
            )
        )
    );
  }
}