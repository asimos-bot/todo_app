import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:todo_yourself/Tag/Tag.dart';
import 'package:todo_yourself/Tag/TagManager.dart';
import '../FormWidgets/FormSlider.dart';
import '../FormWidgets/TextForm.dart';
import '../globals.dart' as globals;

class TagBuilder extends StatefulWidget {

  final TagManager list;

  TagBuilder(this.list);

  @override
  createState() => TagBuilderState(list);
}

class TagBuilderState extends State<TagBuilder> {

  TagManager list;

  Color pickerColor = Color(0xff443a49);
  Color choosenColor = globals.backgroundColor;

  double currentSliderValue=1;

  TagBuilderState(this.list);

  void changeColor(Color color){

    setState(() => pickerColor = color);
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
        appBar: AppBar(
            title: Text('Create Tag'),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.done),
                  onPressed: () {

                    var tag = Tag(list);

                    tag.title = list.titleController.text;
                    tag.description = list.descriptionController.text;
                    tag.color = choosenColor;
                    tag.weight = int.parse(list.weightController.text);

                    list.add(tag);

                    Navigator.pop(context);
                  }
              )
            ]
        ),
        body: Form(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextForm(list),
                  Divider(),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: BorderSide(
                          color: pickerColor,
                          width: 4
                      )
                    ),
                    color: globals.secondaryForegroundColor,
                    child: Text('Choose Color'),
                    onPressed: (){
                      showDialog(
                        context: context,
                        // ignore: deprecated_member_use
                        child: AlertDialog(
                          title: const Text('Pick a color!'),
                          content: SingleChildScrollView(
                            child: ColorPicker(
                              pickerColor: pickerColor,
                              onColorChanged: changeColor,
                              enableLabel: false,
                              pickerAreaHeightPercent: 0.8,
                            )
                          ),
                          actions: <Widget> [
                            FlatButton(
                              child: Text('Got it!'),
                              onPressed: (){

                                choosenColor = pickerColor;
                                Navigator.of(context).pop();
                              }
                            ),
                            FlatButton(
                              child: Text('Cancel'),
                              onPressed: () => Navigator.of(context).pop()
                            )
                          ]
                        )
                      );
                    }
                  ),
                  Divider(),
                  FormSlider(list, 1.0)
                ]
              )
            )
        )
    );
  }
}