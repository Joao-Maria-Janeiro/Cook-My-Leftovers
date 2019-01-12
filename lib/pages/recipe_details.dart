import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecipeDetails extends StatefulWidget {
  final int id;

  const RecipeDetails({Key key, this.id}) : super(key: key);

  @override
  RecipeDetailsState createState() => RecipeDetailsState();
}

class RecipeDetailsState extends State<RecipeDetails> {
  Map data1;
  List data;

  Future<String> getData() async {
    var res = await http.get(Uri.encodeFull("https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/" + (widget.id).toString() + "/information"), headers: {"Accept": "application/json", "X-RapidAPI-Key": "07cb41b3e9msh6fc7b2c9f455f3fp1ac9f3jsn9a525aa340d5"});

    setState(() {
      var resBody = json.decode(res.body);
      data1 = resBody;
      data = data1.keys.toList();
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
                                Text(data1[data[25]].toString(),
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.black87)),
                                Text("Cooking Time: "),
                                Text(data1[data[26]].toString(),
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.black87)),
                                Image.network(
                                  data1[data[28]],
                                )
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