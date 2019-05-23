import 'package:flutter/material.dart';
import 'package:health/MainCircle/mainCircle.dart';
import 'package:health/languages/all_translations.dart';
// import 'package:health/pages/measurement/addsugar.dart';
import 'package:intl/intl.dart' as intl;

abstract class MainCircles {
  static double fontSize = 12;
  static Widget bloodPreassure(
      {BuildContext context, double raduis, String footerText}) {
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
        image: "ic_blood_pressure",
        footer: column,
        time: "",
        percent: 0.3,
        color: Color.fromRGBO(254, 252, 232, 1));
  }

  static Widget heartRate(
      {BuildContext context, double raduis, String footerText}) {
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
        radius: raduis,
        image: "ic_heart_rate",
        footer: column,
        percent: 0.6,
        time: "",
        color: Color.fromRGBO(229, 246, 211, 1),
        mainAxisAlignment: MainAxisAlignment.start);
  }

  static Widget cups({BuildContext context, double raduis, String footerText}) {
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
        title: "5",
        image: "ic_cup",
        footer: column,
        time: "",
        percent: 3200 / 7000,
        color: Color.fromRGBO(253, 238, 238, 1),
        mainAxisAlignment: MainAxisAlignment.start);
  }

  static Widget distance(
      {BuildContext context,
      double raduis,
      String footerText,
      Function onTap}) {
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
        title: "27",
        image: "ic_location",
        footer: column,
        percent: 0.6,
        onTap: () {
          onTap();
        },
        time: "",
        color: Color.fromRGBO(229, 246, 211, 1),
        mainAxisAlignment: MainAxisAlignment.start);
  }

  static Widget steps(
      {BuildContext context,
      double raduis,
      int steps,
      String footerText,
      Function onTap}) {
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
        percent: 0.3,
        color: Color.fromRGBO(254, 252, 232, 1));
  }

  static Widget cal(
      {BuildContext context,
      double raduis,
      String footerText,
      Function ontap}) {
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
        title: 3000.toString(),
        image: "ic_cal",
        footer: column,
        time: "",
        onTap: () {
          if (ontap != null) {
            ontap();
          }
        },
        percent: 3200 / 7000,
        color: Color.fromRGBO(253, 238, 238, 1),
        mainAxisAlignment: MainAxisAlignment.start);
  }

  static Widget diabetes(
      {BuildContext context, double raduis, Widget footer, Function ontap}) {
    return SizedBox(
      height: raduis + 25,
      child: ChartWidget(
          isOnSide: false,
          isUpper: false,
          title: "288",
          status: allTranslations.text("high"),
          radius: raduis * 2,
          image: "ic_logo_3",
          footer: footer == null
              ? SizedBox(
                  height: 0,
                  width: 0,
                )
              : footer,
          time: intl.DateFormat("Hm", allTranslations.locale.languageCode)
              .format(DateTime.now()),
          percent: 0.6,
          color: Color.fromRGBO(253, 238, 238, 1),
          mainAxisAlignment: MainAxisAlignment.center,
          onTap: ontap()),
    );
  }
}
