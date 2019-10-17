import 'package:flutter/material.dart';
import 'Tag.dart';

class TagBuilder {

  BuildContext context;
  List<Tag> list;

  //disposed when tag is deleted
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  TagBuilder(this.context, this.list);

  void createTag(){

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

                            var tag = Tag(context, list);

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
                              controller: titleController
                          ),
                          Divider(),
                          TextFormField(
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