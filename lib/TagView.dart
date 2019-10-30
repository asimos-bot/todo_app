import 'package:flutter/material.dart';
import 'TagEdit.dart';
import 'Tag.dart';

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
            title: Text("Tag description"),
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
                                  color: Color(0xFF6A1B9A),
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
                                                        onPressed: () {

                                                          tag.list.delete(tag);

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
                  )
                ]
            )
        )
    );
  }
}