import 'package:flutter/material.dart';
import '../Tag/Tag.dart';
import 'package:todo_yourself/Task/TaskManager.dart';
import 'package:todo_yourself/Task/TaskView.dart';
import '../FormWidgets/Controller.dart';
import '../globals.dart' as globals;

enum TaskMode{
  singular,
  habit
}

class Task extends Controller {

  int id=-1;

  Tag tag;

  bool checked=false;

  TaskMode mode=TaskMode.singular; //false=singular, true=habit

  //global list with all the ListEntries
  TaskManager manager;

  //prompt for crating a entry
  Task(this.manager);

  //return this entry in widget form
  //we pass the id to be sure we get the task from database, guaranteed to be updated
  Widget toWidget(Function callback) => TaskWidget(this, callback);

  //turn TaskMode in boolean
  bool taskModeToBool() => mode == TaskMode.habit ? true : false;

  //turn boolean in TaskMode
  void boolToTaskMode(bool value) => mode = value ? TaskMode.habit : TaskMode.singular;

  //turn taskMode into integer
  int taskModeToInt() => mode == TaskMode.habit ? 1 : 0;

  //turn integer into taskMode
  void intToTaskMode(int value) => mode = value == 1 ? TaskMode.habit : TaskMode.singular;
}

class TaskWidget extends StatefulWidget {

  final Task task;
  final Function callback;

  TaskWidget(this.task, this.callback);

  @override
  createState() => TaskWidgetState(task, callback);
}

class TaskWidgetState extends State<TaskWidget> {

  Task task;
  Function callback;

  TaskWidgetState(this.task, this.callback);

  @override
  Widget build(BuildContext context) {

    return Card(
        child: ListTile(
            leading: task.tag != null ? task.tag.toCircleAvatar() : null,
            title: Text(
                task.title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: task.checked ? TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.black.withOpacity(0.4)
                ) : null
            ),
            subtitle: Text(
                task.description,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
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
            trailing: task.mode == TaskMode.habit ?
              //if task is in habit mode
              IconButton(
                icon: Icon(Icons.add),
                color: task.tag != null ? task.tag.color : globals.foregroundColor,
                onPressed: () async {
                  await task.tag.manager.changeTotalPoints(
                      task.tag,
                      task.weight
                  );

                  if(callback != null) callback();
                },
              )

              //if task is in singular mode
            : Checkbox(
              value: task.checked,
              checkColor: task.tag != null ? task.tag.color : globals.foregroundColor,
              activeColor: globals.secondaryForegroundColor,
              onChanged: (bool value) async {

                if( task.tag != null ){

                  await task.tag.manager.changeTotalPoints(
                      task.tag,
                      task.checked ? -task.weight : task.weight
                  );
                }

                setState(() => task.checked = value);

                //update checked field in database
                await task.manager.updateChecked(task);

                if(callback!=null) callback();
              },
            )
        )
    );
  }
}