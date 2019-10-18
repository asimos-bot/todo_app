import 'package:flutter/material.dart';
import 'Tag.dart';
import 'package:sqflite/sqflite.dart';

//manage database and list at the same time
class TagList {

  List<Tag> list = [];
  Database db;
  BuildContext context;

  void create(context, db, List<Map> queryResult){

    this.db = db;
    this.context = context;

    for(int i=0; i < queryResult.length; i++){

      Map tagMap = queryResult[i];
      Tag tag = Tag(this);

      tag.title = tagMap['title'];
      tag.description = tagMap['description'];
      tag.id = tagMap['id'];

      list.add(tag);
    }
  }

  void add(Tag tag){

    list.add(tag);

    db.insert('tags', {'title': tag.title, 'description': tag.description});
  }

  Tag get(int index){

    if( index >= list.length || index < 0 ) throw("Index out of bounds in TaskList");

    return list[index];
  }

  Tag removeAt(int index) {

    Tag tmp = this.get(index);

    list.removeAt(index);

    db.delete('tags', where: 'id = ?', whereArgs: [tmp.id]);

    return tmp;
  }

  Tag remove(Tag tag){

    if( list.remove(tag) ){

      db.delete('tags', where: 'id = ?', whereArgs: [tag.id]);
    }

    return tag;
  }

  //update database
  void updateAt(int index){

    if( index >= list.length || index < 0 ) throw("Index out of bounds in TaskList");

    db.update('tags', {'title': list[index].title, 'description': list[index].description}, where: 'id = ?', whereArgs: [list[index].id]);
  }

  void update(Tag tag){

    updateAt( list.indexOf(tag) );
  }
}