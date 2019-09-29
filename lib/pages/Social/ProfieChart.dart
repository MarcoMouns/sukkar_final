import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:health/Models/friends_tab/getMeasureFriends.dart';
import 'package:health/helpers/loading.dart';
import 'package:health/scoped_models/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home/MainCircle/Circles.dart';
import 'package:health/pages/Settings.dart';
import 'package:health/languages/all_translations.dart';

class ProfileChart extends StatefulWidget {
  final bool isMyProfile;
  final String date;
  final String name;
  final String image;
  final int userId;
  final MainModel model;

  ProfileChart(
      {this.isMyProfile = false,
      this.date,
      this.model,
      this.userId,
      this.name,
      this.image});

  @override
  _ProfileChartState createState() => _ProfileChartState();
}

class _ProfileChartState extends State<ProfileChart> {
  Response response;
  Dio dio = new Dio();
  final String baseUrl = 'http://104.248.168.117/api';
  List measure = List();
  bool loading;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //widget.userId
    getMeasureFriends();
  }

  getMeasureFriends() async {
    loading = true;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, dynamic> authUser =
        jsonDecode(sharedPreferences.getString("authUser"));

    dio.options.headers = {
      "Authorization": "Bearer ${authUser['authToken']}",
      // "token":"11215"
    };

    response =
        await dio.post("$baseUrl/get_friend_information", data: {'user_id': 8});
    print("$baseUrl/getfollowing");

    print('data = > \n ${response.data['Measurements']}');
    setState(() {
      measure.add(response.data['Measurements']);
      loading = false;
    });
    print(measure[0]['NumberOfSteps']);
    if (response.statusCode != 200 && response.statusCode != 201) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    double raduis = MediaQuery.of(context).size.width / 2 <
            MediaQuery.of(context).size.height - (120 + 23 + 14 + 10)
        ? MediaQuery.of(context).size.width / 2
        : MediaQuery.of(context).size.height - (120 + 23 + 14 + 10);
    return Directionality(
        textDirection: allTranslations.currentLanguage == "ar"
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Scaffold(
            backgroundColor: Color.fromRGBO(250, 251, 255, 1),
            body: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    UpperBarProfile(
                        height: 120,
                        title: widget.name.toString(),
                        subTitle: widget.date == ""
                            ? ""
                            : "1/1 " + allTranslations.text("الأحد"),
                        image: Image.network(widget.image == 'Null' ||widget.image == null
                            ? 'https://i.pinimg.com/originals/7c/c7/a6/7cc7a630624d20f7797cb4c8e93c09c1.png'
                            : 'http://104.248.168.117/${widget.image}')),
//                    measurements == null
//                        ? new Text('No result')
//                        :
                   new Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: MainCircles.cups(
                                              context: context,
                                              text: measure[0]['water_cups']
                                                  .toString(),
                                              raduis: raduis),
                                        ),
                                        Align(
                                          alignment: Alignment.topCenter,
                                          child: MainCircles.bloodPreassure(
                                              text: measure[0][
                                                          'SystolicPressure'] ==
                                                      null
                                                  ? '0'
                                                  : measure[0]
                                                          ['SystolicPressure']
                                                      .toString(),
                                              context: context,
                                              raduis: raduis),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: MainCircles.heartRate(
                                              text: measure[0]['Heartbeat'] ==
                                                      null
                                                  ? '0'
                                                  : measure[0]['Heartbeat']
                                                      .toString(),
                                              context: context,
                                              raduis: raduis),
                                        )
                                      ],
                                    ),
                                  ),
                                  MainCircles.diabetes(
                                      context: context,
                                      raduis: raduis,
                                      footer: Text(
                                        allTranslations.text("measure sugar"),
                                      ),
                                      sugar: measure[0]['sugar'] == null
                                          ? '0'
                                          : measure[0]['sugar'].toString(),
                                      ontap: () {}),
//                            Expanded(
//                                child: Row(
//                              mainAxisAlignment: MainAxisAlignment.spaceAround,
//                              children: <Widget>[
//                                Align(
//                                  child: MainCircles.cal(
//                                      context: context, raduis: raduis),alignment: Alignment.topCenter,
//                                ),
//                                Align(alignment: Alignment.bottomCenter,
//                                  child: MainCircles.steps(
//                                      context: context, raduis: raduis),
//                                ),
//                                Align(alignment: Alignment.topCenter,
//                                  child: MainCircles.distance(
//                                      context: context, raduis: raduis),
//                                )
//                              ],
//                            ))
                                ],
                              ),
                            ),
                          )
                  ],
                ),
//                Positioned(
//                    top: 135,
//                    right: allTranslations.currentLanguage != "ar" ? 30 : null,
//                    left: allTranslations.currentLanguage != "ar" ? null : 30,
//                    child: InkWell(
//                     highlightColor: Colors.transparent,
//                     splashColor: Colors.transparent,
//                      child: Image.asset(
//                        "assets/icons/ic_remove_friend.png",
//                        width: 60,
//                      ),
//                      onTap: () {},
//                    ))
              ],
            )));
  }
}
