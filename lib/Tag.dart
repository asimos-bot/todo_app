import 'package:flutter/material.dart';

class Tag {

  Colors color;
  double weight;
  String title="";
  String description="";

  BuildContext context;

  //global list with all the tags
  List<Tag> list;

  //dispose when task is deleted
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  Tag(this.context, this.list);

  Widget toWidget(){

    return Card(
      child:ListTile(
        title: Text(title),
        subtitle: Text(description)
      )
    );
  }

  void tagEdit(){

    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => Scaffold(
                appBar: AppBar(
                    title: Text('Edit Tag'),
                    actions: <Widget>[
                      IconButton(
                          icon: Icon(Icons.done),
                          onPressed: (){

                            title = titleController.text;
                            description = descriptionController.text;

                            Navigator.pop(context);
                          }
                      )
                    ]
                ),
                body: Form(
                    child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: titleController,
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