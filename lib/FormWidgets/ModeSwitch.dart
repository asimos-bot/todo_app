import 'package:flutter/material.dart';
import '../globals.dart' as globals;

class SwitchValueWrapper {

  bool value;

  SwitchValueWrapper(this.value);
}

class ModeSwitch extends StatefulWidget {

  final SwitchValueWrapper value;

  ModeSwitch(this.value);

  @override
  createState() => ModeSwitchState(value);
}

class ModeSwitchState extends State<ModeSwitch> {

  SwitchValueWrapper tmpMode;

  ModeSwitchState(this.tmpMode);

  @override
  Widget build(BuildContext context) {

    return Padding(
        padding: EdgeInsets.all(10),
        child: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget> [
              SizedBox(
                width: 55,
                child: Text(
                    tmpMode.value ? '' : 'singular',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: globals.backgroundColor
                    )
                )
              ),
              Switch(
                inactiveTrackColor: globals.primaryForegroundColor,
                activeTrackColor: globals.primaryForegroundColor,
                activeColor: Colors.white,
                value: tmpMode.value,
                onChanged: (bool newValue) async {

                  setState(() => tmpMode.value = newValue);
                },
              ),
              SizedBox(
                width: 55,
                child: Text(
                    tmpMode.value ? 'habit' : '',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: globals.backgroundColor
                    )
                )
              )
            ]
        )
      )
    );
  }
}