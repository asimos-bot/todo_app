  import 'package:flutter/material.dart';

class ListEntry {

  String _text;
  int index;

  ListEntry(this._text, this.index);

  Widget toListTile(){

    return ListTile(
      title: new Text(_text, overflow: TextOverflow.ellipsis)
    );
  }

  Widget toWidget(){

    return Draggable(

        //what is there when we are not dragging
        maxSimultaneousDrags: 1,
        child: toListTile(),

        //what we leave behind
        childWhenDragging: Opacity(
          opacity: 0.5,
          child: toListTile(),
        ),

        //what we drag
        feedback: Material(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 200, maxHeight: 50),
            child: toListTile()
          ),
          elevation: 4.0,
        )
      );
  }
}