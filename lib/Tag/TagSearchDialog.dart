import 'package:flutter/material.dart';
import '../Tag/Tag.dart';
import '../globals.dart' as globals;

class TagSearchResults extends StatefulWidget {

  final List<Tag> tags;
  final Function callback;
  final TextEditingController searchController;

  TagSearchResults(this.tags, this.callback, this.searchController);

  @override
  createState() => TagSearchResultsState(tags, callback, searchController);
}

class TagSearchResultsState extends State<TagSearchResults> {

  List<Tag> tags;
  Function callback;
  TextEditingController searchController;

  TagSearchResultsState(this.tags, this.callback, this.searchController);

  @override
  @mustCallSuper
  void initState() {

    searchController.addListener((){

        setState((){});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: tags.where((tag) => tag.title.contains(searchController.text) || tag.description.contains(searchController.text))
            .toList().map((tag) => tag.toSearchWidget(context, (){

              callback();

          Navigator.of(context).pop();
        })).toList()
    );
  }
}

class TagSearchDialog extends StatelessWidget {

  final List<Tag> tags;
  final Function callback;
  final TextEditingController searchController = TextEditingController();

  TagSearchDialog(this.tags, this.callback);


  @override
  Widget build(BuildContext context) {

    return Center(
        child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            color: globals.secondaryForegroundColor,
            onPressed: (){

              showDialog(
                  context: context,
                  builder: (context) {

                    return AlertDialog(
                      title: TextField(
                        decoration: InputDecoration(
                          hintText: "Search...",
                        ),
                        controller: searchController
                      ),
                      content: TagSearchResults(tags, callback, searchController)
                    );
                  }
              );
            },
            child: Text("Choose Tag")
        )
    );
  }
}