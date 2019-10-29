import 'package:flutter/material.dart';
import 'Task.dart';
import 'Tag.dart';
import 'TaskList.dart';

class TagEdit extends StatefulWidget {

  final Tag tag;

  TagEdit(this.tag);

  @override
  createState() => TagEditState(tag);
}

class TagEditState extends State<TagEdit> {

  Tag tag;

  TagEditState(this.tag);

  @override
  Widget build(BuildContext context){

    tag.titleController.value = new TextEditingController.fromValue(new TextEditingValue(text: tag.title)).value;
    tag.descriptionController.value = new TextEditingController.fromValue(new TextEditingValue(text: tag.description)).value;

    return Scaffold(
        appBar: AppBar(
            title: Text('Tag Edit'),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.done),
                  onPressed: (){

                    tag.title = tag.titleController.text;
                    tag.description = tag.descriptionController.text;

                    tag.list.update(tag);

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
                    controller: tag.titleController,
                  ),
                  Divider(),
                  TextFormField(
                      decoration: InputDecoration(filled: true, fillColor: Colors.white,hintText: "Description"),
                      style: TextStyle(color: Colors.black),
                      controller: tag.descriptionController
                  )
                ]
            )
        )
    );
  }
}