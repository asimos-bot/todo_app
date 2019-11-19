import 'package:todo_yourself/Task/Task.dart';
import 'package:sqflite/sqflite.dart';
import '../Tag/TagManager.dart';
import '../FormWidgets/Controller.dart';

//manage database and list at the same time
class TaskManager extends Controller {

  TagManager tagManager;
  int length=-1;

  int highestPriority=0;

  Future<Database> db;

  TaskManager(this.db);

  Future<List<Task>> list() async {

    List<Task> list = [];

    List<Map> queryResult = await (await db).rawQuery('SELECT * FROM tasks ORDER BY priority DESC');

    for(int i=0; i < queryResult.length; i++){

      Map taskMap = queryResult[i];
      Task task = Task(this);

      task.title = taskMap['title'];
      task.description = taskMap['description'];
      task.id = taskMap['id'];
      task.tag = taskMap['tag'] != null ? await tagManager.get(taskMap['tag']) : null;
      task.weight = taskMap['weight'];
      task.created_at = DateTime.parse(taskMap['created_at']);
      task.checked = taskMap['checked'] == 1 ? true : false;
      task.intToTaskMode(taskMap['mode']);
      task.priority = taskMap['priority'];

      if( task.priority > highestPriority ) highestPriority = task.priority;

      list.add(task);
    }

    length = list.length;

    list.sort(( greater, smaller ) => greater.priority < smaller.priority ? 1 : -1);

    return list;
  }

  Future<Task> get(int id) async {

    List<Map> query = await (await db).query(
        'tasks',
        columns: [
          'id',
          'title',
          'description',
          'tag',
          'weight',
          'created_at',
          'checked',
          'mode',
          'priority'
        ], where: 'id = ?', whereArgs: [id]);

    if(query.length == 0) return null;

    Map taskMap = query[0];

    Task task = Task(this);

    task.id = taskMap['id'];
    task.title = taskMap['title'];
    task.description = taskMap['description'];
    task.tag = taskMap['tag'] != null ? await tagManager.get(taskMap['tag']) : null;
    task.weight = taskMap['weight'];
    task.created_at = DateTime.parse(taskMap['created_at']);
    task.checked = taskMap['checked'] == 1 ? true : false;
    task.intToTaskMode(taskMap['mode']);
    task.priority = taskMap['priority'];

    return task;
  }

  Future<void> add(Task task) async {

    await (await db).insert('tasks', {
      'title': task.title,
      'description': task.description,
      'tag': task.tag!=null ? task.tag.id : null,
      'weight': task.weight,
      'created_at': DateTime.now().toIso8601String(),
      'checked': task.checked,
      'mode': task.taskModeToInt(),
      'priority': ++highestPriority
    });
  }

  Future<void> delete(Task task) async {

      await (await db).delete('tasks', where: 'id = ?', whereArgs: [task.id]);
  }

  //update database
  Future<void> updateAt(int index, List<Task> list) async{

    await (await db).update('tasks', {
      'title': list[index].title,
      'description': list[index].description,
      'tag': list[index].tag != null ? list[index].tag.id : null,
      'weight': list[index].weight,
      'checked': list[index].checked,
      'mode': list[index].taskModeToInt(),
      'priority': list[index]
    }, where: 'id = ?', whereArgs: [list[index].id]);
  }

  Future<void> update(Task task) async {

    await (await db).update('tasks', {
      'title': task.title,
      'description': task.description,
      'tag': task.tag != null ? task.tag.id : null,
      'weight': task.weight,
      'checked': task.checked,
      'mode': task.taskModeToInt(),
      'priority': task.priority
    }, where: 'id = ?', whereArgs: [task.id]);
  }

  Future<void> updateChecked(Task task) async {

    await (await db).update('tasks',{
      'checked': task.checked
    }, where: 'id = ?', whereArgs: [task.id]);
  }

  Future<void> updateMode(Task task) async {

    await (await db).update('tasks',{
      'mode': task.taskModeToInt()
    }, where: 'id = ?', whereArgs: [task.id]);
  }

  Future<void> updatePriority(List<Task> tasks, int before, int after) async {

    if(before == after) return;

    int afterPriority = tasks[after].priority;

    Batch batch = (await db).batch();

    //remove
    if( before < after ){

      for(int i = after; i > before; i--){

        tasks[i].priority = tasks[i-1].priority;

        batch.update('tasks',{
          'priority': tasks[i].priority
        }, where: 'id = ?', whereArgs: [tasks[i].id]);
      }

    }else{

      for(int i = after; i < before; i++){

        tasks[i].priority = tasks[i+1].priority;

        batch.update('tasks',{
          'priority': tasks[i].priority
        }, where: 'id = ?', whereArgs: [tasks[i].id]);
      }
    }

    tasks[before].priority = afterPriority;

    batch.update('tasks',{
      'priority': tasks[before].priority
    }, where: 'id = ?', whereArgs: [tasks[before].id]);

    await batch.commit(noResult: true);

    tasks.insert(after, tasks.removeAt(before));
  }

  Future<List<Task>> query(String queryStr, int tag) async {

    List<Task> list = [];

    String searchStr = tag == null ?
    'SELECT * FROM tasks WHERE title LIKE \'%$queryStr%\' ORDER BY priority DESC' :
    'SELECT * FROM tasks WHERE title LIKE \'%$queryStr%\' AND tag = ${tag.toString()} ORDER BY priority DESC';

    List<Map> queryResult = await (await db).rawQuery(searchStr);

    for(int i=0; i < queryResult.length; i++){

      Map taskMap = queryResult[i];
      Task task = Task(this);

      task.title = taskMap['title'];
      task.description = taskMap['description'];
      task.id = taskMap['id'];
      task.tag = taskMap['tag'] != null ? await tagManager.get(taskMap['tag']) : null;
      task.weight = taskMap['weight'];
      task.created_at = DateTime.parse(taskMap['created_at']);
      task.checked = taskMap['checked'] == 1 ? true : false;
      task.intToTaskMode(taskMap['mode']);
      task.priority = taskMap['priority'];

      if( task.priority > highestPriority ) highestPriority = task.priority;

      list.add(task);
    }

    length = list.length;

    list.sort(( greater, smaller ) => greater.priority < smaller.priority ? 1 : -1);

    return list;
  }
}