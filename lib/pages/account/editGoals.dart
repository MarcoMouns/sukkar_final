import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health/languages/all_translations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home.dart';

class EditGoalsScreen extends StatefulWidget {
  @override
  EditGoalsScreenState createState() => EditGoalsScreenState();
}

class EditGoalsScreenState extends State<EditGoalsScreen> {
  int waterGoal = 0;
  int calGoal = 0;
  int stepsGoal = 0;
  int distanceGoal = 0;
  bool isLoading = true;
  bool isAutoMatic = true;
  bool isdisabled = false;
  String iconRemainingName = "_gray";
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
    response = await dio.get("$baseUrl/measurements/goals",
        options: Options(headers: headers));
    waterGoal = response.data['goals']['water_cups_goal'];
    distanceGoal = response.data['goals']['distance_goal'];
    calGoal = response.data['goals']['calorie_goal'];
    stepsGoal = response.data['goals']['steps_goal'];
    isAutoMatic = response.data['isAutomatically'];
    
    isdisabled = !isAutoMatic;
    iconRemainingName = isAutoMatic? "_gray" : "";
    setState(() {});
    isLoading = false;
    return response;
  }

  Future<Response> setGoals() async {
    Response response;
    int isAuto = isAutoMatic ? 1 :0;

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, dynamic> authUser =
        jsonDecode(sharedPreferences.getString("authUser"));
    var headers = {
      "Authorization": "Bearer ${authUser['authToken']}",
    };
    response = await dio.post(
        "$baseUrl/measurements/goals?steps_goal=$stepsGoal&calorie_goal=$calGoal&distance_goal=$distanceGoal&water_cups_goal=$waterGoal&isAutomatically=$isAuto",
        options: Options(headers: headers));

    return response;
  }

  initState() {
    super.initState();
    getCurrentGoals();
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
                        child: Image.asset(
                            "assets/icons/ic_cup$iconRemainingName.png",
                            fit: BoxFit.scaleDown)),
                    Padding(padding: EdgeInsets.only(right: 15)),
                    Text(allTranslations.text("cups")),
                  ],
                ),
                trailing: SizedBox(
                  height: 50,
                  width: 50,
                  child: TextFormField(
                    enabled: isdisabled,
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
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
                        child: Image.asset(
                            "assets/icons/ic_cal$iconRemainingName.png",
                            fit: BoxFit.scaleDown)),
                    Padding(padding: EdgeInsets.only(right: 15)),
                    Text(allTranslations.text("cals")),
                  ],
                ),
                trailing: SizedBox(
                  height: 50,
                  width: 50,
                  child: TextFormField(
                    enabled: isdisabled,
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
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
                      child: Image.asset(
                          "assets/icons/ic_steps$iconRemainingName.png",
                          fit: BoxFit.scaleDown),
                    ),
                    Padding(padding: EdgeInsets.only(right: 15)),
                    Text(allTranslations.text("steps")),
                  ],
                ),
                trailing: SizedBox(
                  height: 50,
                  width: 50,
                  child: TextFormField(
                    enabled: isdisabled,
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
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
                      child: Image.asset(
                          "assets/icons/ic_location$iconRemainingName.png",
                          fit: BoxFit.scaleDown),
                    ),
                    Padding(padding: EdgeInsets.only(right: 15)),
                    Text(allTranslations.text("distance")),
                  ],
                ),
                trailing: SizedBox(
                  height: 50,
                  width: 50,
                  child: TextFormField(
                    enabled: isdisabled,
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      distanceGoal = int.parse(val);
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
              MergeSemantics(
                child: ListTile(
                  title: Row(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(right: 15)),
                      Text(allTranslations.text("isAuto")),
                    ],
                  ),
                  trailing: CupertinoSwitch(
                    value: isAutoMatic,
                    onChanged: (bool value) {
                      setState(() {
                         isAutoMatic = !isAutoMatic;
                        isdisabled = !isdisabled;
                        iconRemainingName = isAutoMatic ? "_gray" : "";
                        setState(() {
                          
                        });
                      });
                    },
                  ),
                  onTap: () {
                    setState(() {
                      isAutoMatic = !isAutoMatic;
                    });
                  },
                ),
              ),
              Padding(
                  padding:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top)),
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
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => MainHome()));
                },
              )
            ],
          ),
        ));
  }
}
