import 'package:flutter/material.dart';
import 'Controller.dart';
import 'package:flutter/services.dart';
import '../globals.dart' as globals;

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
            activeColor: globals.secondaryForegroundColor,
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
        Container(
          width: 60,
          child: TextField(
              enabled: false,
              textAlign: TextAlign.center,
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                filled: true,
                fillColor: globals.secondaryForegroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30)
                  )
                )
              ),
              style: TextStyle(color: Colors.black),
              controller: controller.weightController
          )
        )
      ],
    );
  }
}