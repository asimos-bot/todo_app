import 'package:flutter/material.dart';
import 'Tag.dart';

class TagBuilder {

  List<Tag> list;

  //disposed when tag is deleted
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  TagBuilder(this.list);

  void createTag(context){
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => Scaffold(
                appBar: AppBar(
                    title: Text('Create Tag'),
                    actions: <Widget>[
                      IconButton(
                          icon: Icon(Icons.done),
                          onPressed: (){

                            var title = titleController.text;
                            var _description = descriptionController.text;

                            var tag = Tag(list);

                            tag.title = title;
                            tag.description = _description;

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
            )
        )
    );
  }
}