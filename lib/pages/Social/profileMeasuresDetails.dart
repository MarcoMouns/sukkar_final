import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:health/helpers/loading.dart';
import 'package:health/languages/all_translations.dart';
import 'package:health/pages/home/MainCircle/Circles.dart';
import 'package:health/pages/home/measurementsDetailsPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../measurementsPageCircles.dart';
import '../home/MainCircle/Circles.dart';

class ProfileMeasurementDetails extends StatefulWidget {
  static int friendId;

  FormData formData = new FormData();
  ProfileMeasurementDetails(int id) {
    friendId = id;
  }

  @override
  _ProfileMeasurementState createState() => _ProfileMeasurementState();
}

class _ProfileMeasurementState extends State<ProfileMeasurementDetails> {
  String timeOfLastMeasure = "";
  bool isLoading = true;
  int sugerToday = 0;
  int calories = 0;
  int steps = 0;
  int distance = 0;
  int ncal = 0;
  int cupOfWater = 0;
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

  int id = ProfileMeasurementDetails.friendId;

  Response res;

  Future<Response> getMeasurementsForDay(int id) async {
    Response response;

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, dynamic> authUser =
        jsonDecode(sharedPreferences.getString("authUser"));
    var headers = {
      "Authorization": "Bearer ${authUser['authToken']}",
    };
    response = await dio.get("$baseUrl/friends/$id",
        options: Options(headers: headers));
    print(response.data);
    res = response;
    if (response.data["Measurements"] != null) {
      sugerToday = response.data["Measurements"]["sugar"] == null
          ? 0
          : response.data["Measurements"]["sugar"][0]["sugar"];
      timeOfLastMeasure =
          response.data["Measurements"]["sugar"][0]["time"] == null
              ? " -- "
              : response.data["Measurements"]["sugar"][0]["time"];

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
    }
    print("=================================================fffffffffff");
    isLoading = false;
    setState(() {});
  }

  void getcal() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, dynamic> authUser =
        jsonDecode(sharedPreferences.getString("authUser"));
    var headers = {
      "Authorization": "Bearer ${authUser['authToken']}",
    };
    Response response =
        await dio.get("$baseUrl/auth/me", options: Options(headers: headers));

    ncal = response.data['user']['average_calorie'];
    if (ncal == null || ncal == 0) {
      ncal = 0;
    }
    goalCalories = ncal;
    goalSteps = (ncal / 0.0912).toInt();
    goalDistance = (((ncal / 0.0912) * 0.762) / 2).toInt();

    print('YOYOYOYOYOYOYOYOYOYOYOYOYOYOYOYOYOYOYO');
    print(ncal);
    print('YOYOYOYOYOYOYOYOYOYOYOYOYOYOYOYOYOYOYO');
    setState(() {});
  }

  initState() {
    getcal();
    getMeasurementsForDay(id);
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 120,
                        height: 130,
                        child: measurementsCircles(
                            "ic_cup",
                            cupOfWater.toString(),
                            allTranslations.text("cups"),
                            (cupOfWater / goalCupOfWater).toDouble(),
                            2,
                            (cupOfWater / goalCupOfWater) < 0.3
                                ? redColor
                                : (cupOfWater / goalCupOfWater) > 0.3 &&
                                        (cupOfWater / goalCupOfWater) < 0.6
                                    ? yellowColor
                                    : greenColor),
                      ),
                      SizedBox(
                        width: 120,
                        height: 150,
                        child: measurementsCircles(
                            "ic_blood_pressure",
                            bloodPresure.toString() +
                                "/" +
                                bloodPresure1.toString(),
                            allTranslations.text("bloodPressure"),
                            (bloodPresure / 180),
                            2,
                            (bloodPresure / 180) <= 0.2
                                ? Color.fromRGBO(254, 252, 232, 1)
                                : (bloodPresure / 180) > 0.2 &&
                                        (bloodPresure / 180) < 0.6
                                    ?  Color.fromRGBO(229, 246, 211, 1)
                                    : Color.fromRGBO(253, 238, 238, 1),
                            true),
                      ),
                      SizedBox(
                        width: 120,
                        height: 130,
                        child: measurementsCircles(
                            "ic_heart_rate",
                            heartRate.toString(),
                            allTranslations.text("heartRate"),
                            (heartRate / 160),
                            2,
                            heartRate <= 60
                                ? Color.fromRGBO(254, 252, 232, 1)
                                : heartRate > 60 && heartRate <= 160
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
                        child: SizedBox(
                          height: 160,
                          child: SizedBox(
                            width: 150,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 120,
                        height: 130,
                        child: measurementsCircles(
                            "ic_cal",
                            calories.toString(),
                            allTranslations.text("cals"),
                            ncal == 0 ? 0 : calories / goalCalories,
                            2,
                            (calories / goalCalories) < 0.3
                                ? redColor
                                : (calories / goalCalories) > 0.3 &&
                                        (calories / goalCalories) < 0.6
                                    ? yellowColor
                                    : greenColor),
                      ),
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: measurementsCircles(
                            "ic_steps",
                            steps.toString(),
                            allTranslations.text("steps"),
                            ncal == 0 ? 0 : steps / goalSteps,
                            2,
                            (steps / goalSteps) < 0.3
                                ? redColor
                                : (steps / goalSteps) > 0.3 &&
                                        (steps / goalSteps) < 0.6
                                    ? yellowColor
                                    : greenColor),
                      ),
                      SizedBox(
                        width: 120,
                        height: 150,
                        child: measurementsCircles(
                            "ic_location",
                            distance.toString(),
                            allTranslations.text("distance"),
                            ncal == 0 ? 0 : distance / goalDistance,
                            2,
                            (distance / goalDistance) < 0.3
                                ? redColor
                                : (distance / goalDistance) > 0.3 &&
                                        (distance / goalDistance) < 0.6
                                    ? yellowColor
                                    : greenColor),
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
