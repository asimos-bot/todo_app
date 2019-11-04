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

    return Row(
        children: <Widget> [
          Switch(
            value: tmpMode.value,
            onChanged: (bool newValue) async {

              setState(() => tmpMode.value = newValue);
            },
          ),
          Text(tmpMode.value ? 'habit' : 'singular', style: TextStyle(color: globals.secondaryForegroundColor))
        ]
    );
  }
}