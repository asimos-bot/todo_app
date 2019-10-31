import 'package:flutter/material.dart';

abstract class Controller {

  String title="";
  String description="";

  int weight=1;
  DateTime created_at;

  final titleController = TextEditingController(text: "");
  final descriptionController = TextEditingController(text: "");
  final weightController = TextEditingController(text: "");

  void updateTextControllers(){
    titleController.value = new TextEditingController.fromValue(new TextEditingValue(text: title)).value;
    descriptionController.value = new TextEditingController.fromValue(new TextEditingValue(text: description)).value;
    weightController.value = new TextEditingController.fromValue(new TextEditingValue(text: weight.toString())).value;
  }

  void clearTextControllers(){
    titleController.value = new TextEditingController.fromValue(new TextEditingValue(text: "")).value;
    descriptionController.value = new TextEditingController.fromValue(new TextEditingValue(text: "")).value;
    weightController.value = new TextEditingController.fromValue(new TextEditingValue(text: "1")).value;
  }

  void dispose(){
    titleController.dispose();
    descriptionController.dispose();
    weightController.dispose();
  }
}