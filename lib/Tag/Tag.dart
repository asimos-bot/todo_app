import 'package:flutter/material.dart';
import 'package:todo_yourself/Tag/TagList.dart';
import 'package:todo_yourself/Tag/TagView.dart';
import '../FormWidgets/Controller.dart';

class Tag extends Controller {

  int id = -1;

  Color color;
  int total_points=0;

  //global list with all the tags
  TagList list;

  Tag(this.list);

  Widget toCircleAvatar(){
    return CircleAvatar(
        backgroundColor: color,
        child: title.length >= 2 ? Text("${title[0]}${title[1]}") : null
    );
  }

  Widget toMenuButtonWidget(context, data){
    return Card(
        child: ListTile(
          leading: toCircleAvatar(),
          onTap: data.triggerMenu,
          title: Text(title),
          subtitle: Text(description, overflow: TextOverflow.fade)
        )
      );
  }

  Widget toSearchWidget(context, onItemTapped){

    return Card(
        child: ListTile(
          leading: toCircleAvatar(),
          onTap: onItemTapped,
          title: Text(title),
          subtitle: Text(description, overflow: TextOverflow.fade)
        )
      );
  }

  Widget toWidget(context){

    return Card(
      child: ListTile(
        leading: toCircleAvatar(),
        title: Text(title),
        subtitle: Text(description, overflow: TextOverflow.fade),
        onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => TagView(this)
            )
        )
      )
    );
  }
}