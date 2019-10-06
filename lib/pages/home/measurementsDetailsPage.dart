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
import '../../omar.dart';
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

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        
        children: [
          // Row(
          //   children: <Widget>[
          //    SizedBox(
          //      width: 100,
          //      height: 100,
          //      child: omar(),
          //    ),
          //     SizedBox(
          //      width: 100,
          //      height: 100,
          //      child: omar(),
          //    )
          //    ,
          //     SizedBox(
          //      width: 100,
          //      height: 100,
          //      child: omar(),
          //    )
          //    ,
              
             
          //   ],
          // ),
          //  Row(
          //   children: <Widget>[
          //    SizedBox(
          //      width: 100,
          //      height: 100,
          //      child: omar(),
          //    ),
          //     SizedBox(
          //      width: 100,
          //      height: 100,
          //      child: omar(),
          //    )
          //    ,
          //     SizedBox(
          //      width: 100,
          //      height: 100,
          //      child: omar(),
          //    )
          //    ,
              
             
          //   ],
          // ),
        ],
      ), 
        
      
    );
       
 
    
  
}


}
