import 'package:flutter/material.dart';
import '../Tag/Tag.dart';
import '../globals.dart' as globals;

class TagWrapper {

  Tag tag;
  TagWrapper(this.tag);
}

class TagSearch extends StatelessWidget {

  final TagWrapper tagValue;
  final List<Tag> tags;
  final Function callback;

  TagSearch(this.tags, this.tagValue, this.callback);

  @override
  Widget build(BuildContext context) {

    return tagValue.tag == null ? Center(
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: globals.secondaryForegroundColor,
        onPressed: (){
          showDialog(
              context: context,
              builder: (context) => TagSearchDialog(tags, tagValue, callback)
          );
        },
        child: Text("Choose Tag")
      )
    ) : tagValue.tag.toSearchWidget(context, (tag){

      showDialog(
        context: context,
        builder: (context) => TagSearchDialog(tags, tagValue, callback)
      );
    });
  }
}

class TagSearchDialog extends StatefulWidget {

  final TextEditingController searchController = TextEditingController();
  final TagWrapper tagValue;
  final Function callback;
  final List<Tag> tags;

  TagSearchDialog(this.tags, this.tagValue, this.callback);

  @override
  createState() => TagSearchDialogState(tags, tagValue, searchController, callback);
}

class TagSearchDialogState extends State<TagSearchDialog> {

  TextEditingController searchController;
  TagWrapper tagValue;
  List<Tag> tags;
  Function callback;

  TagSearchDialogState(this.tags, this.tagValue, this.searchController, this.callback);

  @override
  @mustCallSuper
  void initState(){

    super.initState();

    searchController.addListener((){

      setState((){});
    });
  }

  @override
  @mustCallSuper
  void dispose(){

    super.dispose();

    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {

      List<Widget> widgetTags = tags.where((tag) {
        return tag.title.toLowerCase().contains(searchController.text) || tag.description.toLowerCase().contains(searchController.text);

      }).toList().map((tag) {

        return tag.toSearchWidget(context, (thisTag){

          tagValue.tag = thisTag;
          callback();
          Navigator.pop(context);
        });

      }).toList();

      return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30.0)
            )
          ),
          title: TextField(
            style: TextStyle(
                color: globals.backgroundColor
            ),
            decoration: InputDecoration(
                prefixIcon: Icon(
                    Icons.search,
                    color: globals.backgroundColor
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0)
                ),
                hintStyle: TextStyle(
                    color: globals.backgroundColor
                ),
                hintText: 'Search...'
            ),
            controller: searchController
          ),
          content: ListView.builder(
              itemCount: widgetTags.length,
              itemBuilder: (context, index) {
                return widgetTags[index];
              }
          )
      );
    }
}