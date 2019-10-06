import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:health/Models/sugar.dart';
import 'package:health/globals.dart';
import 'package:health/helpers/loading.dart';
import 'package:health/languages/all_translations.dart';
import 'package:health/pages/home/home.dart';
import 'package:health/pages/measurement/addsugar.dart';
import 'package:health/scoped_models/main.dart';
import 'package:health/scoped_models/measurements.dart';
import 'package:intl/intl.dart' as intl;
import 'package:screenshot_share_image/screenshot_share_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:health/pages/Settings.dart' as settings;
import '../Settings.dart';
import '../home.dart';
import 'MainCircle/Circles.dart';

class MeasurementDetails extends StatefulWidget {
  static DateTime date;
  FormData formData =  new FormData();
  MeasurementDetails([DateTime d]) {
    date = d;
  }

  @override
  _MeasurementDetailsState createState() => _MeasurementDetailsState();
}

class _MeasurementDetailsState extends State<MeasurementDetails> {
  DateTime date = MeasurementDetails.date;
  String dateString="2019-10-6";
  int sugerToday=100;
  int calories=1300;
  int steps=700;
  int distance=3000;
  int ncal=1;

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
  _MeasurementDetailsState();

  initState() {
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
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: <Widget>[
          Expanded(
            child: upperCircles(context, _chartRadius, model),
          )
        ],
      ), 
        
      
    );
       
 
    
  
}


  Widget upperCircles(context, _chartRadius, model) {
    return  CustomMultiChildLayout(
            delegate: CirclesDelegate(_chartRadius),
            children: <Widget>[
              new LayoutId(
                id: 1,
                child: MainCircles.diabetes(
                  percent: sugerToday == 0 || sugerToday == null?1/600 : sugerToday/600,
                  context: context,
                  
//                sugar: dataHome['sugar'].toString(),z
                  sugar: sugerToday == 0
                      ?'0'
                      : sugerToday == null
                          ? '0'
                          : sugerToday.toString(),
                  raduis: _chartRadius,
                  
                  status: sugerToday == 0 || sugerToday== null
                      ? allTranslations.text("sugarNull")
                       : (sugerToday< 80)?
                          allTranslations.text("low")
                          : (sugerToday >= 80 && sugerToday <= 200
                              ? allTranslations.text("normal")
                              :  allTranslations.text("high")
                                      ),
                  ontap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddSugar(date)),
                    );
                  },
                  footer: Row(
                    
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      SizedBox(
                        height: _chartRadius / 11,
                        width: _chartRadius / 5,
                      ),
                      
                      

                    ],
                  ),
                ),
              ),
              new LayoutId(
                  id: 2,
                  child: MainCircles.cal(
                      percent: calories == null
                          ? 0
                          : calories == null
                              ? 0
                              : ((calories / ncal)*0.7),
                      context: context,

                      day_Calories: calories== null
                          ? 0
                          : calories == null
                              ? 0
                              : calories.toString(),
                      ontap: () => null,
                      raduis: _chartRadius,
                      footerText: "Cal " +
                          " ${ncal} :" +
                          allTranslations.text("Goal is"))),
              new LayoutId(
                id: 3,
                child: MainCircles.steps(
                    percent: steps == null
                        ? 0
                        : steps == null
                            ? 0
                            : (steps / (ncal / 0.0912))*0.7,
                    context: context,
//              steps: dataHome['NumberOfSteps'] ?? 0,
                    steps: calories == null
                        ? 0
                        : steps == null ? 0 :steps,
                    raduis: _chartRadius,
                    onTap: () => null,
                    footerText: " Step " +
                        "${(ncal / 0.0912).toInt()} :" +
                        allTranslations.text("Goal is")),
              ),
              new LayoutId(
                id: 4,
                child: MainCircles.distance(
                    percent: distance== null
                        ? 0
                        : distance == null
                            ? 0
                            :distance /
                                (((ncal / 0.0912) * 0.762) ~/ 2)*0.7,
                    context: context,
                    raduis: _chartRadius,
                    distance: distance == null
                        ? '0'
                        : distance == null
                            ? '0'
                            : distance.toString(),
                    onTap: () => null,
                    footerText: " meter " +
                        "${(((ncal/ 0.0912) * 0.762) / 2).toInt()} :" +
                        allTranslations.text("Goal is")),
              )
              
            ],
          );
  
  
  
  }

}
