import 'package:flutter/material.dart';
import 'TagManager.dart';

class TagMaster extends StatefulWidget {

  final TagManager tags;

  TagMaster(this.tags);

  @override
  createState() => TagMasterState(tags);
}

class TagMasterState extends State<TagMaster>{

  TagManager tags;

  TagMasterState(this.tags);

  @override
  Widget build(BuildContext context) {

    return Text("Todo: really fancy stuff");
  }
}