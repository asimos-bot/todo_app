import 'package:flutter/material.dart';

class ListEntry {

  String _text;
  final int index;

  ListEntry(this._text, this.index);

  Widget toWidget(){

    return new ListTile(
      title: new Text(_text)
    );
  }
}
