import 'package:flutter/material.dart';
import '../Tag/Tag.dart';
import 'package:todo_yourself/Task/Task.dart';
import 'package:todo_yourself/Task/TaskList.dart';
import 'package:selection_menu/selection_menu.dart';
import 'package:selection_menu/components_configurations.dart';
import 'package:flutter/services.dart';

class TaskBuilder extends StatefulWidget {

  final TaskList list;

  TaskBuilder(this.list);

  @override
  createState() => TaskBuilderState(list);
}

class TaskBuilderState extends State<TaskBuilder> {

  TaskList list;
  Tag tag;

  double currentSliderValue=1;

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

                            autofocus: true,
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
                          ),
                          Slider(
                              activeColor: Colors.indigoAccent,
                              min: -50,
                              max: 50,
                              onChanged: (newWeight) {
                                setState(() {
                                  currentSliderValue = newWeight;
                                  list.weightController.value = new TextEditingController.fromValue(new TextEditingValue(text: newWeight.round().toString())).value;
                                });
                              },
                              value: currentSliderValue
                          ),
                          Divider(),
                          TextFormField(
                              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                              decoration: InputDecoration(filled: true, fillColor: Colors.white),
                              style: TextStyle(color: Colors.black),
                              controller: list.weightController
                          )
                        ]
                    )
                )
            );
  }
}