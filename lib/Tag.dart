import 'package:flutter/material.dart';
import 'TagList.dart';

class Tag {

  int id = -1;

  Colors color;
  double weight;
  String title="";
  String description="";

  //global list with all the tags
  TagList list;

  //dispose when task is deleted
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  Tag(this.list);

  Widget toWidget(context){

    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(description, overflow: TextOverflow.ellipsis),
        onTap: () => tagView(context),
      )
    );
  }

  void tagEdit(context){

    titleController.value = new TextEditingController.fromValue(new TextEditingValue(text: title)).value;
    descriptionController.value = new TextEditingController.fromValue(new TextEditingValue(text: description)).value;

    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => Scaffold(
                appBar: AppBar(
                    title: Text('Edit Tag'),
                    actions: <Widget>[
                      IconButton(
                          icon: Icon(Icons.done),
                          onPressed: (){

                            title = titleController.text;
                            description = descriptionController.text;

                            list.update(this);

                            Navigator.pop(context);
                          }
                      )
                    ]
                ),
                body: Form(
                    child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(filled: true, fillColor: Colors.white,hintText: "Title"),
                            style: TextStyle(color: Colors.black),
                            controller: titleController,
                          ),
                          Divider(),
                          TextFormField(
                            decoration: InputDecoration(filled: true, fillColor: Colors.white,hintText: "Description"),
                            style: TextStyle(color: Colors.black),
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
  void tagView(context){

    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => Scaffold(
                appBar: AppBar(
                    title: Text("Tag description"),
                    actions: <Widget>[
                      IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => tagEdit(context)
                      )
                    ]
                ),
                body: Container(
                    padding: EdgeInsets.all(30.0),
                    child: Column(
                        children: <Widget>[

                          Text(title,style: TextStyle(color: Colors.white)),
                          Divider(),
                          Text(description,style: TextStyle(color: Colors.white)),
                          Expanded(
                              child: Center(
                                  child: ClipOval(
                                      child:Container(
                                          padding: EdgeInsets.all(4.0),
                                          color: Color(0xFF6A1B9A),
                                          child:IconButton(
                                              hoverColor: Colors.white ,
                                              highlightColor:Colors.white ,
                                              focusColor: Colors.white,
                                              color: Colors.white,

                                              icon: Icon(Icons.delete),
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                          title: Text('Are you sure you want to delete this tag?'),
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
                                      )
                                  )
                              )
                          )
                        ]
                    )
                )
            )
        )
    );
  }
}