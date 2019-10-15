import 'package:flutter/material.dart';
import 'ListEntry.dart';
import 'Tag.dart';

class Category extends StatelessWidget{
  
  @override
  Widget build(BuildContext context){

    return new MaterialApp();
  }

  addCategory(List<Widget> category, Text text){
    var cat = <Widget>[];
    for(var i = 0; i <= category.length;i++){
      cat.add(category[i]);
    }
    cat.add(new ListTile(title: text, onTap: (){},));
    return cat;
  }

}