import 'package:cook_my_leftovers/pages/recipe_details.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SavedRecipesStage extends StatefulWidget {


  @override
  State createState() => new SavedRecipesStageState();
}


class SavedRecipesStageState extends State<SavedRecipesStage> {

  List<String> contents = new List();
  List<String> temp = new List();


  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/saved.txt');
  }

  Future<List<String>> readCounter() async {
    try {
      final file = await _localFile;

      temp = await file.readAsLines();

      // Read the file
      setState(() {
        contents = temp;
      });

      print(contents);

      return contents;
    } catch (e) {
      // If we encounter an error, return 0
      print(e);
      return new List();
    }
  }

  @override
  void initState() {
    super.initState();
    readCounter();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Your saved recipes Recipes"),
      ),
      body: ListView.builder(
        itemCount: contents == null ? 0 : contents.length,
        itemBuilder: (BuildContext context, int index){
          return new Container(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Card(
                    child: Container(
                      child: new InkWell(
                        onTap: () => Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new RecipeDetails(id: int.parse((contents[index]).split("||")[2])))),
                        child: Column(
                          children: <Widget>[
                            Text((contents[index]).split("||")[0],
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.black87)),
                            Image.network(
                              (contents[index]).split("||")[1],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

