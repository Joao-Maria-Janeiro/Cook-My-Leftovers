import 'package:cook_my_leftovers/swipe_feed_page.dart';
import 'package:flutter/material.dart';
import './pages/get_recipes.dart';

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
      appBar: AppBar(title: Text("Cook My Leftovers")),
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

      var snackbar = SnackBar(
        content:
        Text('Username: $result'),
        duration: Duration(milliseconds: 5000),
      );

      mainKey.currentState.showSnackBar(snackbar);
      String buff = result;

      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new SwipeFeedPage(ingredients: buff)));
      
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


  @override
  Widget build(BuildContext context) {
    return new Container(
      width: 170.0,
      padding: new EdgeInsets.all(5.0),
      child: new Column(children: <Widget>[
        TextFormField(
          autocorrect: false,
          decoration: InputDecoration(
            labelText: "Ingredient:",
          ),
          onSaved: (str) => result += "," + str,
        ),
      ])
    );
  }

}


