import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'Tag.dart';
import 'TagList.dart';

class TagBuilder extends StatefulWidget {

  final TagList list;

  TagBuilder(this.list);

  @override
  createState() => TagBuilderState(list);
}

class TagBuilderState extends State<TagBuilder> {

  TagList list;

  TagBuilderState(this.list);

  @override
  Widget build(BuildContext context){

    //disposed when task is deleted
    final titleController = TextEditingController(text: "");
    final descriptionController = TextEditingController(text: "");

    return Scaffold(
        appBar: AppBar(
            title: Text('Create Task'),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.done),
                  onPressed: (){

                    var tag = Tag(list);

                    tag.title = titleController.text;
                    tag.description = descriptionController.text;

                    list.add(tag);

                    Navigator.pop(context);
                  }
              )
            ]
        ),
        body: Form(
            child: Column(
                children: <Widget>[
                  TextFormField(

                    decoration: InputDecoration(filled: true, fillColor: Colors.white,hintText: "Title"),
                    style: TextStyle(color: Colors.black),
                    controller: titleController,
                  ),
                  Divider(),
                  TextFormField(
                      decoration: InputDecoration(filled: true, fillColor: Colors.white,hintText: "Description"),
                      style: TextStyle(color: Colors.black),
                      controller: descriptionController
                  )
                ]
            )
        )
    );
  }
}