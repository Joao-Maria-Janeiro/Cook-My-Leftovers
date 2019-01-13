import 'package:flutter/material.dart';
import './pages/get_recipes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
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
  int _count = 1;

  String result = "";

  @override
  Widget build(BuildContext context) {
    List<Widget> _ingredients = new List.generate(_count, (int i) => new IngredientColumn());

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: new Container(
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new TextField(
                decoration: new InputDecoration(
                  hintText: "Write your ingredients here"
                ),
                onSubmitted: (String str){
                  setState(() {
                    result = result + str;
                    Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new RecipesStage(ingredients: result)));
                  });
                },
              ),
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
                color: Colors.amberAccent,
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(4.0)),
                elevation: 6.0,
                onPressed: () => Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new RecipesStage(ingredients: result))),
                child: new Text("Check For Recipes"),
              ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
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
  @override
  Widget build(BuildContext context) {
    return new Container(
        width: 170.0,
        padding: new EdgeInsets.all(5.0),
        child: new Column(children: <Widget>[
          new TextField(
            decoration: new InputDecoration(
              labelText: 'Ingredient',
            ),
            onSubmitted: (String str){
            setState(() {
              //result = result + str;
            });
          },
          ),
        ]));
  }
}