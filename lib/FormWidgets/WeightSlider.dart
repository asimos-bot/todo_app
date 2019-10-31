import 'package:flutter/material.dart';
import 'Controller.dart';
import 'package:flutter/services.dart';

class WeightSlider extends StatefulWidget {

  final Controller controller;
  final initialSliderValue;

  WeightSlider(this.controller, this.initialSliderValue);

  @override
  createState() => WeightSliderState(controller, initialSliderValue);
}

class WeightSliderState extends State<WeightSlider> {

  Controller controller;

  double currentSliderValue;

  WeightSliderState(this.controller, this.currentSliderValue);

  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        Slider(
            activeColor: Colors.indigoAccent,
            min: -50,
            max: 50,
            onChanged: (newWeight) {
              setState(() {
                currentSliderValue = newWeight;
                controller.weightController.value = new TextEditingController.fromValue(new TextEditingValue(text: newWeight.round().toString())).value;
              });
            },
            value: currentSliderValue
        ),
        Divider(),
        TextFormField(
            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
            decoration: InputDecoration(filled: true, fillColor: Colors.white),
            style: TextStyle(color: Colors.black),
            controller: controller.weightController
        )
      ],
    );
  }
}