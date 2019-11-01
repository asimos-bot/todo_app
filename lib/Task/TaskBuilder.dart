import 'package:flutter/material.dart';
import '../Tag/Tag.dart';
import 'package:todo_yourself/Task/Task.dart';
import 'package:todo_yourself/Task/TaskManager.dart';
import 'package:selection_menu/selection_menu.dart';
import 'package:selection_menu/components_configurations.dart';
import '../FormWidgets/WeightSlider.dart';
import '../FormWidgets/TextForm.dart';

class TaskBuilder extends StatefulWidget {

  final TaskManager list;

  TaskBuilder(this.list);

  @override
  createState() => TaskBuilderState(list);
}

class TaskBuilderState extends State<TaskBuilder> {

  TaskManager list;
  Tag tmpTag;

  TaskBuilderState(this.list){
    tmpTag = null;
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

                            var task = Task(list);

                            task.title = list.titleController.text;
                            task.description = list.descriptionController.text;
                            task.weight = int.parse(list.weightController.text);
                            task.tag = tmpTag;

                            list.add(task);

                            Navigator.pop(context);
                          }
                      )
                    ]
                ),
                body: Form(
                    child: ListView(
                        children: <Widget>[
                          TextForm(list),
                          Divider(),
                          FutureBuilder(
                              future: list.tagList.list(),
                              builder: (context, snapshot) {

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
                                        tmpTag = tag;
                                      },
                                      itemBuilder: (BuildContext context, Tag tag,
                                          OnItemTapped onItemTapped) =>
                                          tag.toSearchWidget(context, onItemTapped),
                                      componentsConfiguration: DialogComponentsConfiguration<Tag>(
                                          triggerComponent: TriggerComponent(
                                              builder: (TriggerComponentData data) {

                                                if( tmpTag == null ){
                                                  //widget of the button that calls the menu
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
                          ),
                          WeightSlider(list, 1.0)
                        ]
                    )
                )
            );
  }
}