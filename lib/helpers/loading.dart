import 'package:flutter/material.dart';
import 'package:health/languages/all_translations.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return    Center(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Center(
            child: new SizedBox(
              height: 50.0,
              width: 50.0,
              child: new CircularProgressIndicator(
                value: null,
                backgroundColor: Colors.blue,
                strokeWidth: 3.0,
              ),
            ),
          ),
          new Container(
            margin: const EdgeInsets.only(top: 25.0),
            child: new Center(
              child: new Text(
                allTranslations.text("loading"),
                style: new TextStyle(
                    color: Colors.blue
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
