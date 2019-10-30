import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'Tag.dart';
import 'package:flutter/services.dart';

class TagEdit extends StatefulWidget {

  final Tag tag;

  TagEdit(this.tag);

  @override
  createState() => TagEditState(tag);
}

class TagEditState extends State<TagEdit> {

  Tag tag;

  Color pickerColor = Color(0xff443a49);

  double currentSliderValue;

  TagEditState(this.tag){
    currentSliderValue = tag.weight.toDouble();
  }

  void changeColor(Color color){

    setState(() => pickerColor = color);
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
        appBar: AppBar(
            title: Text('Tag Edit'),
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
            child: Column(
                children: <Widget>[
                  TextFormField(

                    decoration: InputDecoration(filled: true, fillColor: Colors.white,hintText: "Title"),
                    style: TextStyle(color: Colors.black),
                    controller: tag.titleController,
                  ),
                  Divider(),
                  TextFormField(

                      decoration: InputDecoration(filled: true, fillColor: Colors.white,hintText: "Description"),
                      style: TextStyle(color: Colors.black),
                      controller: tag.descriptionController
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
                  Slider(
                    activeColor: Colors.indigoAccent,
                    min: -50,
                    max: 50,
                    onChanged: (newWeight) {
                      setState(() {
                        currentSliderValue = newWeight;
                        tag.weightController.value = new TextEditingController.fromValue(new TextEditingValue(text: newWeight.round().toString())).value;
                      });
                    },
                    value: currentSliderValue
                  ),
                  Divider(),
                  TextFormField(
                    inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(filled: true, fillColor: Colors.white),
                    style: TextStyle(color: Colors.black),
                    controller: tag.weightController
                  )
                ]
            )
        )
    );
  }
}