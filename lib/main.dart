import 'package:cook_my_leftovers/pages/recipe_details.dart';
import 'package:cook_my_leftovers/pages/search_ingredients.dart';
import 'package:cook_my_leftovers/swipe_feed_page.dart';
import 'package:flutter/material.dart';
import './pages/get_recipes.dart';
import './pages/saved_recipes.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'keys.dart' as keys;
import 'package:cook_my_leftovers/pages/saved_recipes.dart';

String result = "";
int _count = 1;

final primaryColor = const Color.fromRGBO(250, 163, 0, 80);
final secondaryColor = const Color.fromRGBO(0, 88, 250, 80);

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        cursorColor: primaryColor,
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Cook My Leftovers'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List data;
  bool _waiting = true;

  Future<String> getData() async {
    var res = await http.get(Uri.encodeFull("https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/findByIngredients?number=200&ranking=1&ingredients=" + "salt"), headers: {"Accept": "application/json", "X-RapidAPI-Key": keys.key});
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

  final formKey = GlobalKey<FormState>();
  final mainKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: mainKey,
      body: Padding(
        padding: EdgeInsets.all(0.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: 180,
                decoration: new BoxDecoration(
                    image: new DecorationImage(
                      image: new NetworkImage("https://i.ibb.co/nfwbh3F/food-Wall-2.jpg"),
                      fit: BoxFit.cover,
                    ),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0)
                  ),
                  gradient: new LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blue,
                      Colors.lightBlueAccent,
                    ]
                  ),
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.black54,
                        blurRadius: 10.0,
                      )
                    ]
                ),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.account_circle),
                        iconSize: 40,
                        color: primaryColor,
                        tooltip: 'Your saved recipes',
                        onPressed: () =>
                            Navigator.of(context).push(new MaterialPageRoute(builder: (
                                BuildContext context) => new SavedRecipesStage())),
                      ),
                      Text(
                          widget.title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.amberAccent)
                      ),
                      //flexibleSpace: Image.network("https://i.ibb.co/nfwbh3F/food-Wall-2.jpg",),
                        IconButton(
                          icon: Icon(Icons.search),
                          iconSize: 40,
                          color: primaryColor,
                          onPressed: () =>
                              Navigator.of(context).push(new MaterialPageRoute(builder: (
                                  BuildContext context) => new Search())),
                        )
                  ],
                )
              ),
              Container(
                padding: const EdgeInsets.all(22.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                Text("Chef Suggestions",
                    style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700)
                ),
                Container(
                  margin: const EdgeInsets.only(top:16.0, bottom: 4.0),
                  height: 200.0,
                  width: 250,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: data == null ? 0 : data.length,
                    itemBuilder: (BuildContext context, int index){
                      return new Container(
                        height: 200,
                        width: 250,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              new Expanded(
                                child: Card(
                                  //margin: const EdgeInsets.all(0.0),
                                  elevation: 2,
                                  margin: const EdgeInsets.only(left: 8.0, right: 8.0, top: 6.0, bottom: 6.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(22.0),
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.all(0.0),
                                    constraints: new BoxConstraints.expand(
                                      height: 200,
                                    ),
                                    child: new InkWell(
                                      onTap: () => Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new RecipeDetails(id: data[index]["id"]))),
                                      child: Container(
                                        decoration: new BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(22.0)),
                                          image: new DecorationImage(
                                            image: new NetworkImage(data[index]["image"]),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        child: new Container(
                                          margin: const EdgeInsets.only(top: 8.0, left: 10.0),
                                          child: new Text(data[index]["title"],
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