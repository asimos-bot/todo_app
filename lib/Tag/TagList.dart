import 'package:flutter/material.dart';
import 'package:todo_yourself/Tag/Tag.dart';
import 'package:sqflite/sqflite.dart';
import '../FormWidgets/Controller.dart';

//manage database and list at the same time
class TagList extends Controller {

  Future<Database> db;
  int length=-1;

  TagList(this.db);

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

      list.add(tag);
    }

    length = list.length;

    return list;
  }

  Future<Tag> get(int id) async {

    List<Map> query = await (await db).query('tags', columns: ['id', 'title', 'description', 'weight', 'color'], where: 'id = ?', whereArgs: [id]);

    if(query.length == 0) return null;

    Map tagMap = query[0];

    Tag tag = Tag(this);

    tag.id = tagMap['id'];
    tag.title = tagMap['title'];
    tag.description = tagMap['description'];
    tag.weight = tagMap['weight'];
    tag.color = Color(tagMap['color']);

    return tag;
  }

  Future<void> add(Tag tag) async {

    await (await db).insert('tags', {
      'title': tag.title,
      'description': tag.description,
      'color': tag.color.value,
      'weight': tag.weight
    });
  }

  Future<void> delete(Tag tag) async {

    //update tasks which reference to this tag
    await (await db).update('tasks', {
      'tag': null
    }, where: 'tag = ?', whereArgs: [tag.id]);

    await (await db).delete('tags', where: 'id = ?', whereArgs: [tag.id]);
  }

  Future<void> update(Tag tag) async {

    await (await db).update('tags', {
      'title': tag.title,
      'description': tag.description,
      'color': tag.color.value,
      'weight': tag.weight
    }, where: 'id = ?', whereArgs: [tag.id]);
  }

  //update database
  Future<void> updateAt(int index, List<Tag> list) async{

    await update(list[index]);
  }
}