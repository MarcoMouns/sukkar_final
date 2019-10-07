import 'package:flutter/material.dart';
import '../MainCircle/mainCircle.dart';
import 'package:health/languages/all_translations.dart';

import 'package:intl/intl.dart' as intl;

abstract class MainCircles {
  static double fontSize = 12;

  static Widget bloodPreassure(
      {BuildContext context, double raduis, String text, String footerText,double percent}) {
    Widget column;
    List<Widget> list = List();
    list.add(Text(
      allTranslations.text("bloodPressure"),
      style: TextStyle(color: Colors.grey, fontSize: fontSize),
    ));
    if (footerText != null) {
      list.add(Text(
        footerText,
        style: TextStyle(color: Colors.grey, fontSize: fontSize),
      ));
    }

    column = Column(
      children: list,
    );
    return ChartWidget(
        isOnSide: false,
        isUpper: true,
        radius: raduis,
        title: text,
        image: "ic_blood_pressure",
        footer: column,
        time: "",
        percent: percent,
        color: Color.fromRGBO(254, 252, 232, 1));
  }

  static Widget heartRate(
      {BuildContext context, double raduis, String text, String footerText, double percent}) {
    Widget column;
    List<Widget> list = List();
    list.add(Text(
      allTranslations.text("heartRate"),
      style: TextStyle(color: Colors.grey, fontSize: fontSize),
    ));
    if (footerText != null) {
      list.add(Text(
        footerText,
        style: TextStyle(color: Colors.grey, fontSize: fontSize),
      ));
    }

    column = Column(
      children: list,
    );
    return ChartWidget(
        isOnSide: true,
        isUpper: true,
        /// @omar dah rakam wa7ed double
        radius: raduis,
        image: "ic_heart_rate",
        footer: column,
        title: text,
        percent: percent,
        time: "",
        //TODO: @Omar here is the value of chart color
        color: Color.fromRGBO(229, 246, 211, 1),
        mainAxisAlignment: MainAxisAlignment.start);
  }

  static Widget cups(
      {BuildContext context, String text, double raduis, String footerText, double percent}) {
    Widget column;
    List<Widget> list = List();
    list.add(Text(
      allTranslations.text("cups"),
      style: TextStyle(color: Colors.grey, fontSize: fontSize),
    ));
    if (footerText != null) {
      list.add(Text(
        footerText,
        style: TextStyle(color: Colors.grey, fontSize: fontSize),
      ));
    }

    column = Column(
      children: list,
    );
    return ChartWidget(
        isOnSide: true,
        isUpper: true,
        radius: raduis,
        title: text,
        image: "ic_cup",
        footer: column,
        time: "",
        percent: percent,
        color: Color.fromRGBO(253, 238, 238, 1),
        mainAxisAlignment: MainAxisAlignment.start);
  }

  static Widget distance(
      {BuildContext context,
      double raduis,
      String footerText,
      String distance,
      Function onTap,
      double percent}) {
    Widget column;
    List<Widget> list = List();
    list.add(Text(
      allTranslations.text("distance"),
      style: TextStyle(color: Colors.grey, fontSize: fontSize),
    ));
    if (footerText != null) {
      list.add(Text(
        footerText,
        style: TextStyle(color: Colors.grey, fontSize: fontSize),
      ));
    }

    column = Column(
      children: list,
    );
    return ChartWidget(
        isOnSide: true,
        isUpper: false,
        radius: raduis,
        title: distance,
        image: "ic_location",
        footer: column,
        percent: percent,
        onTap: () {
          onTap();
        },
        time: "",
        color: percent<=0.2 ? Color.fromRGBO(253, 238, 238, 1)
                             :percent > 0.2 && percent < 0.6 ? Color.fromRGBO(254, 252, 232, 1)
                                  :Color.fromRGBO(229, 246, 211, 1),
        mainAxisAlignment: MainAxisAlignment.start);
  }

  static Widget steps(
      {BuildContext context,
      double raduis,
      int steps,
      String footerText,
      Function onTap,
      double percent}) {
    Widget column;
    List<Widget> list = List();
    list.add(Text(
      allTranslations.text("steps"),
      style: TextStyle(color: Colors.grey, fontSize: fontSize),
    ));
    if (footerText != null) {
      list.add(Text(
        footerText,
        style: TextStyle(color: Colors.grey, fontSize: fontSize),
      ));
    }

    column = Column(
      children: list,
    );
    return ChartWidget(
        isOnSide: false,
        isUpper: false,
        radius: raduis,
        title: steps.toString(),
        image: "ic_steps",
        footer: column,
        onTap: () {
          if (onTap != null) {
            onTap();
          }
        },
        time: "",
        percent: percent,
        color: percent<=0.2 ? Color.fromRGBO(253, 238, 238, 1)
                             :percent > 0.2 && percent < 0.6 ? Color.fromRGBO(254, 252, 232, 1)
                                  :Color.fromRGBO(229, 246, 211, 1));
  }

  static Widget cal(
      {BuildContext context,
      double raduis,
      var day_Calories,
      String footerText,
      Function ontap,
      double percent}) {
    Widget column;
    List<Widget> list = List();
    list.add(Text(
      allTranslations.text("cals"),
      style: TextStyle(color: Colors.grey, fontSize: fontSize),
    ));
    if (footerText != null) {
      list.add(Text(
        footerText,
        style: TextStyle(color: Colors.grey, fontSize: fontSize),
      ));
    }

    column = Column(
      children: list,
    );
    return ChartWidget(
        isOnSide: true,
        isUpper: false,
        radius: raduis,
        title: day_Calories.toString(),
        image: "ic_cal",
        footer: column,
        time: "",
        onTap: () {
          if (ontap != null) {
            ontap();
          }
        },
        percent: percent,
        color: percent<=0.2 ? Color.fromRGBO(253, 238, 238, 1)
                             :percent > 0.2 && percent < 0.6 ? Color.fromRGBO(254, 252, 232, 1)
                                  :Color.fromRGBO(229, 246, 211, 1),
                                   
        mainAxisAlignment: MainAxisAlignment.start);
  }

  static Widget diabetes(
      {BuildContext context,
      String sugar,
      String status,
      double raduis,
      Widget footer,
      Function ontap,
      double percent,
      String time,
      }) {
    return SizedBox(
      height: raduis + 25,
      child: ChartWidget(
        isOnSide: false,
        isUpper: false,
        title: sugar,
        status: status,
        radius: raduis * 2,
        image: "ic_logo_3",
        footer: footer == null
            ? SizedBox(
                height: 0,
                width: 0,
              )
            : footer,
        time: time,
        percent: percent,
        color: (int.parse(sugar)< 80 || sugar == null) ?Color.fromRGBO(254, 252, 232, 1)
                       : (int.parse(sugar) >= 80 && int.parse(sugar) <= 200) 
                               ? Color.fromRGBO(229, 246, 211, 1) :
                               Color.fromRGBO(253, 238, 238, 1)
        , mainAxisAlignment: MainAxisAlignment.center,
        onTap: () {
          if (ontap != null) {
            ontap();
          }
        },
      ),
    );
  }
}
