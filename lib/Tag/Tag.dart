import 'package:flutter/material.dart';
import 'package:todo_yourself/Tag/TagManager.dart';
import 'package:todo_yourself/Tag/TagView.dart';
import '../FormWidgets/Controller.dart';

class Tag extends Controller {

  int id = -1;

  Color color;
  int total_points=0;
  int number_of_point_entries=0;

  //global list with all the tags
  TagManager manager;

  Tag(this.manager);

  Widget toCircleAvatar(){
    return CircleAvatar(
        backgroundColor: color,
        child: title.length >= 2 ? Text("${title[0]}${title[1]}") : null
    );
  }

  Widget toSearchWidget(context, onItemTapped){

    return Card(
        child: ListTile(
          leading: toCircleAvatar(),
          onTap: onItemTapped,
          title: Text(
            title,
            overflow: TextOverflow.ellipsis,
            maxLines: 1
          ),
          subtitle: Text(
            description,
            overflow: TextOverflow.ellipsis,
            maxLines: 1
          )
        )
      );
  }

  Widget toWidget(context){

    return Card(
      child: ListTile(
        leading: toCircleAvatar(),
        title: Text(
          title,
          overflow: TextOverflow.ellipsis,
          maxLines:1
        ),
        subtitle: Text(
          description,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => TagView(id, manager)
            )
        )
      )
    );
  }
}