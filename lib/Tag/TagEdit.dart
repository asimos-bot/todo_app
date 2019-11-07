import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:todo_yourself/Tag/Tag.dart';
import '../FormWidgets/WeightSlider.dart';
import '../FormWidgets/TextForm.dart';
import 'package:todo_yourself/globals.dart' as globals;

class TagEdit extends StatefulWidget {

  final Tag tag;

  TagEdit(this.tag);

  @override
  createState() => TagEditState(tag);
}

class TagEditState extends State<TagEdit> {

  Tag tag;

  Color pickerColor;

  TagEditState(this.tag){
    pickerColor = tag.color;
  }

  void changeColor(Color color){

    setState(() => pickerColor = color);
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
        appBar: AppBar(
            title: Text(tag.title, overflow: TextOverflow.ellipsis),
            actions: <Widget>[
              IconButton(

                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              title: Text('Are you sure you want to delete this tag?'),
                              actions: <Widget>[
                                FlatButton(
                                    child: Text('Yes'),
                                    onPressed: () async {

                                      await tag.manager.delete(tag);

                                      setState(() {});

                                      //pop to root
                                      Navigator.popUntil(context, (route) => route.isFirst);
                                    }
                                ),
                                FlatButton(
                                    child: Text('No'),
                                    onPressed: () {

                                      Navigator.pop(context);
                                    }
                                )
                              ]
                          );
                        }
                    );
                  }
              ),
              IconButton(
                  icon: Icon(Icons.done),
                  onPressed: () {

                    tag.title = tag.titleController.text;
                    tag.description = tag.descriptionController.text;
                    tag.weight = int.parse(tag.weightController.text);

                    tag.manager.update(tag);

                    Navigator.pop(context);
                  }
              )
            ]
        ),
        body: Form(
            child: ListView(
                children: <Widget>[
                  TextForm(tag),
                  Divider(),
                  Center(
                    child: RaisedButton(

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
                                      onPressed: () {

                                        tag.color = pickerColor;
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
                    )
                  ),
                  Divider(),
                  WeightSlider(tag, tag.weight.toDouble())
                ]
            )
        )
    );
  }
}