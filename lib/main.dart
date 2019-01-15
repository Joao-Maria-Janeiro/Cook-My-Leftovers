import 'package:cook_my_leftovers/swipe_feed_page.dart';
import 'package:flutter/material.dart';
import './pages/get_recipes.dart';
import './pages/saved_recipes.dart';

String result = "";
int _count = 1;


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        cursorColor: Colors.amberAccent,
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


  final formKey = GlobalKey<FormState>();
  final mainKey = GlobalKey<ScaffoldState>();

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
              widget.title,
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
                new Container(
                  height: 200.0,
                  child: new ListView(
                    children: _ingredients,
                    scrollDirection: Axis.vertical,
                  ),
                ),
                new FlatButton(
                  onPressed: _addNewIngredientColumn,
                  child: new Icon(Icons.add),
                ),
                RaisedButton(
                  onPressed: onPressed,
                  color: Colors.amberAccent,
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(4.0)),
                  elevation: 6.0,
                  child: new Text("Check For Recipes"),
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
              color: Colors.amberAccent
            ),
            hintText: "Write you ingredient here",
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.amberAccent)
            )
          ),
          onSaved: (str) => result += "," + str,
        ),
      ])
    );
  }

}


