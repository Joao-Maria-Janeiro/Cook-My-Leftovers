import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'get_recipes.dart';
import 'saved_recipes.dart';
import 'package:highlighter_coachmark/highlighter_coachmark.dart';

String result = "";
int _count = 1;
bool firstRun = false;

final primaryColor = const Color.fromRGBO(250, 163, 0, 80);
final secondaryColor = const Color.fromRGBO(0, 88, 250, 80);


class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);


  @override
  SearchPageState createState() => SearchPageState();

}

class SearchPageState extends State<SearchPage> {


  final formKey = GlobalKey<FormState>();
  final mainKey = GlobalKey<ScaffoldState>();
  GlobalKey _addFab = GlobalObjectKey("addFab");


  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/firstRunIng.txt');
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

      print(contents);

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
      setState(() {
        firstRun = false;
      });
    }
    return firstRun;
  }

  void showCoachMarkFAB() {
    CoachMark coachMarkFAB = CoachMark();
    RenderBox target = _addFab.currentContext.findRenderObject();

    Rect markRect = target.localToGlobal(Offset.zero) & target.size;
    markRect = Rect.fromCircle(
        center: markRect.center, radius: markRect.longestSide * 0.6);

    coachMarkFAB.show(
        targetContext: _addFab.currentContext,
        markRect: markRect,
        children: [
              Container(
                margin: EdgeInsets.all(64),
                  child: Text("Tap on Add to add \none more ingredient",
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                      ))
              ),
        ],
        duration: null,
        onClose: () {
          //Timer(Duration(seconds: 3), () => showCoachMarkTile());
        });
  }

  void startTutorial() async {
    if(await readCounter() == false) {
    writeCounter("1\n");
    }
    await readCounter();
    if(firstRun == false) {
    Timer(Duration(seconds: 1), () => showCoachMarkFAB());
    }
  }

  @override
  void initState() {
    super.initState();
    startTutorial();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _ingredients = new List.generate(_count, (int i) => new IngredientColumn());
    if(_count == 0){
      _count++;
    }
    return Scaffold(
      key: mainKey,
      appBar: AppBar(
        title: Text(
            "What ingredients do you have?",
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
            onPressed: () => Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new SavedRecipesStage())),
          ),
        ],
      ),
      body: Padding(
          padding: EdgeInsets.all(10.0),
          child:  Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 7,
                  child: new Container(
                    //height: 200.0,
                    child: new ListView(
                      children: _ingredients,
                      scrollDirection: Axis.vertical,
                    ),
                  ),
                ),
                new FlatButton(
                  onPressed: _addNewIngredientColumn,
                  key: _addFab,
                  child: new Icon(Icons.add, size: 32,),
                ),
                RaisedButton(
                  padding: const EdgeInsets.all(12.0),
                  onPressed: onPressed,
                  color: primaryColor,
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(8.0)),
                  elevation: 2.0,
                  child: new Text("Check For Recipes",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,)),
                ),
              ],
            ),
          )
      ),
    );
  }

  void onPressed() {
    var form = formKey.currentState;

    if (form.validate()) {
      form.save();
      setState(() {
      });

      result = result.substring(1, result.length);

      String buff = result;

      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new RecipesStage(ingredients: buff)));

      result = "";
      _count = 0;
    }
  }



  void _addNewIngredientColumn() {
    setState(() {
      _count = _count + 1;
    });
  }
}

class IngredientColumn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _IngredientColumn();
}

class _IngredientColumn extends State<IngredientColumn> {
  FocusNode nodeTwo = FocusNode();

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
    FocusScope.of(context).requestFocus(nodeTwo);
    return new Container(
        width: 170.0,
        padding: new EdgeInsets.all(5.0),
        child: new Column(children: <Widget>[
          TextFormField(
            focusNode: nodeTwo,
            autocorrect: false,
            decoration: InputDecoration(
                labelText: "Ingredient:",
                labelStyle: new TextStyle(
                    color: primaryColor
                ),
                hintText: "Write you ingredient here",
                border: new OutlineInputBorder(
                  borderSide: new BorderSide(width: 1.0, color: Colors.white),
                )
            ),
            onSaved: (str) => result += "," + str,
          ),
        ])
    );
  }

}


