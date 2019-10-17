import 'package:flutter/material.dart';

class Tag {

  Colors color;
  double weight;
  String _title="";
  String _description="";

  BuildContext context;

  //global list with all the tags
  List<Tag> list;

  //dispose when task is deleted
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  Tag(this.context, this.list){

    TagEdit('Create Tag');
  }

  Widget toWidget(){

    return Card(
      child:ListTile(
        title: Text(_title),
        subtitle: Text(_description)
      )
    );
  }

  void TagEdit(String appBarTitle){

    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => Scaffold(
                appBar: AppBar(
                    title: Text(appBarTitle),
                    actions: <Widget>[
                      IconButton(
                          icon: Icon(Icons.done),
                          onPressed: (){

                            _title = titleController.text;
                            _description = descriptionController.text;

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