//import 'package:flutter/material.dart';
//
//import 'pages/home.dart';
//
//class ex extends StatefulWidget {
//  @override
//  _exState createState() => _exState();
//}
//
//class _exState extends State<ex> {
//
//  bool isClickedF=false;
//
//  List<bool> isClicked = [false,false,false];
//  Color color1;
//
//
//  bool finished(){
//    for(int i=0 ; i<=2 ; i++){
//      if(isClicked[i]==false){
//        return false;
//      }
//      return true;
//    }
//  }
//
//
//
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      body: Column(
//        children: <Widget>[
//          Center(
//            child: RaisedButton(
//              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => MainHome())),
//            ),
//          ),
//          InkWell(
//            child: Container(
//              width: 100,
//              height: 100,
//              //color: finished()? Colors.red : color,
//            ),
//          )
//        ],
//      )
//    );
//  }
//}
