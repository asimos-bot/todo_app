import 'package:flutter/material.dart';

class Tag {

  Colors color;
  double weight;
  String title="";
  String description="";

  //global list with all the tags
  List<Tag> list;

  //dispose when task is deleted
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  Tag(this.list);

  Widget toWidget(context){

    return Card(
      child:ListTile(
        title: Text(title),
        subtitle: Text(description)
      )
    );
  }

  void tagEdit(context){

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