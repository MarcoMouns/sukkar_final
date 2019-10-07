import 'package:flutter/material.dart';

class changeTargetScreen extends StatefulWidget {
  @override
  _changeTargetScreenState createState() => _changeTargetScreenState();
}

class _changeTargetScreenState extends State<changeTargetScreen> {

  void

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("تغير الهدف"),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 10)),
            Text('AAAAAAAAAAAAAAAA'),
            Padding(padding: EdgeInsets.only(top: 10)),
            Text('BBBBBBBBBBBBBBBBBB'),
            Padding(padding: EdgeInsets.only(top: 10)),
            Text('CCCCCCCCCCCCCCCCCC'),
          ],
        ),
      ),
    );
  }
}
