import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:todo_yourself/Tag/Tag.dart';
import '../FormWidgets/WeightSlider.dart';
import '../FormWidgets/TextForm.dart';

class TagEdit extends StatefulWidget {

  final Tag tag;

  TagEdit(this.tag);

  @override
  createState() => TagEditState(tag);
}

class TagEditState extends State<TagEdit> {

  Tag tag;

  Color pickerColor = Color(0xff443a49);

  TagEditState(this.tag);

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
                  icon: Icon(Icons.done),
                  onPressed: () {

                    tag.title = tag.titleController.text;
                    tag.description = tag.descriptionController.text;
                    tag.weight = int.parse(tag.weightController.text);

                    tag.list.update(tag);

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
                  RaisedButton(

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
                  ),
                  Divider(),
                  WeightSlider(tag, tag.weight.toDouble())
                ]
            )
        )
    );
  }
}