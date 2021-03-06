import 'package:flutter/material.dart';
import 'package:health/pages/home/MainCircle/presureCir.dart';
import '../MainCircle/mainCircle.dart';
import 'package:health/languages/all_translations.dart';

abstract class MainCircles {
  static double fontSize = 12;

  static Widget bloodPreassure(
      {BuildContext context,
      double raduis,
      String text,
      String footerText,
      double percent}) {
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
        color: percent <= 0.4
            ? Color.fromRGBO(254, 252, 232, 1)
            : percent > 0.4 && percent < 1
                ? Color.fromRGBO(229, 246, 211, 1)
                : Color.fromRGBO(253, 238, 238, 1));
  }

  static Widget heartRate(
      {BuildContext context,
      double raduis,
      String text,
      String footerText,
      double percent}) {
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
        title: text,
        percent: percent,
        time: "",
        color: int.parse(text) <= 60
            ? Color.fromRGBO(254, 252, 232, 1)
            : int.parse(text) > 60 && int.parse(text) <= 160
                ? Color.fromRGBO(229, 246, 211, 1)
                : Color.fromRGBO(253, 238, 238, 1),
        mainAxisAlignment: MainAxisAlignment.start);
  }

  static Widget cups(
      {BuildContext context,
      String text,
      double raduis,
      String footerText,
      double percent}) {
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
        color: percent <= 0.3
            ? Color.fromRGBO(253, 238, 238, 1)
            : percent > 0.3 && percent < 0.6
                ? Color.fromRGBO(254, 252, 232, 1)
                : Color.fromRGBO(229, 246, 211, 1),
        mainAxisAlignment: MainAxisAlignment.start);
  }

  static Widget water(
      {BuildContext context,
      double raduis,
      String footerText,
      String numberOfCups,
      Function onTap,
      double percent}) {
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
        isUpper: false,
        radius: raduis,
        title: numberOfCups,
        image: "ic_cup",
        footer: column,
        percent: percent,
        onTap: () {
          onTap();
        },
        time: "",
        color: percent <= 0.3
            ? Color.fromRGBO(253, 238, 238, 1)
            : percent > 0.3 && percent < 0.6
                ? Color.fromRGBO(254, 252, 232, 1)
                : Color.fromRGBO(229, 246, 211, 1),
        mainAxisAlignment: MainAxisAlignment.start);
  }

  static Widget heart(
      {BuildContext context,
      double raduis,
      String footerText,
      String heart,
      Function onTap,
      double percent}) {
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
        isUpper: false,
        radius: raduis,
        title: heart,
        image: "ic_heart_rate",
        footer: column,
        percent: percent,
        onTap: () {
          onTap();
        },
        time: "",
        color: int.parse(heart) <= 60
            ? Color.fromRGBO(254, 252, 232, 1)
            : int.parse(heart) > 60 && int.parse(heart) <= 100
                ? Color.fromRGBO(229, 246, 211, 1)
                : Color.fromRGBO(253, 238, 238, 1),
        mainAxisAlignment: MainAxisAlignment.start);
  }

  static Widget blood(
      {BuildContext context,
      double raduis,
      String footerText,
      String blood,
      Function onTap,
      double percent}) {
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
    return PressureChartWidget(
        isOnSide: true,
        isUpper: false,
        radius: raduis,
        title: blood,
        image: "ic_blood_pressure",
        footer: column,
        percent: percent,
        onTap: () {
          onTap();
        },
        time: "",
        color: (int.parse(blood.split("/")[0]) >= 90 &&
                    int.parse(blood.split("/")[0]) <= 140) &&
                (int.parse(blood.split("/")[1]) >= 60 &&
                    int.parse(blood.split("/")[1]) <= 90)
            ? Color.fromRGBO(229, 246, 211, 1)
            : (int.parse(blood.split("/")[0]) < 90 &&
                    int.parse(blood.split("/")[1]) < 60)
                ? Color.fromRGBO(254, 252, 232, 1)
                : Color.fromRGBO(253, 238, 238, 1),
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
        color: percent == 0 || percent <= 0.3
            ? Color.fromRGBO(253, 238, 238, 1)
            : percent > 0.3 && percent < 0.6
                ? Color.fromRGBO(254, 252, 232, 1)
                : Color.fromRGBO(229, 246, 211, 1));
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
        color: percent <= 0.3
            ? Color.fromRGBO(253, 238, 238, 1)
            : percent > 0.3 && percent < 0.6
                ? Color.fromRGBO(254, 252, 232, 1)
                : Color.fromRGBO(229, 246, 211, 1),
        mainAxisAlignment: MainAxisAlignment.start);
  }

  static Widget diabetes({
    BuildContext context,
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
        time: (time.toString()),
        percent: percent,
        color: (int.parse(sugar) <= 69 || sugar == null)
            ? Color.fromRGBO(254, 252, 232, 1)
            : (int.parse(sugar) >= 70 && int.parse(sugar) <= 200)
                ? Color.fromRGBO(229, 246, 211, 1)
                : Color.fromRGBO(253, 238, 238, 1),
        mainAxisAlignment: MainAxisAlignment.center,
        onTap: () {
          if (ontap != null) {
            ontap();
          }
        },
      ),
    );
  }
}
