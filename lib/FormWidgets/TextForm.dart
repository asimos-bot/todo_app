import 'package:flutter/material.dart';
import 'Controller.dart';
import '../globals.dart' as globals;

class TextForm extends StatelessWidget {

  final Controller controller;

  TextForm(this.controller);

  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget> [
        TextField(

          autofocus: true,
          decoration: InputDecoration(filled: true, fillColor: globals.secondaryForegorundColor,hintText: "Title"),
          style: TextStyle(color: Colors.black),
          controller: controller.titleController,
        ),
        Divider(),
        TextField(
            decoration: InputDecoration(filled: true, fillColor: globals.secondaryForegorundColor,hintText: "Description"),
            style: TextStyle(color: Colors.black),
            controller: controller.descriptionController
        )
      ]
    );
  }
}