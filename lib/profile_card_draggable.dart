import 'package:flutter/material.dart';

class ProfileCardDraggable extends StatelessWidget
{
  final int cardNum;
  List filtered;
  int numRecipes;
  ProfileCardDraggable(this.cardNum, this.filtered, this.numRecipes);

  @override
  Widget build(BuildContext context)
  {
    return new Card
    (
      child: new Column
      (
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>
        [
          new Expanded
          (
            child: new Image.network(filtered[cardNum]["image"], fit: BoxFit.cover),
          ),
          new Container
          (
            padding: new EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
            child: new Column
            (
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>
              [
                new Text(filtered[cardNum]["title"], style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700)),
                new Padding(padding: new EdgeInsets.only(bottom: 8.0)),
                new Text('A short description.', textAlign: TextAlign.start),
              ],
            )
          )
        ],
      ),
    );
  }
}