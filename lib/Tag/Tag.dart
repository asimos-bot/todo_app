import 'package:flutter/material.dart';
import 'package:todo_yourself/Tag/TagList.dart';
import 'package:todo_yourself/Tag/TagView.dart';
import '../FormWidgets/Controller.dart';

class Tag extends Controller {

  int id = -1;

  Color color;

  //global list with all the tags
  TagList list;

  Tag(this.list);

  Widget toMenuButtonWidget(context, data){
    return Card(
        child: ListTile(
          leading: CircleAvatar(
              backgroundColor: color,
              child: title.length >= 2 ? Text("${title[0]}${title[1]}") : null
          ),
          onTap: data.triggerMenu,
          title: Text(title),
          subtitle: Text(description, overflow: TextOverflow.ellipsis)
        )
      );
  }

  Widget toSearchWidget(context, onItemTapped){

    return Card(
        child: ListTile(
          leading: CircleAvatar(
              backgroundColor: color,
              child: title.length >= 2 ? Text("${title[0]}${title[1]}") : null
          ),
          onTap: onItemTapped,
          title: Text(title),
          subtitle: Text(description, overflow: TextOverflow.ellipsis)
        )
      );
  }

  Widget toWidget(context){

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: title.length >= 2 ? Text("${title[0]}${title[1]}") : null
        ),
        title: Text(title),
        subtitle: Text(description, overflow: TextOverflow.ellipsis),
        onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => TagView(this)
            )
        )
      )
    );
  }
}