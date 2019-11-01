import 'package:flutter/material.dart';
import '../Tag/Tag.dart';
import 'package:todo_yourself/Task/TaskList.dart';
import 'package:todo_yourself/Task/TaskView.dart';
import '../FormWidgets/Controller.dart';
import '../globals.dart' as globals;

class Task extends Controller {

  int id=-1;

  Tag tag=null;

  bool checked=false;

  //global list with all the ListEntries
  TaskList list;

  //prompt for crating a entry
  Task(this.list);

  //return this entry in widget form
  Widget toWidget() => TaskWidget(this);
}

class TaskWidget extends StatefulWidget {

  final Task task;

  TaskWidget(this.task);

  @override
  createState() => TaskWidgetState(task);
}

class TaskWidgetState extends State<TaskWidget> {

  Task task;

  TaskWidgetState(this.task);

  @override
  Widget build(BuildContext context) {

    return Card(
        child: ListTile(
            leading: task.tag != null ? task.tag.toCircleAvatar() : null,
            title: Text(
                task.title,
                overflow: TextOverflow.fade,
                style: task.checked ? TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.black.withOpacity(0.4)
                ) : null
            ),
            subtitle: Text(
                task.description,
                overflow: TextOverflow.fade,
                style: task.checked ? TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.black.withOpacity(0.4)
                ) : null
            ),
            onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => TaskView(task)
                )
            ),
            trailing: Checkbox(
              value: task.checked,
              checkColor: task.tag != null ? task.tag.color : globals.foregroundColor,
              activeColor: Colors.white,
              onChanged: (bool value) async {

                if( task.tag != null ){

                  await task.tag.list.changeTotalPoints(
                      task.tag,
                      task.checked ? -task.weight : task.weight
                  );
                }

                setState(() => task.checked = value);

                //update checked field in database
                await task.list.updateChecked(task);
              },
            )
        )
    );
  }
}