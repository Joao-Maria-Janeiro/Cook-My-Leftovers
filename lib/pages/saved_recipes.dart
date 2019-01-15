import 'package:flutter/material.dart';

class SavedRecipesStage extends StatefulWidget {


  @override
  State createState() => new SavedRecipesStageState();
}


class SavedRecipesStageState extends State<SavedRecipesStage> {


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Your saved recipes Recipes"),
      ),
      body: Text("Your saved recipes")
    );
  }
}

