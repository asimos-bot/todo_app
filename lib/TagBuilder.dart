import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'Tag.dart';
import 'TagList.dart';

class TagBuilder {

  TagList list;

  //disposed when tag is deleted
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  TagBuilder(this.list);

  void createTag(context){

    //inital value in the text fields
    titleController.value = new TextEditingController.fromValue(new TextEditingValue(text: "")).value;
    descriptionController.value = new TextEditingController.fromValue(new TextEditingValue(text: "")).value;

    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => Scaffold(
                appBar: AppBar(
                    title: Text('Create Tag'),
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
                          //title and secription of the tag
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
                          ),
                          Divider(),
                        ]
                    )
                )
            )
        )
    );
  }
}