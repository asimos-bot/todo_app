import 'package:flutter/material.dart';
import 'Tag.dart';
import 'Task.dart';
import 'TaskList.dart';
import 'package:selection_menu/selection_menu.dart';
import 'package:selection_menu/components_configurations.dart';

class TaskBuilder extends StatefulWidget {

  final TaskList list;

  TaskBuilder(this.list);

  @override
  createState() => TaskBuilderState(list);
}

class TaskBuilderState extends State<TaskBuilder> {

  TaskList list;
  Tag tag;

  TaskBuilderState(this.list);

  @override
  Widget build(BuildContext context){

    return Scaffold(
                appBar: AppBar(
                    title: Text('Create Task'),
                    actions: <Widget>[
                      IconButton(
                          icon: Icon(Icons.done),
                          onPressed: (){

                            var task = Task(list);

                            task.title = list.titleController.text;
                            task.description = list.descriptionController.text;

                            list.add(task);

                            Navigator.pop(context);
                          }
                      )
                    ]
                ),
                body: Form(
                    child: ListView(
                        children: <Widget>[
                          TextFormField(

                            decoration: InputDecoration(filled: true, fillColor: Colors.white,hintText: "Title"),
                            style: TextStyle(color: Colors.black),
                            controller: list.titleController,
                          ),
                          Divider(),
                          TextFormField(
                              decoration: InputDecoration(filled: true, fillColor: Colors.white,hintText: "Description"),
                              style: TextStyle(color: Colors.black),
                              controller: list.descriptionController
                          ),
                          Divider(),
                          FutureBuilder(
                              future: list.tagList.list(),
                              builder: (context, snapshot) {

                                print(list.tagList.length);

                                if( snapshot.connectionState == ConnectionState.done ){

                                  if( list.tagList.length > 0 ) {

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
                                        this.tag = tag;
                                      },
                                      itemBuilder: (BuildContext context, Tag tag,
                                          OnItemTapped onItemTapped) =>
                                          tag.toSearchWidget(context, onItemTapped),
                                      componentsConfiguration: DialogComponentsConfiguration<Tag>(
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

                                  }else{

                                    return Card(
                                        color: Colors.white,
                                        child: Center(
                                          child: Text("No Tag Available")
                                        )
                                      );
                                  }
                                }else{

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