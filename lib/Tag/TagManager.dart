import 'package:flutter/material.dart';
import 'package:todo_yourself/Tag/Tag.dart';
import 'package:sqflite/sqflite.dart';
import '../FormWidgets/Controller.dart';

//manage database and list at the same time
class TagManager extends Controller {

  Future<Database> db;
  int length=-1;

  TagManager(this.db);

  Future<List<Tag>> list() async {

    List<Tag> list = [];

    List<Map> queryResult = await (await db).rawQuery('SELECT * FROM tags');

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

      list.add(tag);
    }

    length = list.length;

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
          'total_points'
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

    return tag;
  }

  Future<void> add(Tag tag) async {

    await (await db).insert('tags', {
      'title': tag.title,
      'description': tag.description,
      'color': tag.color.value,
      'weight': tag.weight,
      'created_at': DateTime.now().toIso8601String(),
      'total_points': tag.total_points
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
      'total_points': tag.total_points
    }, where: 'id = ?', whereArgs: [tag.id]);
  }

  //update database
  Future<void> updateAt(int index, List<Tag> list) async{

    await update(list[index]);
  }

  Future<int> calculateTotalPoints(Tag tag) async {

    return Sqflite.firstIntValue(await (await db).rawQuery(
        'SELECT COALESCE(SUM(points), 0) FROM points WHERE tag = ?',
        [tag.id]
    ));
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
}