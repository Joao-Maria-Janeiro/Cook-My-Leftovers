import 'dart:convert';
import 'package:http/http.dart' as http;
import 'keys.dart' as keys;
import 'package:flutter/material.dart';
import 'cards_section_alignment.dart';
import 'cards_section_draggable.dart';

class SwipeFeedPage extends StatefulWidget
{

  final String ingredients;

  const SwipeFeedPage({Key key, this.ingredients}) : super(key: key);

  @override
  _SwipeFeedPageState createState() => new _SwipeFeedPageState();
}

class _SwipeFeedPageState extends State<SwipeFeedPage>
{
  bool showAlignmentCards = false;
  List data;
  List filtered = new List();

  Future<String> getData() async {
    var res = await http.get(Uri.encodeFull("https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/findByIngredients?number=200&ranking=1&ingredients=" + widget.ingredients), headers: {"Accept": "application/json", "X-RapidAPI-Key": keys.key});
    setState(() {
      var resBody = json.decode(res.body);
      data = resBody;
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
  Widget build(BuildContext context)
  {
    return new Scaffold
    (
      appBar: new AppBar
      (
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: new IconButton
        (
          onPressed: () {},
          icon: new Icon(Icons.settings, color: Colors.grey)
        ),
        title: new Switch
        (
          onChanged: (bool newValue) => setState(() => showAlignmentCards = newValue),
          value: showAlignmentCards,
          activeColor: Colors.red,
        ),
      ),
      backgroundColor: Colors.white,
      body: new Column
      (
        children: <Widget>
        [
          showAlignmentCards ? new CardsSectionAlignment(context, filtered, filtered.length) : new CardsSectionDraggable(filtered, filtered.length),
          //buttonsRow(),
        ],
      ),
    );
  }


  /*
  Widget buttonsRow()
  {
    return new Container
    (
      margin: new EdgeInsets.symmetric(vertical: 48.0),
      child: new Row
      (
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>
        [
          new FloatingActionButton
          (
            mini: true,
            onPressed: () {},
            backgroundColor: Colors.white,
            child: new Icon(Icons.loop, color: Colors.yellow),
          ),
          new Padding(padding: new EdgeInsets.only(right: 8.0)),
          new FloatingActionButton
          (
            onPressed: () {},
            backgroundColor: Colors.white,
            child: new Icon(Icons.close, color: Colors.red),
          ),
          new Padding(padding: new EdgeInsets.only(right: 8.0)),
          new FloatingActionButton
          (
            onPressed: () {},
            backgroundColor: Colors.white,
            child: new Icon(Icons.favorite, color: Colors.green),
          ),
          new Padding(padding: new EdgeInsets.only(right: 8.0)),
          new FloatingActionButton
          (
            mini: true,
            onPressed: () {},
            backgroundColor: Colors.white,
            child: new Icon(Icons.star, color: Colors.blue),
          ),
        ],
      ),
    );
  }*/
}