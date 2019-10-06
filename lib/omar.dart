import 'package:flutter/material.dart';
import 'package:health/pages/home/MainCircle/mainCircle.dart';

class omar extends StatefulWidget {
  @override
  _omarState createState() => _omarState();
}

class _omarState extends State<omar> {





  @override
  Widget build(BuildContext context) {

    double raduis = MediaQuery.of(context).size.width / 2 <
        MediaQuery.of(context).size.height - (120 + 23 + 14 + 10)
        ? MediaQuery.of(context).size.width / 2
        : MediaQuery.of(context).size.height - (120 + 23 + 14 + 10);

    Widget cir(){
      return ChartWidget(
        isOnSide: false,
        isUpper: true,
        radius: raduis,
        title: "10",
        image: "ic_blood_pressure",
        footer: Text("flater"),
        time: "",
        percent: 0.3,
        color: Color.fromRGBO(254, 252, 232, 1),
      );
    }

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 199,
          height: 199,
          child: cir(),
        ),
    ),
    );
  }
  }
