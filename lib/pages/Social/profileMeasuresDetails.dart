import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:health/helpers/loading.dart';
import 'package:health/languages/all_translations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../measurementsPageCircles.dart';

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
 
  bool isLoading = true;
  int sugerToday =0;
  int calories = 0;
  int steps = 0;
  int distance =0;
  int ncal = 0;
  int cupOfWater = 0;
  int heartRate = 0;
  int bloodPresure = 0;

  int goalCalories = 1300;
  int goalSteps = 700;
  int goalDistance = 3000;
  int goalNcal = 1;
  int goalCupOfWater = 10;

  Color greenColor = Color.fromRGBO(229, 246, 211, 1);
  Color redColor = Color.fromRGBO(253, 238, 238, 1);
  Color yellowColor = Color.fromRGBO(254, 252, 232, 1);

  Dio dio = new Dio();
  final String baseUrl = 'http://104.248.168.117/api';

  int id = ProfileMeasurementDetails.friendId;

  Future<int> getMeasurementsForDay(int id) async {
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
    if(response.data["Measurements"]== null){
      sugerToday = 0;
      distance = 0;
      steps = 0;
      calories = 0 ;
      cupOfWater = 0 ;
      heartRate = 0;
      bloodPresure =0;
      print("in if");



    } 
    else   
    { sugerToday = response.data["Measurements"]["sugar"] == null
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
    heartRate =  response.data["Measurements"]["Heartbeat"] == null
        ? 0
        : response.data["Measurements"]["Heartbeat"];   
        }
    print("=================================================fffffffffff");
    isLoading = false;
    setState(() {});
  }

  void getcal() async {
    print("waaw===========");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("waaw===========");

    ncal = prefs.getInt('calTarget');
    if (ncal == null || ncal == 0) {
      ncal = 1200;
    }
    print('YOYOYOYOYOYOYOYOYOYOYOYOYOYOYOYOYOYOYO');
    print(ncal);
    print('YOYOYOYOYOYOYOYOYOYOYOYOYOYOYOYOYOYOYO');
  }

  //_MeasurementDetailsState();

  initState() {
    getMeasurementsForDay(id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    
    page = isLoading == true ? Scaffold( 
      appBar: AppBar(),
      body: Loading(),) : 
    Scaffold(
      appBar: AppBar(
        title: Text(allTranslations.text("reportsPage")),
      ),
      body: ListView(
        children: [
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
                      bloodPresure.toString(),
                      allTranslations.text("bloodPressure"),
                      0.9,
                      2,
                      redColor),
                ),
                SizedBox(
                  width: 120,
                  height: 130,
                  child: measurementsCircles(
                      "ic_heart_rate",
                      heartRate.toString(),
                      allTranslations.text("heartRate"),
                      0.9,
                      2,
                      redColor),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FittedBox(
                child: SizedBox(
                  height: 160,
                  child: SizedBox(
                    width: 150,
                    height: 160,
                    child: measurementsCircles(
                        "ic_logo_3",
                        sugerToday.toString(),
                        allTranslations.text("sugarDetails"),
                        sugerToday / 600.0,
                        1.5,
                        sugerToday < 80
                            ? yellowColor
                            : sugerToday >= 80 && sugerToday <= 200
                                ? greenColor
                                : redColor),
                  ),
                ),
              )
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
                      calories / goalCalories,
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
                      steps / goalSteps,
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
                      distance / goalDistance,
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
