import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:health/helpers/loading.dart';
import 'package:health/languages/all_translations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../measurementsPageCircles.dart';
import 'MainCircle/Circles.dart';

class MeasurementDetails extends StatefulWidget {
  static DateTime date;
  static int sugerToday;
  static int calories;
  static int steps;
  static int distance;
  static int cupOfWater;
  static int heartRate;
  FormData formData = new FormData();

  MeasurementDetails(DateTime d, int suger, cal, stps, dist, water) {
    date = d;
    sugerToday = suger;
    calories = cal;
    steps = stps;
    distance = dist;
    cupOfWater = water;
  }

  @override
  _MeasurementDetailsState createState() => _MeasurementDetailsState();
}

class _MeasurementDetailsState extends State<MeasurementDetails> {
  var dateString =
      '${MeasurementDetails.date.year}-${MeasurementDetails.date.month}-${MeasurementDetails.date.day}';
  String timeOfLastMeasure = "";
  bool isLoading = true;
  int sugerToday = 0;
  int calories = 0;
  int steps = 0;
  int distance = 0;
  int ncal = 0;
  int cupOfWater;
  int heartRate = 0;
  int bloodPresure1 = 0;
  int bloodPresure = 0;
  int cOW = 0;

  int goalCalories = 0;
  int goalSteps = 0;
  int goalDistance = 0;
  int goalCupOfWater = 15;

  Color greenColor = Color.fromRGBO(229, 246, 211, 1);
  Color redColor = Color.fromRGBO(253, 238, 238, 1);
  Color yellowColor = Color.fromRGBO(254, 252, 232, 1);

  Dio dio = new Dio();
  final String baseUrl = 'http://api.sukar.co/api';

  Future<int> getMeasurementsForDay(String date) async {
    Response response;

    // try {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, dynamic> authUser =
        jsonDecode(sharedPreferences.getString("authUser"));
    var headers = {
      "Authorization": "Bearer ${authUser['authToken']}",
    };
    response = await dio.get("$baseUrl/measurements?date=$date",
        options: Options(headers: headers));
    sugerToday = response.data["Measurements"]["sugar"] == null
        ? 0
        : response.data["Measurements"]["sugar"][0]["sugar"];
    distance = response.data["Measurements"]["distance"] == null
        ? 0
        : response.data["Measurements"]["distance"];
    steps = response.data["Measurements"]["NumberOfSteps"] == null
        ? 0
        : response.data["Measurements"]["NumberOfSteps"];
    calories = response.data["Measurements"]["day_Calories"] == null
        ? 0
        : response.data["Measurements"]["day_Calories"];
    cupOfWater = response.data["Measurements"]["water_cups"] == null
        ? 0
        : response.data["Measurements"]["water_cups"];
    heartRate = response.data["Measurements"]["Heartbeat"] == null
        ? 0
        : response.data["Measurements"]["Heartbeat"];
    bloodPresure = response.data["Measurements"]["SystolicPressure"] == null
        ? 0
        : response.data["Measurements"]["SystolicPressure"];
    bloodPresure1 = response.data["Measurements"]["DiastolicPressure"] == null
        ? 0
        : response.data["Measurements"]["DiastolicPressure"];

    timeOfLastMeasure = response.data["Measurements"]["sugar"][0]["time"];
    goalCalories = response.data["Measurements"]["calorie_goal"];
    goalCupOfWater = response.data["Measurements"]["water_cups_goal"];
    goalSteps = response.data["Measurements"]["steps_goal"];
    goalDistance = response.data["Measurements"]["distance_goal"];

    print("==================>>>>>>>");
    print(goalCalories);
    print(goalCupOfWater);
    print(goalSteps);
    print(goalDistance);
    print("==================>>>>>>>");

    print("=================================================fffffffffff");
    print(response.data);
    isLoading = false;
    if (mounted) setState(() {});
    return response.data["Measurements"]["sugar"][0]["sugar"];
  }

  //_MeasurementDetailsState();

  initState() {
    getMeasurementsForDay(dateString);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _screenHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        40 -
        56;
    //check if the width or height ratio is bigger so no overlaying occur
    double _chartRadius =
        (_screenHeight * 3 / 5 - MediaQuery.of(context).padding.top - 40 - 56 <
                    MediaQuery.of(context).size.width - 30
                ? _screenHeight * 3 / 5
                : MediaQuery.of(context).size.width - 30) /
            2;

    Widget page = Scaffold(
      appBar: AppBar(
        title: Text(allTranslations.text("reportsPage")),
      ),
      body: ListView(
        children: isLoading == true
            ? <Widget>[Loading()]
            : <Widget>[
                SizedBox(
                  height: 40,
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 125,
                        height: 160,
                        child: measurementsCircles(
                            "ic_cup",
                            cupOfWater.toString(),
                            allTranslations.text("cups"),
                            (cupOfWater / goalCupOfWater).toDouble(),
                            2,
                            (cupOfWater / goalCupOfWater) <= 0.3
                                ? redColor
                                : (cupOfWater / goalCupOfWater) > 0.3 &&
                                        (cupOfWater / goalCupOfWater) < 0.6
                                    ? yellowColor
                                    : greenColor,
                            false,
                            "${allTranslations.text("Goal is") + ": " + goalCupOfWater.toString()}"),
                      ),
                      SizedBox(
                        width: 125,
                        height: 180,
                        child: measurementsCircles(
                            "ic_blood_pressure",
                            bloodPresure.toString() +
                                "/" +
                                bloodPresure1.toString(),
                            allTranslations.text("bloodPressure"),
                            (bloodPresure / 140),
                            2,
                            (bloodPresure >= 90 && bloodPresure <= 140) &&
                                    (bloodPresure >= 60 && bloodPresure1 <= 90)
                                ? Color.fromRGBO(229, 246, 211, 1)
                                : (bloodPresure < 90 && bloodPresure1 < 60)
                                    ? Color.fromRGBO(254, 252, 232, 1)
                                    : Color.fromRGBO(253, 238, 238, 1),
                            true),
                      ),
                      SizedBox(
                        width: 125,
                        height: 160,
                        child: measurementsCircles(
                            "ic_heart_rate",
                            heartRate.toString(),
                            allTranslations.text("heartRate"),
                            (heartRate / 100),
                            2,
                            heartRate <= 60
                                ? Color.fromRGBO(254, 252, 232, 1)
                                : heartRate > 60 && heartRate <= 100
                                    ? Color.fromRGBO(229, 246, 211, 1)
                                    : Color.fromRGBO(253, 238, 238, 1)),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height / 3,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.height / 3,
                            height: 160,
                            child: sugerToday == 0
                                ? measurementsCircles(
                                    "ic_logo_3",
                                    sugerToday.toString(),
                                    allTranslations.text("sugarNull"),
                                    0,
                                    1.5,
                                    yellowColor)
                                : MainCircles.diabetes(
                                    percent:
                                        sugerToday == 0 || sugerToday == null
                                            ? 1 / 600
                                            : sugerToday / 600,
                                    context: context,
                                    time: timeOfLastMeasure,
                                    sugar: sugerToday == 0
                                        ? '0'
                                        : sugerToday == null
                                            ? '0'
                                            : sugerToday.toString(),
                                    raduis: _chartRadius,
                                    status: sugerToday == 0 ||
                                            sugerToday == null
                                        ? allTranslations.text("sugarNull")
                                        : (sugerToday < 69)
                                            ? allTranslations.text("low")
                                            : (sugerToday >= 70 &&
                                                    sugerToday <= 89)
                                                ? allTranslations
                                                    .text("LowNormal")
                                                : (sugerToday >= 90 &&
                                                        sugerToday <= 200)
                                                    ? allTranslations
                                                        .text("normal")
                                                    : allTranslations
                                                        .text("high"),
                                    ontap: () => null,
                                    footer: Container(),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 125,
                        height: 180,
                        child: measurementsCircles(
                            "ic_cal",
                            calories.toString(),
                            allTranslations.text("cals"),
                            calories == 0 ? 0 : calories / goalCalories,
                            2,
                            (calories / goalCalories) <= 0.3
                                ? redColor
                                : (calories / goalCalories) > 0.3 &&
                                        (calories / goalCalories) < 0.6
                                    ? yellowColor
                                    : greenColor,
                            false,
                            "${allTranslations.text("Goal is") + ": " + goalCalories.toString()}"),
                      ),
                      SizedBox(
                        width: 125,
                        height: 160,
                        child: measurementsCircles(
                            "ic_steps",
                            steps.toString(),
                            allTranslations.text("steps"),
                            steps == 0 ? 0 : steps / goalSteps,
                            2,
                            (steps / goalSteps) <= 0.3
                                ? redColor
                                : (steps / goalSteps) > 0.3 &&
                                        (steps / goalSteps) < 0.6
                                    ? yellowColor
                                    : greenColor,
                            false,
                            "${allTranslations.text("Goal is") + ": " + goalSteps.toString()}"),
                      ),
                      SizedBox(
                        width: 125,
                        height: 180,
                        child: measurementsCircles(
                            "ic_location",
                            distance.toString(),
                            allTranslations.text("distance"),
                            distance == 0 ? 0 : distance / goalDistance,
                            2,
                            (distance / goalDistance) <= 0.3
                                ? redColor
                                : (distance / goalDistance) > 0.3 &&
                                        (distance / goalDistance) < 0.6
                                    ? yellowColor
                                    : greenColor,
                            false,
                            "${allTranslations.text("Goal is") + ": " + goalDistance.toString()}"),
                      ),
                    ],
                  ),
                )
              ],
      ),
    );

    return page;
  }
}
