import 'package:flutter/material.dart';
import 'package:todo_yourself/Tag/TagEdit.dart';
import 'package:todo_yourself/Tag/Tag.dart';
import 'TagManager.dart';
import '../Task/Task.dart';
import '../globals.dart' as globals;

class TagView extends StatefulWidget {

  final int tag;
  final TagManager manager;

  TagView(this.tag, this.manager);

  @override
  createState() => TagViewState(manager.get(tag));
}

class TagViewState extends State<TagView> {

  Future<Tag> futureTag;

  TagViewState(this.futureTag);

  @override
  Widget build(BuildContext context){

    return FutureBuilder(
      future: futureTag,
      builder: (context, snapshot) {

        if( snapshot.connectionState == ConnectionState.done ){

          Tag tag = snapshot.data;

          return Scaffold(
              appBar: AppBar(
                  title: Center(child:
                    Text(
                        tag.title,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center
                    )
                  ),
                  actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.search, color: globals.secondaryForegroundColor)
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
              body: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                      children: <Widget>[

                        Text(
                            tag.title,
                            textScaleFactor: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: globals.secondaryForegroundColor
                            )
                        ),
                        Divider(),
                        Text(
                            tag.description,
                            style: TextStyle(color: globals.secondaryForegroundColor.withOpacity(0.8))
                        ),
                        Divider(),
                        tag.toSearchWidget(context, null),
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
                                        '${tag.weight.toString()}',
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
                            )
                          ]
                        ),
                        FutureBuilder(
                          future: tag.manager.getTasks(tag),
                          builder: (context, snapshot) {

                            if( snapshot.connectionState == ConnectionState.done ){

                              List<Task> tasks = snapshot.data;

                              return Expanded(
                                child: ListView.builder(
                                  itemCount: tasks.length,
                                  itemBuilder: (context, index) => tasks[index].toWidget((){setState((){});})
                                )
                              );
                            }

                            return Center(
                              child: CircularProgressIndicator()
                            );
                          }
                        )
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