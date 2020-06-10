import 'package:flutter/material.dart';
import 'package:health/pages/home/MainCircle/mainCircle.dart';
import 'package:health/pages/home/MainCircle/presureCir.dart';

class measurementsCircles extends StatefulWidget {
  String iconName;
  String cirTitle;
  String cirFooter;
  String cirFooter2;
  double cirPercent;
  double cirSize;
  Color cirColor;
  String time;
  bool isPreSure;

  measurementsCircles(String icon, String title, String footer, double percent,
      double size, Color color,
      [bool isp = false, String footer2 = null]) {
    iconName = icon;
    cirTitle = title;
    cirFooter = footer;
    cirPercent = percent;
    cirSize = size;
    cirColor = color;
    isPreSure = isp;
    cirFooter2 = footer2;
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

    Widget cir() {
      return ChartWidget(
        isOnSide: false,
        isUpper: true,
        radius: raduis,
        title: widget.cirTitle == null ? 0 : widget.cirTitle,
        image: widget.iconName,
        footer: Column(
          children: <Widget>[
            Text(widget.cirFooter, style: TextStyle(color: Colors.grey)),
            widget.cirFooter2 != null
                ? Text(
                    widget.cirFooter2,
                    style: TextStyle(color: Colors.grey),
                  )
                : Container()
          ],
        ),
        time: "",
        percent: widget.cirPercent == null
            ? 0
            : widget.cirPercent > 1 ? 1 : widget.cirPercent,
        color: widget.cirColor,
      );
    }

    Widget cir1() {
      return PressureChartWidget(
        isOnSide: false,
        isUpper: true,
        radius: raduis,
        title: widget.cirTitle == null ? 0 : widget.cirTitle,
        image: widget.iconName,
        footer: Text(widget.cirFooter, style: TextStyle(color: Colors.grey)),
        time: "",
        percent: widget.cirPercent == null
            ? 0
            : widget.cirPercent > 1 ? 1 : widget.cirPercent,
        color: widget.cirColor,
      );
    }

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 199,
          height: 199,
          child: widget.isPreSure == false ? cir() : cir1(),
        ),
      ),
    );
  }
}
