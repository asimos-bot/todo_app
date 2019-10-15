import 'package:flutter/material.dart';
import 'Tag.dart';

class ListEntry {

  String _title="";
  String _description="";
  BuildContext context;

  //global list with all the ListEntries
  List<ListEntry> list;

  //disposed when task is deleted
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  //prompt for crating a entry
  ListEntry(this.context, this.list){

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
  void ListEntryEdit(String appBarTitle){

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
              title: Text(appBarTitle),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.done),
                  onPressed: (){

                    _title = titleController.text;
                    _description = descriptionController.text;

                    Navigator.pop(context);
                  }
                )
              ]
          ),
          body: Form(
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: titleController,
                ),
                Divider(),
                TextFormField(
                  controller: descriptionController
                )
              ]
            )
          )
        )
      )
    );
  }

  //view ListEntry content, has a button to go to ListEntryEdit
  void ListEntryView(){

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => ListEntryEdit('Edit')
              )
            ]
          ),
          body: Container(
            child: Column(
              children: <Widget>[
                Text(_title),
                Divider(),
                Text(_description),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                              'Are you sure you want to delete this task?'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Yes'),
                              onPressed: () {
                                titleController.dispose();
                                descriptionController.dispose();

                                list.remove(this);

                                Navigator.pop(context);
                                Navigator.pop(context);
                              }
                            ),
                            FlatButton(
                              child: Text('No'),
                              onPressed: () {

                                Navigator.pop(context);
                              }
                            )
                          ]
                        );
                      }
                    );
                  }
                )
              ]
            )
          )
        )
      )
    );
  }
}