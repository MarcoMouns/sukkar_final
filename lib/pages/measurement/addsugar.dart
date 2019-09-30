import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:health/Models/sugar.dart';
import 'package:health/languages/all_translations.dart';
import 'package:health/scoped_models/main.dart';
import 'package:health/scoped_models/measurements.dart';
import 'package:intl/intl.dart' as intl;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:health/pages/Settings.dart' as settings;


class AddSugar extends StatefulWidget {
  static DateTime date;

  AddSugar([DateTime d ]){
    date = d;
  }


  @override
  _AddSugarState createState() => _AddSugarState();
}

class _AddSugarState extends State<AddSugar> {
  
  DateTime date = AddSugar.date;
  _AddSugarState();

  void initState() {
    _getDummySleepingTime();
    _getTime();
    super.initState();
    getMeasurements();
  }

  List<Sugar> _sugar = List();
  String now = "";
  MeasurementsScopedModel model;
  _getTime() async {
    now = intl.DateFormat("yyyy MMM dd", allTranslations.locale.languageCode)
        .format(date);
    setState(() {});
  }

  Response response;
  Dio dio = new Dio();
  Future<Response> getMeasurements() async {
    Response response;
    
     try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      Map<String, dynamic> authUser =
          jsonDecode(sharedPreferences.getString("authUser"));
    var headers = {
        "Authorization": "Bearer ${authUser['authToken']}",
      };
     response = await dio.get("$baseUrl/measurements/",options:  Options(headers: headers));
      print("response=$response.data.toString()");
      print("==================================");
      print("response=$response.data.toString()");
      
      }
      catch(e){
        print("error =====================");
      }
      
      return response;
  
  }

  

  _getDummySleepingTime() {
    _sugar.add(Sugar(count: 80, date: "7aba w shoia"));
    // _sleepingTime.add(SleepTime(duration: "hours", time: "7aba w shoia"));
    // _sleepingTime.add(SleepTime(duration: "hours", time: "7aba w shoia"));
    // _sleepingTime.add(SleepTime(duration: "hours", time: "7aba w shoia"));
    //  _sleepingTime.add(SleepTime(duration: "hours", time: "7aba w shoia"));
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: allTranslations.currentLanguage == "ar"
          ? TextDirection.rtl
          : TextDirection.ltr,
      child:Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(allTranslations.text("sugar")),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      now,
                      style: TextStyle(color: Colors.red, fontSize: 25.0),
                    ),
                    // subtitle: Text(
                    //   intl.DateFormat("h:m a",allTranslations.locale.languageCode).format(DateTime.now()),
                    //   style: TextStyle(color: Colors.red),
                    // ),
                    trailing: Image.asset(
                      "assets/icons/ic_logo_3.png",
                      color: Colors.blue,width: 50,height: 50,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30, bottom: 40),
                    child: Text(
                      allTranslations.text("measure sugar bla bla bla bla"),
                      style: TextStyle(color: Colors.blueGrey, fontSize: 17),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                          child: Text(
                            allTranslations.text("measure"),
                            textAlign: TextAlign.center,
                          ),
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Colors.grey[300], width: 1.5),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        onTap: () {
                          _showBottomSheet(
                             context: context,
                             model: model,
                             type: 'sugar',
                             title: "measure sugar",
                             subTitle: "enterTodaySugar",
                             imageName: "ic_blood_pressure",
                             min: 0.0,
                             max: 600.0
                          );

                        },
                      ),
                     
                     Container(
                       width: 10,
                     ),
                     InkWell(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                          child: Text(
                            allTranslations.text("measure"),
                            textAlign: TextAlign.center,
                          ),
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Colors.grey[300], width: 1.5),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        onTap: () {
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Column(
                        children: _sugar.map((sugar) {
                      return Column(
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              sugar.count.toString(),
                              style: TextStyle(
                                  color: Colors.blue[300], fontSize: 20),
                            ),
                            subtitle: Text(
                              sugar.date,
                              style: TextStyle(
                                  fontSize: 13, color: Colors.blueGrey),
                            ),
                            trailing: InkWell(
                              child: ImageIcon(AssetImage("assets/icons/ic_trash.png"),color: Colors.red,),
                              onTap: (){
                                _sugar.remove(sugar);
                         
                                setState(() {
                                  
                                });
                              },
                            ),
                          ),
                          Divider(
                            height: 16,
                            color: Colors.blueGrey,
                          )
                        ],
                      );
                    }).toList()),
                  )
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.5,
              child: FlatButton(
                color: Color(0xff009DDC),
                child: Text(
                  allTranslations.text("save"),
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      ),
    ));
  }


  _showBottomSheet(
      {BuildContext context,
      MainModel model,
      String title,
      String type,
      String subTitle,
      String imageName,
      double min,
      double max}) async {
    await showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return settings.BottomSheet(
              title: title,
              subtitle: subTitle,
              image: imageName,
              min: min,
              max: max,
              addSlider: true,
              onSave: (String value) {
                _handleSubmitted(context, model, value, type);
              });
        });
  }

    void _handleSubmitted(
      BuildContext context, MainModel model, var value, String type) {
    model.addMeasurements(type, value).then((result) async {
//      print(result);
    });
  }

}
