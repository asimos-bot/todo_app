import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'Tag.dart';
import 'TagList.dart';
import 'package:flutter/services.dart';

class TagBuilder extends StatefulWidget {

  final TagList list;

  TagBuilder(this.list);

  @override
  createState() => TagBuilderState(list);
}

class TagBuilderState extends State<TagBuilder> {

  TagList list;

  Color pickerColor = Color(0xff443a49);
  Color choosenColor = Color(0xffffffff);

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
                  TextFormField(

                    decoration: InputDecoration(filled: true, fillColor: Colors.white,hintText: "Title"),
                    style: TextStyle(color: Colors.black),
                    controller: list.titleController,
                  ),
                  Divider(),
                  TextFormField(
                      decoration: InputDecoration(filled: true, fillColor: Colors.white,hintText: "Description"),
                      style: TextStyle(color: Colors.black),
                      controller: list.descriptionController
                  ),
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
                  Slider(
                      activeColor: Colors.indigoAccent,
                      min: -50,
                      max: 50,
                      onChanged: (newWeight) {
                        setState(() {
                          currentSliderValue = newWeight;
                          list.weightController.value = new TextEditingController.fromValue(new TextEditingValue(text: newWeight.round().toString())).value;
                        });
                      },
                      value: currentSliderValue
                  ),
                  Divider(),
                  TextFormField(
                      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(filled: true, fillColor: Colors.white),
                      style: TextStyle(color: Colors.black),
                      controller: list.weightController
                  )
                ]
              )
            )
        )
    );
  }
}