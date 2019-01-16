import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../keys.dart' as keys;

class RecipeDetails extends StatefulWidget {
  final int id;

  const RecipeDetails({Key key, this.id}) : super(key: key);

  @override
  RecipeDetailsState createState() => RecipeDetailsState();
}

class RecipeDetailsState extends State<RecipeDetails> {
  Map data;

  Future<String> getData() async {
    var res = await http.get(Uri.encodeFull("https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/" + (widget.id).toString() + "/information"), headers: {"Accept": "application/json", "X-RapidAPI-Key": keys.key});

    setState(() {
      var resBody = json.decode(res.body);
      data = resBody;
      print(data["extendedIngredients"]);
    });

    return "SUCCESS";
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: new Color.fromRGBO(240, 240, 240, 4),
      appBar: AppBar(
        title: Text("Recipe details"),
        backgroundColor: Colors.amberAccent,
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
                            child: Column(
                              children: <Widget>[
                                Text("Name: "),
                                Text(data["title"].toString() + "\n",
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.black87)),
                                Text("Cooking Time: "),
                                Text(data["readyInMinutes"].toString() + " minutes\n",
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.black87)),
                                Image.network(
                                  data["image"],
                                ),
                                Text("Ingredients: \n"),
                                Container(
                                  height: data["extendedIngredients"].length * 25.0,
                                  child: ListView.builder(
                                    itemCount: data["extendedIngredients"] == null ? 0 : data["extendedIngredients"].length,
                                    itemBuilder: (BuildContext context, int index){
                                      return new Container(
                                        child: Column(
                                          children: <Widget>[
                                            Text(data["extendedIngredients"][index]["name"],
                                                style: TextStyle(
                                                    fontSize: 18.0, color: Colors.black87)),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Text("\n" + "Intructions: "),
                                Text(data["instructions"].toString().replaceAll("  ", "\n"),
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.black87)),
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