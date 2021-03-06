import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'recipe_details.dart';
import '../keys.dart' as keys;
import 'dart:io';
import 'package:cook_my_leftovers/pages/saved_recipes.dart';


final primaryColor = const Color.fromRGBO(250, 163, 0, 80);
final secondaryColor = const Color.fromRGBO(0, 88, 250, 80);

class RecipesStage extends StatefulWidget {

  final String ingredients;
  static final now = new DateTime.now();
  static final seconds3 = now.add(new Duration(seconds: 3));

  const RecipesStage({Key key, this.ingredients}) : super(key: key);

  @override
  State createState() => new RecipesStageState();
}


class RecipesStageState extends State<RecipesStage> {
  List data;
  List filtered = new List();
  bool _waiting = true;
  bool _internet = true;

  Future<String> getData() async {
    var res = await http.get(Uri.encodeFull("https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/findByIngredients?number=200&ranking=1&ingredients=" + widget.ingredients), headers: {"Accept": "application/json", "X-RapidAPI-Key": keys.key});
    setState(() {
      var resBody = json.decode(res.body);
      data = resBody;
      print(data);
      filterData();
    });

    return "SUCCESS";
  }

  void filterData(){
    for (var i = 0; i < data.length; i++){
      if(data[i]["missedIngredientCount"] == 0){
        filtered.add(data[i]);
      }
    }
    _waiting = false;
  }

  Future checkState() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          _internet = true;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        _internet = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
    checkState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    if (_internet == true){
      if (filtered.length != 0) {
        return new Scaffold(
          backgroundColor: new Color.fromRGBO(240, 240, 240, 4),
          appBar: AppBar(
            title: Text(
                "Recipes",
                style: TextStyle(
                    color: Colors.amberAccent)
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.account_circle),
                color: primaryColor,
                tooltip: 'Your saved recipes',
                onPressed: () => Navigator.of(context).push(
                    new MaterialPageRoute(builder: (
                        BuildContext context) => new SavedRecipesStage())),
              ),
            ],
          ),
          body: ListView.builder(
            itemCount: filtered == null ? 0 : filtered.length,
            itemBuilder: (BuildContext context, int index) {
              return new Container(
                height: 200,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      new Expanded(
                        child: Card(
                          //margin: const EdgeInsets.all(0.0),
                          elevation: 12,
                          margin: const EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 6.0, bottom: 6.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22.0),
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(0.0),
                            constraints: new BoxConstraints.expand(
                              height: 192.0,
                            ),
                            child: new InkWell(
                              onTap: () => Navigator.of(context).push(
                                  new MaterialPageRoute(builder: (
                                      BuildContext context) =>
                                  new RecipeDetails(
                                      id: filtered[index]["id"]))),
                              child: Container(
                                decoration: new BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(22.0)),
                                  image: new DecorationImage(
                                    image: new NetworkImage(
                                        filtered[index]["image"]),
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                                child: new Container(
                                  margin: const EdgeInsets.only(
                                      top: 8.0, left: 10.0),
                                  child: new Text(filtered[index]["title"],
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,)),
                                ),
                              ),
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
      } else {
        if (_waiting) {
          return new Scaffold(
            backgroundColor: new Color.fromRGBO(240, 240, 240, 4),
            appBar: AppBar(
              title: Text(
                  "Recipes",
                  style: TextStyle(
                      color: Colors.amberAccent)
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.account_circle),
                  color: primaryColor,
                  tooltip: 'Your saved recipes',
                  onPressed: () => Navigator.of(context).push(
                      new MaterialPageRoute(builder: (
                          BuildContext context) => new SavedRecipesStage())),
                ),
              ],
            ),
            body: new Container(
              child: Center(
                  child: new CircularProgressIndicator(
                    value: null,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.amberAccent),
                  )
              ),
            ),
          );
        } else {
          return new Scaffold(
            appBar: new AppBar(
              title: new Text("Available Recipes"),
            ),
            body: new Container(
              padding: const EdgeInsets.all(26),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 250,
                      decoration: new BoxDecoration(
                        image: new DecorationImage(
                          image: new NetworkImage("https://i.ibb.co/Ttv1fqg/no-results-found.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Text(
                        "No recipes match your ingredients, would you like other recipes with more ingredients? ",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,)),
                    new ButtonTheme.bar(
                      child: new ButtonBar(
                        alignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new RaisedButton(
                            onPressed: () =>
                                setState(() {
                                  filtered.addAll(data);
                                }),
                            child: new Text("Yes", style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            )),
                            color: Colors.amberAccent,
                          ),
                          new RaisedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: new Text("No", style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            )),
                            color: Colors.amberAccent,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      }
    }else{
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("Available Recipes"),
        ),
        body: new Container(
          child: Center(
            child: Column(
              children: <Widget>[
                Text("You have no internet connection"),
              ],
            ),
          ),
        ),
      );
    }

  }


}



