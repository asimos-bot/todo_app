import 'package:flutter/material.dart';
import 'TagList.dart';
import 'TagView.dart';

class Tag {

  int id = -1;

  Color color;
  double weight;
  String title="";
  String description="";

  //global list with all the tags
  TagList list;

  //dispose when task is deleted
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  Tag(this.list);

  Widget toWidget(context){

    return Card(
      child: ListTile(
        leading: CircleAvatar(
            backgroundColor: color
        ),
        title: Text(title),
        subtitle: Text(description, overflow: TextOverflow.ellipsis),
        onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => TagView(this)
            )
        )
      )
    );
  }

  void updateTextControllers(){
    titleController.value = new TextEditingController.fromValue(new TextEditingValue(text: title)).value;
    descriptionController.value = new TextEditingController.fromValue(new TextEditingValue(text: description)).value;
  }

  void dispose(){
    titleController.dispose();
    descriptionController.dispose();
  }
}