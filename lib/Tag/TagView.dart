import 'package:flutter/material.dart';
import 'package:todo_yourself/Tag/TagEdit.dart';
import 'package:todo_yourself/Tag/Tag.dart';
import '../globals.dart' as globals;

class TagView extends StatefulWidget {

  final Tag tag;

  TagView(this.tag);

  @override
  createState() => TagViewState(tag);
}

class TagViewState extends State<TagView> {

  Tag tag;

  TagViewState(this.tag);

  @override
  Widget build(BuildContext context){

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

                  Text(tag.title,style: TextStyle(color: Colors.white)),
                  Divider(),
                  Text(tag.description,style: TextStyle(color: Colors.white)),
                  Divider(),
                  Expanded(
                      child: Center(
                          child: ClipOval(
                              child:Container(
                                  padding: EdgeInsets.all(4.0),
                                  color: globals.foregroundColor,
                                  child:IconButton(
                                      hoverColor: Colors.white ,
                                      highlightColor:Colors.white ,
                                      focusColor: Colors.white,
                                      color: Colors.white,

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

                                                          await tag.list.delete(tag);

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
                  Text('weight: ${tag.weight.toString()}', style: TextStyle(color: Colors.white)),
                  Text(tag.created_at.toIso8601String()),
                  Text(tag.total_points.toString())
                ]
            )
        )
    );
  }
}