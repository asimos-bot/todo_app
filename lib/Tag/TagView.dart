import 'package:flutter/material.dart';
import 'package:todo_yourself/Tag/TagEdit.dart';
import 'package:todo_yourself/Tag/Tag.dart';
import 'TagManager.dart';
import '../Task/Task.dart';
import 'TagChart.dart';
import '../globals.dart' as globals;

class TagView extends StatefulWidget {

  final int tag;
  final TagManager manager;

  TagView(this.tag, this.manager);

  @override
  createState() => TagViewState(manager.get(tag), TextEditingController());
}

class TagViewState extends State<TagView> {

  Future<Tag> futureTag;

  TextEditingController taskSearchController;

  bool searchMode = false;

  TagViewState(this.futureTag, this.taskSearchController);

  @override
  @mustCallSuper
  void initState(){

    super.initState();

    taskSearchController.addListener((){

      if(taskSearchController.text!=''){

        setState((){});
      }
    });
  }

  @override
  Widget build(BuildContext context){

    return FutureBuilder(
      future: futureTag,
      builder: (context, snapshot) {

        if( snapshot.connectionState == ConnectionState.done ){

          Tag tag = snapshot.data;

          return Scaffold(
            appBar: AppBar(
                title: Center(
                  child: searchMode ?
                  TextField(
                    style: TextStyle(
                      color: globals.secondaryForegroundColor
                    ),
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: globals.secondaryForegroundColor
                        ),
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: globals.secondaryForegroundColor
                        ),
                        hintText: 'Search...'
                    ),
                    controller: taskSearchController,
                  ) :
                  Text(
                      tag.title,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center
                  )
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                        searchMode ? Icons.close : Icons.search,
                        color: globals.secondaryForegroundColor
                    ),
                    onPressed: (){

                      if(searchMode) taskSearchController.value = new TextEditingController.fromValue(new TextEditingValue(text: '')).value;

                      searchMode = !searchMode;

                      setState((){});
                    },
                  ),
                  IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {

                        tag.updateTextControllers();

                        Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => TagEdit(tag)
                            )
                        );
                      }
                  )
                ]
            ),
            body: PageView(
                children: <Widget> [
                  CustomScrollView(
                  slivers: <Widget>[

                    SliverList(
                      delegate: SliverChildListDelegate(
                        <Widget>[
                          Padding(
                            padding: EdgeInsets.all(10),
                            child:Text(
                              tag.title,
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
                                tag.description,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: globals.secondaryForegroundColor.withOpacity(0.8))
                            )
                          ),
                          tag.toSearchWidget(context, null)
                        ]
                      )
                    ),
                    SliverGrid.count(
                      crossAxisCount: 2,
                      childAspectRatio: 1.6,
                      children: <Widget> [
                        Card(
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
                                    '${tag.weight.toString()}',
                                    textScaleFactor: 1.5,
                                    style: TextStyle(color: globals.backgroundColor)
                                ),
                                Divider(
                                  color: globals.secondaryForegroundColor
                                )
                              ]
                            )
                        ),
                        Card(
                            color: globals.secondaryForegroundColor,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget> [
                                  Divider(
                                      color: globals.secondaryForegroundColor
                                  ),
                                  Text(
                                      'Points',
                                      textScaleFactor: 1.5,
                                      style: TextStyle(color: globals.backgroundColor)
                                  ),
                                  Divider(
                                      color: globals.secondaryForegroundColor
                                  ),
                                  Text(
                                      '${tag.total_points.toString()}',
                                      textScaleFactor: 1.5,
                                      style: TextStyle(color: globals.backgroundColor)
                                  ),
                                  Divider(
                                      color: globals.secondaryForegroundColor
                                  )
                                ]
                            )
                        )
                      ]
                    ),
                    FutureBuilder(
                      future: taskSearchController.text == '' ?
                        tag.manager.getTasks(tag) :
                        tag.manager.taskManager.query(taskSearchController.text, tag.id),
                      builder: (context, snapshot) {

                        if( snapshot.connectionState == ConnectionState.done ){

                          List<Task> tasks = snapshot.data;

                          return SliverList(
                            delegate: SliverChildBuilderDelegate(
                                (context, index) {

                                  return tasks[index].toWidget(()=>setState((){}));
                                },
                                childCount: tasks.length
                            )
                          );
                        }

                        return SliverList(
                          delegate: SliverChildListDelegate(
                            <Widget> [
                              CircularProgressIndicator()
                            ]
                          ),
                        );
                      }
                    )
                  ]
                  ),
                  TagChart(tag.manager.getPoints(tag.id), tag)
                ]
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