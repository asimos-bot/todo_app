import 'package:flutter/material.dart';
import 'package:todo_yourself/Tag/Tag.dart';
import 'package:sqflite/sqflite.dart';
import '../FormWidgets/Controller.dart';
import '../Task/TaskManager.dart';
import '../Task/Task.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:todo_yourself/globals.dart' as globals;

//manage database and list at the same time
class TagManager extends Controller {

  TaskManager taskManager;

  Future<Database> db;
  int length=-1;
  int highestPriority=0;

  TagManager(this.db);

  Future<List<Tag>> list() async {

    List<Tag> list = [];

    List<Map> queryResult = await (await db).rawQuery('SELECT * FROM tags ORDER BY priority DESC');

    for(int i=0; i < queryResult.length; i++){

      Map tagMap = queryResult[i];
      Tag tag = Tag(this);

      tag.id = tagMap['id'];
      tag.title = tagMap['title'];
      tag.description = tagMap['description'];
      tag.weight = tagMap['weight'];
      tag.color = Color(tagMap['color']);
      tag.created_at = DateTime.parse(tagMap['created_at']);
      tag.total_points = tagMap['total_points'];
      tag.priority = tagMap['priority'];
      tag.number_of_point_entries = tagMap['number_of_point_entries'];

      if( tag.priority > highestPriority ) highestPriority = tag.priority;

      list.add(tag);
    }

    length = list.length;

    list.sort(( greater, smaller ) => greater.priority < smaller.priority ? 1 : -1);

    return list;
  }

  Future<Tag> get(int id) async {

    List<Map> query = await (await db).query(
        'tags',
        columns: [
          'id',
          'title',
          'description',
          'weight',
          'color',
          'created_at',
          'total_points',
          'priority',
          'number_of_point_entries'
        ], where: 'id = ?', whereArgs: [id]);

    if(query.length == 0) return null;

    Map tagMap = query[0];

    Tag tag = Tag(this);

    tag.id = tagMap['id'];
    tag.title = tagMap['title'];
    tag.description = tagMap['description'];
    tag.weight = tagMap['weight'];
    tag.color = Color(tagMap['color']);
    tag.created_at = DateTime.parse(tagMap['created_at']);
    tag.total_points = tagMap['total_points'];
    tag.priority = tagMap['priority'];
    tag.number_of_point_entries = tagMap['number_of_point_entries'];

    return tag;
  }

  Future<void> add(Tag tag) async {

    //put this task in highest priority


    await (await db).insert('tags', {
      'title': tag.title,
      'description': tag.description,
      'color': tag.color.value,
      'weight': tag.weight,
      'created_at': DateTime.now().toIso8601String(),
      'total_points': tag.total_points,
      'priority': ++highestPriority,
      'number_of_point_entries': tag.number_of_point_entries
    });
  }

  Future<void> delete(Tag tag) async {

    //update tasks which reference to this tag
    await (await db).update('tasks', {
      'tag': null
    }, where: 'tag = ?', whereArgs: [tag.id]);

    //delete points which reference to this tag
    await (await db).delete('points', where: 'tag = ?', whereArgs: [tag.id]);

    await (await db).delete('tags', where: 'id = ?', whereArgs: [tag.id]);
  }

  Future<void> update(Tag tag) async {

    await (await db).update('tags', {
      'title': tag.title,
      'description': tag.description,
      'color': tag.color.value,
      'weight': tag.weight,
      'total_points': tag.total_points,
      'priority': tag.priority,
      'number_of_point_entries': tag.number_of_point_entries
    }, where: 'id = ?', whereArgs: [tag.id]);
  }

  //update database
  Future<void> updateAt(int index, List<Tag> list) async{

    await update(list[index]);
  }

  Future<void> changeTotalPoints(Tag tag, int change) async {

    //change in primary memory
    tag.total_points += change;

    //change in secondary memory
    await (await db).update('tags', {
      'total_points': tag.total_points
    }, where: 'id = ?', whereArgs: [tag.id]);

    //create entry in points table
    await (await db).insert('points', {
      'created_at': DateTime.now().toIso8601String(),
      'points': tag.total_points,
      'tag': tag.id
    });
  }

  Future<List<Task>> getTasks(Tag tag) async {

    List<Task> list = [];

    List<Map> query = await (await db).query(
        'tasks',
        columns: [
          'id',
          'title',
          'description',
          'weight',
          'created_at',
          'checked',
          'mode'
        ], where: 'tag = ?', whereArgs: [tag.id]);

    for(int i=0; i < query.length; i++){

      Map taskMap = query[i];
      Task task = Task(taskManager);

      task.title = taskMap['title'];
      task.description = taskMap['description'];
      task.id = taskMap['id'];
      task.tag = tag;
      task.weight = taskMap['weight'];
      task.created_at = DateTime.parse(taskMap['created_at']);
      task.checked = taskMap['checked'] == 1 ? true : false;
      task.intToTaskMode(taskMap['mode']);

      list.add(task);
    }

    length = list.length;

    return list;
  }

  Future<void> updatePriority(List<Tag> tags, int before, int after) async {

    if(before==after) return;

    int afterPriority = tags[after].priority;

    Batch batch = (await db).batch();

    //remove
    if( before < after ){

      for(int i = after; i > before; i--){

        tags[i].priority = tags[i-1].priority;

        batch.update('tasks',{
          'priority': tags[i].priority
        }, where: 'id = ?', whereArgs: [tags[i].id]);
      }

    }else{

      for(int i = after; i < before; i++){

        tags[i].priority = tags[i+1].priority;

        batch.update('tasks',{
          'priority': tags[i].priority
        }, where: 'id = ?', whereArgs: [tags[i].id]);
      }
    }

    tags[before].priority = afterPriority;

    batch.update('tasks',{
      'priority': tags[before].priority
    }, where: 'id = ?', whereArgs: [tags[before].id]);

    await batch.commit(noResult: true);

    tags.insert(after, tags.removeAt(before));
  }

  Future<List<Map>> getPoints(int tag) async {

    return await (await db).query(
        'points',
        columns: [
          'points',
          'created_at'
        ],
        where: 'tag = ?',
        whereArgs: [tag]
    );
  }

  List<FlSpot> pointsToSpots(List<Map> points, DateTime start) {

    points.sort((greater, smaller) => DateTime.parse(greater['created_at']).isAfter(DateTime.parse(smaller['created_at'])) ? 1:-1);

    List<FlSpot> spots = [FlSpot(0,0)];

    for(int i=0; i < points.length; i++){

      Duration diff = DateTime.parse(points[i]['created_at']).difference(start);

      spots.add(FlSpot(diff.inSeconds.toDouble(), points[i]['points'].toDouble()));
    }

    return spots;
  }
}