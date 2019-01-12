import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'recipe_details.dart';

class RecipesStage extends StatefulWidget {

  final String ingredients;

  const RecipesStage({Key key, this.ingredients}) : super(key: key);

  @override
  State createState() => new RecipesStageState();
}


class RecipesStageState extends State<RecipesStage> {
  List data;

  Future<String> getData() async {
    var res = await http.get(Uri.encodeFull("https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/findByIngredients?number=200&ranking=1&ingredients=" + widget.ingredients), headers: {"Accept": "application/json", "X-RapidAPI-Key": "07cb41b3e9msh6fc7b2c9f455f3fp1ac9f3jsn9a525aa340d5"});
    setState(() {
      var resBody = json.decode(res.body);
      data = resBody;
      print(data);
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
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("Available Recipes"),
        ),
        body: ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, int index){
            return new Container(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Card(
                      child: Container(
                        child: new InkWell(
                          onTap: () => Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new RecipeDetails(id: data[index]["id"]))),
                            child: Column(
                              children: <Widget>[
                                Text("Name: "),
                                Text(data[index]["title"],
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.black87)),
                                Text("Owned Ingredients: "),
                                Text((data[index]["usedIngredientCount"]).toString(),
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.black87)),
                                Text("Missing ingredients: "),
                                Text((data[index]["missedIngredientCount"]).toString(),
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.black87)),
                                Image.network(
                                  data[index]["image"],
                                )
                              ],
                            )),
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

