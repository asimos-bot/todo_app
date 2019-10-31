import 'package:flutter/material.dart';
import 'Controller.dart';

class TextForm extends StatelessWidget {

  Controller controller;

  TextForm(this.controller);

  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget> [
        TextFormField(

          autofocus: true,
          decoration: InputDecoration(filled: true, fillColor: Colors.white,hintText: "Title"),
          style: TextStyle(color: Colors.black),
          controller: controller.titleController,
        ),
        Divider(),
        TextFormField(
            decoration: InputDecoration(filled: true, fillColor: Colors.white,hintText: "Description"),
            style: TextStyle(color: Colors.black),
            controller: controller.descriptionController
        )
      ]
    );
  }
}