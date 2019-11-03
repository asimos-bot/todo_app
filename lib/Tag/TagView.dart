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
                  title: Center(child:
                    Text(
                        tag.title,
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.center
                    )
                  ),
                  actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.search, color: globals.secondaryForegorundColor)
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
              body: SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                      children: <Widget>[

                        Text(
                            tag.title,
                            textScaleFactor: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: globals.secondaryForegorundColor
                            )
                        ),
                        Divider(),
                        Text(
                            tag.description,
                            style: TextStyle(color: globals.secondaryForegorundColor.withOpacity(0.8))
                        ),
                        Divider(),
                        tag.toSearchWidget(context, null),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget> [
                            Expanded(
                              child: Card(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget> [
                                    Text(
                                        'Weight',
                                        textScaleFactor: 1.5,
                                        style: TextStyle(color: globals.backgroundColor)
                                    ),
                                    Text(
                                        '${tag.weight.toString()}',
                                        textScaleFactor: 1.5,
                                        style: TextStyle(color: globals.backgroundColor)
                                    )
                                  ]
                                )
                              )
                            ),
                            Expanded(
                              child: Card(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget> [
                                      Text(
                                          'Points',
                                          textScaleFactor: 1.5,
                                          style: TextStyle(color: globals.backgroundColor)
                                      ),
                                      Text(
                                          '${tag.total_points.toString()}',
                                          textScaleFactor: 1.5,
                                          style: TextStyle(color: globals.backgroundColor)
                                      )
                                    ]
                                )
                              )
                            )
                          ]
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