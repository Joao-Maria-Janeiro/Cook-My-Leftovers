import 'package:cook_my_leftovers/pages/saved_recipes.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../keys.dart' as keys;
import 'dart:io';
import 'package:path_provider/path_provider.dart';


class RecipeDetails extends StatefulWidget {
  final int id;

  const RecipeDetails({Key key, this.id}) : super(key: key);

  @override
  RecipeDetailsState createState() => RecipeDetailsState();
}

class RecipeDetailsState extends State<RecipeDetails> with SingleTickerProviderStateMixin {
  Map data;
  TabController controller;


  Future<String> getData() async {
    var res = await http.get(Uri.encodeFull("https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/" + (widget.id).toString() + "/information"), headers: {"Accept": "application/json", "X-RapidAPI-Key": keys.key});

    setState(() {
      var resBody = json.decode(res.body);
      data = resBody;
      print(data["extendedIngredients"]);
    });

    return "SUCCESS";
  }


  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/saved.txt');
  }

  Future<File> writeCounter(String recipeName, String imageUrl, String id) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(recipeName + "||" + imageUrl + "||" + id + "\n", mode: FileMode.append);
  }

  void saveRecipe({BuildContext context}){
    writeCounter(data["title"].toString(), data["image"].toString(), data["id"].toString());
    final snackbar = new SnackBar(content: new Text(data["title"].toString() + " was saved to your favourites"));
    Scaffold.of(context).showSnackBar(snackbar);
  }

  @override
  void initState() {
    super.initState();
    controller = new TabController(vsync: this, length: 2);
    getData();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: new Color.fromRGBO(240, 240, 240, 4),
      appBar: AppBar(
        title: Text(
            data == null ? "Recipe" : data["title"].toString(),
            style: TextStyle(
                color: Colors.amberAccent)
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.account_circle),
            color: Colors.amberAccent,
            tooltip: data == null ? "Recipe" : data["title"].toString(),
            onPressed: () => Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new SavedRecipesStage())),
          ),
        ],
      ),
      body: new Column(
        children: <Widget>[
          new Expanded(
            child: ListView.builder(
              itemCount: data == null ? 0 : 1,
              itemBuilder: (BuildContext context, int index) {
                return new Container(
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Card(
                          child: Container(
                            margin: const EdgeInsets.only(left: 4.0, right: 4.0),
                            child: Column(
                              children: <Widget>[
                                Image.network(
                                  data["image"],
                                ),
                                //Text("\n"),
                                Container(
                                  margin: const EdgeInsets.only(top: 12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        children: [
                                          Icon(Icons.timer, color: Colors.amberAccent),
                                          Text('Cook:'),
                                          Text(data["readyInMinutes"].toString()),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Image.network("https://www.pngrepo.com/png/166098/170/serving.png", color: Colors.amberAccent, width: 25),
                                          Text('Serves:'),
                                          Text(data["servings"].toString()),
                                        ],
                                      ),
                                      Column(
                                        children: <Widget>[
                                          IconButton(
                                            icon: Icon(Icons.favorite),
                                            color: Colors.amberAccent,
                                            tooltip: 'Save Recipe',
                                            onPressed: () => saveRecipe(context: context),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                                  height: 1.5,
                                  color: Colors.grey,
                                ),
                                Container(
                                  height: 50.0,
                                  child: TabBar(
                                    indicatorColor: Colors.amberAccent,
                                    labelColor: Colors.grey,
                                    controller: controller,
                                    tabs: <Tab>[
                                      new Tab(text: "Ingredients"),
                                      new Tab(text: "Instructions"),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 8.0, top: 10.0),
                                  height: 300.0,
                                  child: TabBarView(
                                    controller: controller,
                                    children: <Widget>[
                                      ListView.builder(
                                        physics: const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: data["extendedIngredients"] == null ? 0 : data["extendedIngredients"].length,
                                        itemBuilder: (BuildContext context, int index){
                                          return new Container(
                                            child: Column(
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Text("• ",
                                                        style: TextStyle(
                                                            fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black87)),
                                                    Text((data["extendedIngredients"][index]["amount"]).toString() + " " + (data["extendedIngredients"][index]["unit"]).toString() + " " + data["extendedIngredients"][index]["name"],
                                                        style: TextStyle(
                                                            fontSize: 14.0, color: Colors.black87)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                      Text(data["instructions"].toString().replaceAll("  ", "\n"),
                                          style: TextStyle(
                                              fontSize: 16.0, color: Colors.black87)),
                                    ],
                                  ),
                                ),
                                Text("Recipe by: " + data["creditText"].toString(),
                                    style: TextStyle(
                                        fontSize: 16.0, color: Colors.black87))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}