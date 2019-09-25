import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health/scoped_models/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MeasurementsPage extends StatefulWidget {
  
  final MainModel model;

  MeasurementsPage({this.model});

  @override
  State<StatefulWidget> createState() {
    return _MeasurementsPageState();
  }
}

class _MeasurementsPageState extends State<MeasurementsPage> {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: <Widget>[
          Row(
            children: <Widget>[
              // RaisedButton(
              //   onPressed: (){
              //     getMeasurements();
              //   },
              // ),
               CircleAvatar(
                radius: MediaQuery.of(context).size.width/6,
                 child: Icon( Icons.add),
               ),
               Container(),
                CircleAvatar(
                  radius: MediaQuery.of(context).size.width/6,
                 child: Icon( Icons.add , color: Colors.black,),
               )
            ],
          ),
          //ListView()
        ],
      ) ,
     
    );
  }


Dio dio = new Dio();
final String baseUrl = 'http://104.248.168.117/api';
  Future<void> getMeasurements() async {
    //String currentDate = DateTime.now() as String ;
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      Map<String, dynamic> authUser =
          jsonDecode(sharedPreferences.getString("authUser"));
             var headers = {
        "Authorization": "Bearer ${authUser['authToken']}",
      };
      var response = await dio.get("$baseUrl/measurements/sugarReads?date=2019-09-01",options:  Options(headers: authUser));
      print("response=$response");
   
      
      //print("http://104.248.168.117/api/measurements/sugarReads?date=2019-09-01");
      print("==================================================================");
      // var data = response.data['week'];
      // //var data = jsonDecode(response.data);
      print("response=$response");
      //print(currentDate);
      //print(data);
  
  }


  
}