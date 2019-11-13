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
        Padding(
          padding: EdgeInsets.all(10.0),
          child: TextField(
            autofocus: true,
            decoration: InputDecoration(
                filled: true,
                fillColor: globals.secondaryForegroundColor,
                hintText: "Title",
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30)
                  )
                )
            ),
            style: TextStyle(
                color: Colors.black,
            ),
            controller: controller.titleController,
            maxLength: 40
          )
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: TextField(
            decoration: InputDecoration(
                filled: true,
                fillColor: globals.secondaryForegroundColor,
                hintText: "Description",
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(30)
                  )
                )
            ),
            style: TextStyle(color: Colors.black),
            controller: controller.descriptionController,
            maxLength: 255,
            maxLines: null
          )
        )
      ]
    );
  }
}