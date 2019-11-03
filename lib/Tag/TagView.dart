import 'package:flutter/material.dart';
import 'package:todo_yourself/Tag/TagEdit.dart';
import 'package:todo_yourself/Tag/Tag.dart';
import 'TagManager.dart';
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
                  title: Text(tag.title, overflow: TextOverflow.fade),
                  actions: <Widget>[
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
              body: Container(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                      children: <Widget>[

                        Text(tag.title,style: TextStyle(color: globals.secondaryForegorundColor)),
                        Divider(),
                        Text(tag.description,style: TextStyle(color: globals.secondaryForegorundColor)),
                        Divider(),
                        Expanded(
                            child: Center(
                                child: ClipOval(
                                    child:Container(
                                        padding: EdgeInsets.all(4.0),
                                        color: globals.foregroundColor,
                                        child:IconButton(
                                            hoverColor: globals.secondaryForegorundColor,
                                            highlightColor: globals.secondaryForegorundColor,
                                            focusColor: globals.secondaryForegorundColor,
                                            color: globals.secondaryForegorundColor,

                                            icon: Icon(Icons.delete),
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                        title: Text('Are you sure you want to delete this tag?'),
                                                        actions: <Widget>[
                                                          FlatButton(
                                                              child: Text('Yes'),
                                                              onPressed: () async {

                                                                await tag.manager.delete(tag);

                                                                setState(() {});

                                                                Navigator.pop(context);
                                                                Navigator.pop(context);
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
                                        )
                                    )
                                )
                            )
                        ),
                        tag.toSearchWidget(context, null),
                        Text('weight: ${tag.weight.toString()}', style: TextStyle(color: globals.secondaryForegorundColor)),
                        Text(tag.created_at.toIso8601String(), style: TextStyle(color: globals.secondaryForegorundColor)),
                        Text(tag.total_points.toString(), style: TextStyle(color: globals.secondaryForegorundColor))
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