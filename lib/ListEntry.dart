import 'package:flutter/material.dart';
import 'Tag.dart';

class ListEntry {

  String _title="";
  String _description="";
  BuildContext context;

  //prompt for crating a entry
  ListEntry(this.context){

    ListEntryEdit('Create Task');
  }

  //return this entry in widget form
  Widget toWidget(){

    return new SizedBox(
      child: new Card(
        child: new ListTile(
          title: new Text(_title, overflow: TextOverflow.ellipsis),
          subtitle: new Text(_description, overflow: TextOverflow.ellipsis),
          onTap: () => ListEntryView(),
        )
      )
    );
  }

  //edit ListEntry
  Widget ListEntryEdit(String appBarTitle){

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
              title: Text(appBarTitle)
          ),
          body: Form(
            child: Column(
              children: <Widget>[
                TextFormField(),
                Divider(),
                TextFormField()
              ]
            )
          )
        )
      )
    );
  }

  //view ListEntry content, has a button to go to ListEntryEdit
  void ListEntryView(){

  }
}