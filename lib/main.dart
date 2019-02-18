import 'package:cook_my_leftovers/pages/recipe_details.dart';
import 'package:cook_my_leftovers/pages/search_ingredients.dart';
import 'package:flutter/material.dart';
import './pages/get_recipes.dart';
import './pages/saved_recipes.dart';
import 'dart:async';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'keys.dart' as keys;
import 'package:cook_my_leftovers/pages/saved_recipes.dart';
import 'package:highlighter_coachmark/highlighter_coachmark.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

String result = "";
int _count = 1;
bool firstRun = false;

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
  List suggestions = new List();
  String trivia;
  List seen = new List();

  GlobalKey _fabKey = GlobalObjectKey("fab");
  GlobalKey _tileKey = GlobalObjectKey("tile_2");

  List<String> contents = new List();

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/firstRun.txt');
  }

  Future<File> writeCounter(String value) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(value, mode: FileMode.write);
  }

  Future<bool> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();


      if(contents == '0') {
        setState(() {
          firstRun = true;
        });
      }else{
        writeCounter("0");
        setState(() {
          firstRun = false;
        });
      }
    } catch (e) {
      // If we encounter an error, return 0
      setState(() {
        firstRun = false;
      });
    }
    return firstRun;
  }

  Future<String> getData() async {
    var res = await http.get(Uri.encodeFull("https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/findByIngredients?number=200&ranking=1&ingredients=" + "salt"), headers: {"Accept": "application/json", "X-RapidAPI-Key": keys.key});
    var foodTrivia = await http.get(Uri.encodeFull("https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/food/trivia/random"), headers: {"X-RapidAPI-Key": keys.key});
    setState(() {
      var resBody = json.decode(res.body);
      var resTrivia = json.decode(foodTrivia.body);
      trivia = resTrivia["text"];
      data = resBody;
      getTheSuggestions();
    });

    if(await readCounter() == false) {
      writeCounter("1\n");
    }
    await readCounter();
    if(firstRun == false) {
      Timer(Duration(seconds: 1), () => showInstructionalOverlay());
    }
    return "SUCCESS";
  }

  Future<String>getTrivia() async{
    var foodTrivia = await http.get(Uri.encodeFull("https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/food/trivia/random"), headers: {"X-RapidAPI-Key": keys.key});
    setState(() {
      var resTrivia = json.decode(foodTrivia.body);
      trivia = resTrivia["text"];
    });
    return "SUCCESS";
  }

  void getTheSuggestions(){
    for (var i = 0; i < 5; i++){
      var idx;
      do{
        var rng = new Random();
        idx = rng.nextInt(data.length);
      }while(seen.contains(idx));
      seen.add(idx);
      suggestions.add(data[idx]);
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


  void showInstructionalOverlay() {
    CoachMark coachMarkFAB = CoachMark();
    RenderBox target = _fabKey.currentContext.findRenderObject();

    Rect markRect = target.localToGlobal(Offset.zero) & target.size;
    markRect = Rect.fromCircle(
      center: markRect.center, radius: markRect.longestSide * 0.0);

    coachMarkFAB.show(
        targetContext: _fabKey.currentContext,
        markRect: markRect,
        children: [
          Center(
              child: Text("Hello There!\n\nWe'll teach how to \nuse this app",
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  )))
        ],
        duration: null,
        onClose: () {
          Timer(Duration(seconds: 1), () => showCoachMarkFAB());
        });


  }

  //Here is example of CoachMark usage
  void showCoachMarkFAB() {
    CoachMark coachMarkFAB = CoachMark();
    RenderBox target = _fabKey.currentContext.findRenderObject();

    Rect markRect = target.localToGlobal(Offset.zero) & target.size;
    markRect = Rect.fromCircle(
        center: markRect.center, radius: markRect.longestSide * 0.6);

    coachMarkFAB.show(
        targetContext: _fabKey.currentContext,
        markRect: markRect,
        children: [
          Center(
              child: Text("Tap on Icon to list \nall your ingredients",
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  )))
        ],
        duration: null,
        onClose: () {
          //Timer(Duration(seconds: 3), () => showCoachMarkTile());
        });
  }

  //And here is example of CoachMark usage.
  //One more example you can see in FriendDetailsPage - showCoachMarkBadges()
  void showCoachMarkTile() {
    CoachMark coachMarkTile = CoachMark();
    RenderBox target = _tileKey.currentContext.findRenderObject();

    Rect markRect = target.localToGlobal(Offset.zero) & target.size;
    markRect = markRect.inflate(5.0);

    coachMarkTile.show(
        targetContext: _fabKey.currentContext,
        markRect: markRect,
        markShape: BoxShape.rectangle,
        children: [
          Positioned(
              top: markRect.bottom + 15.0,
              right: 5.0,
              child: Text("Tap on friend to see details",
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  )))
        ],
        duration: Duration(seconds: 3));
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
                height: 160,
                decoration: new BoxDecoration(
                    image: new DecorationImage(
                      image: new NetworkImage("https://i.ibb.co/ZmtsBjj/appetizer-board-color-326268.jpg"),
                      fit: BoxFit.cover,
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
                        color: Colors.amberAccent,
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
                          key: _fabKey,
                          iconSize: 40,
                          color: Colors.amberAccent,
                          onPressed: () =>
                              Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new SearchPage())),
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
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: suggestions == null ? 0 : suggestions.length,
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
                                      onTap: () => Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new RecipeDetails(id: suggestions[index]["id"]))),
                                      child: Container(
                                        decoration: new BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(22.0)),
                                          image: new DecorationImage(
                                            image: new NetworkImage(suggestions[index]["image"]),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        child: new Container(
                                          margin: const EdgeInsets.only(top: 8.0, left: 10.0),
                                          child: new Text(suggestions[index]["title"],
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
                Container(
                  margin: const EdgeInsets.only(top: 28),
                  padding: const EdgeInsets.all(12),
                  decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      gradient: new LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.green,
                            Colors.lightGreen,
                          ]
                      ),
                      boxShadow: [
                        new BoxShadow(
                          color: Colors.black54,
                          blurRadius: 6.0,
                        )
                      ]
                  ),
                  child: InkWell(
                    onTap: () => getTrivia(),
                    child: Text(trivia == null ? "Loading..." : trivia ,
                        style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700, color: Colors.white)
                    ),
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