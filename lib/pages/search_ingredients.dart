import 'package:flutter/material.dart';
import 'get_recipes.dart';
import 'saved_recipes.dart';

String result = "";
int _count = 1;

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
                  child: new Icon(Icons.add),
                ),
                RaisedButton(
                  onPressed: onPressed,
                  color: primaryColor,
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


