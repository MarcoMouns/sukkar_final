import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:health/languages/all_translations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class editGoalsScreen extends StatefulWidget {
  @override
  editGoalsScreenState createState() => editGoalsScreenState();
}

class editGoalsScreenState extends State<editGoalsScreen> {
  int waterGoal;
  int calGoal;
  int stepsGoal;
  int distanceGoal;
  bool isLoading = true;
  Dio dio = new Dio();

  final String baseUrl = 'http://api.sukar.co/api';

  Future<Response> getCurrentGoals() async {
    Response response;

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, dynamic> authUser =
        jsonDecode(sharedPreferences.getString("authUser"));
    var headers = {
      "Authorization": "Bearer ${authUser['authToken']}",
    };
    response =
        await dio.get("$baseUrl/auth/me", options: Options(headers: headers));

    isLoading = false;
    return response;
  }




    Future<Response> setGoals() async {
    Response response;

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, dynamic> authUser =
        jsonDecode(sharedPreferences.getString("authUser"));
    var headers = {
      "Authorization": "Bearer ${authUser['authToken']}",
    };
    response =
        await dio.get("$baseUrl/auth/me", options: Options(headers: headers));

    isLoading = false;
    return response;
  }

  initState() {
    super.initState();
    //getCurrentGoals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(allTranslations.text("editGoal")),
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 10)),
              ListTile(
                title: Row(
                  children: <Widget>[
                    SizedBox(
                        height: 50,
                        width: 50,
                        child: Image.asset("assets/icons/ic_cup.png",
                            fit: BoxFit.scaleDown)),
                    Padding(padding: EdgeInsets.only(right: 15)),
                    Text(allTranslations.text("cups")),
                  ],
                ),
                trailing: SizedBox(
                  height: 50,
                  width: 50,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (val){
                      waterGoal = int.parse(val);
                    },
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Divider(
                  thickness: 0.7,
                ),
              ),
              ListTile(
                title: Row(
                  children: <Widget>[
                    SizedBox(
                        height: 50,
                        width: 50,
                        child: Image.asset("assets/icons/ic_cal.png",
                            fit: BoxFit.scaleDown)),
                    Padding(padding: EdgeInsets.only(right: 15)),
                    Text(allTranslations.text("cals")),
                  ],
                ),
                trailing: SizedBox(
                  height: 50,
                  width: 50,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (val){
                      calGoal = int.parse(val);
                    },
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Divider(
                  thickness: 0.7,
                ),
              ),
              ListTile(
                title: Row(
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: Image.asset("assets/icons/ic_steps.png",
                          fit: BoxFit.scaleDown),
                    ),
                    Padding(padding: EdgeInsets.only(right: 15)),
                    Text(allTranslations.text("steps")),
                  ],
                ),
                trailing: SizedBox(
                  height: 50,
                  width: 50,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (val){
                      stepsGoal = int.parse(val);
                    },
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Divider(
                  thickness: 0.7,
                ),
              ),
              ListTile(
                title: Row(
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: Image.asset("assets/icons/ic_location.png",
                          fit: BoxFit.scaleDown),
                    ),
                    Padding(padding: EdgeInsets.only(right: 15)),
                    Text(allTranslations.text("distance")),
                  ],
                ),
                trailing: SizedBox(
                  height: 50,
                  width: 50,
                  child: TextField(
                   keyboardType: TextInputType.number,
                    onChanged: (val){
                      distanceGoal = int.parse(val);
                    },
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top)),
              InkWell(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.07,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  alignment: Alignment.center,
                  child: Text(
                    "حفظ",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                onTap: () {
                  setGoals();
                },
              )
            ],
          ),
        ));
  }
}
