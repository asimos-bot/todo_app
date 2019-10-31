import 'package:flutter/material.dart';
import 'TagList.dart';
import 'TagView.dart';

class Tag {

  int id = -1;

  Color color;
  int weight=1;
  String title="";
  String description="";

  //global list with all the tags
  TagList list;

  //dispose when task is deleted
  final titleController = TextEditingController(text: "");
  final descriptionController = TextEditingController(text: "");
  final weightController = TextEditingController(text: "");

  Tag(this.list);

  Widget toSearchWidget(context, onItemTapped){

    return ListTile(
      onTap: onItemTapped,
      title: Text(title),
      subtitle: Text(description, overflow: TextOverflow.ellipsis)
    );
  }

  Widget toWidget(context){

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: title.length >= 2 ? Text("${title[0]}${title[1]}") : null
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
    weightController.value = new TextEditingController.fromValue(new TextEditingValue(text: weight.toString())).value;
  }

  void dispose(){
    titleController.dispose();
    descriptionController.dispose();
    weightController.dispose();
  }
}