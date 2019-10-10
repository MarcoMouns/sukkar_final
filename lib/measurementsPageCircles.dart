import 'package:flutter/material.dart';
import 'package:health/pages/home/MainCircle/mainCircle.dart';

class measurementsCircles extends StatefulWidget {
   String iconName;
   String cirTitle;
   String cirFooter;
   double cirPercent;
   double cirSize;
   Color  cirColor;
   String time;
   
  measurementsCircles(String icon , String title , String footer , double percent , double size , Color color){
    iconName = icon;
    cirTitle = title;
    cirFooter = footer;
    cirPercent = percent;
    cirSize = size;
    cirColor = color;
  }
  @override
  _measurementsCirclesState createState() => _measurementsCirclesState();
}

class _measurementsCirclesState extends State<measurementsCircles> {
  



  @override
  Widget build(BuildContext context) {

    double raduis = MediaQuery.of(context).size.width / widget.cirSize <
        MediaQuery.of(context).size.height - (120 + 23 + 14 + 10)
        ? MediaQuery.of(context).size.width / widget.cirSize
        : MediaQuery.of(context).size.height - (120 + 23 + 14 + 10);
    

    Widget cir(){
      return ChartWidget(
        
        isOnSide: false,
        
        isUpper: true,
        radius: raduis,
        title: widget.cirTitle == null ? 0 :widget.cirTitle,
        image: widget.iconName,
        footer: Text(widget.cirFooter),
        time: "",
        percent: widget.cirPercent == null ? 0 :widget.cirPercent ,
        color: widget.cirColor,
        
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
