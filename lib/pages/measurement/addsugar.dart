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

import '../home.dart';

class AddSugar extends StatefulWidget {
  static DateTime date;
  FormData formData =  new FormData();
  AddSugar([DateTime d]) {
    date = d;
  }

  @override
  _AddSugarState createState() => _AddSugarState();
}

class _AddSugarState extends State<AddSugar> {
  DateTime date = AddSugar.date;
  String dateString;
  _AddSugarState();

  initState() {
    super.initState();
    _getTime();
    dateString = '${date.year}-${date.month}-${date.day}';
    getMeasurementsForDay(dateString);
  }

  List<Sugar> _sugar = List();
  String now = "";

  List<Widget> measuresOfDayList = new List();
  List<int> measuresOfDay = new List();

  MeasurementsScopedModel model;
  _getTime() async {
    now = intl.DateFormat("yyyy MMM dd", allTranslations.locale.languageCode)
        .format(date);
    setState(() {});
  }
  

  Response response;
  Dio dio = new Dio();



  Future<Response> addNewMeasurement(String date,var suger) async {
    Response response;

    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      Map<String, dynamic> authUser =
          jsonDecode(sharedPreferences.getString("authUser"));
      var headers = {
        "Authorization": "Bearer ${authUser['authToken']}",
      };
      print(suger);
      print(date);
    var response = await dio.post("$baseUrl/measurements/sugar?sugar=$suger&?date=$date",
         options: Options(headers: headers));
          print(response.data);
          getMeasurementsForDay(date);
          
    } catch (e) {
      print("error =====================");
    }

    return response;
  }


  Future<Response> getMeasurementsForDay(String date) async {
    Response response;

    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      Map<String, dynamic> authUser =
          jsonDecode(sharedPreferences.getString("authUser"));
      var headers = {
        "Authorization": "Bearer ${authUser['authToken']}",
      };
      response = await dio.get("$baseUrl/measurements?date=$date",
          options: Options(headers: headers));
      print("response=$response.data.toString()");
      print("==================================");
      print("response=$response.data.toString()");
      //measuresOfDay = response.data["Measurements"]["sugar"];
      if(measuresOfDay.isNotEmpty){
        measuresOfDay.clear();
      }
      for (var i = 0; i < 3; i++) {
        measuresOfDay.add(response.data["Measurements"]["sugar"][i]);
        print(measuresOfDay);
      }


      print(measuresOfDay);
      setState(() {});
    } catch (e) {
      print("error =====================");
    }

    return response;
  }

  Future<Response> deleteMeasurements(String date, int val) async {
    Response response;

    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      Map<String, dynamic> authUser =
          jsonDecode(sharedPreferences.getString("authUser"));
      var headers = {
        "Authorization": "Bearer ${authUser['authToken']}",
      };
      response = await dio.delete(
          "$baseUrl/measurements/sugar?date=$date&sugar=$val",
          options: Options(headers: headers));
      print("response=$response.data.toString()");
      print("==================================");
      print("response=$response.data.toString()");

      setState(() {});
    } catch (e) {
      print("error =====================");
    }

    return response;
  }

  

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: allTranslations.currentLanguage == "ar"
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
               Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MainHome()));
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
                          color: Colors.blue,
                          width: 50,
                          height: 50,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30, bottom: 40),
                        child: Text(
                          allTranslations.text("measure sugar bla bla bla bla"),
                          style:
                              TextStyle(color: Colors.blueGrey, fontSize: 17),
                        ),
                      ),
                     Center(
                       child:  Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          InkWell(
                            
                            child: Center(
                              child: Container(
                                  width: MediaQuery.of(context).size.width/3,
                                  height: 60,
                                  //padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                                  child: Center(
                                    child: Text(
                                    allTranslations.text("measure"),
                                    textAlign: TextAlign.center,
                                  ),
                                  ),
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Colors.grey[300], width: 1.5),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
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
                                  max: 600.0);
                            },
                          ),
                          Container(
                            width: 20,
                          ),
                          InkWell(
                            child: Container(
                              width: MediaQuery.of(context).size.width/3,
                              height: 60,

                              //padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                              child: Center(
                                child: Text(
                                allTranslations.text("measure2"),
                                textAlign: TextAlign.center,
                              ),
                              ),
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.grey[300], width: 1.5),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                            onTap: () {},
                          ),
                        ],
                      ),
                     ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Column(
                            children: listOfSuger(),
                            ),
                      )
                    ],
                  ),
                ),
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
                
                setState(() {
                  getMeasurementsForDay(dateString);
                });
              });
        });
  }

  List<Widget> listOfSuger() {
    print("0000000000000");
    List<Widget> list = new List();
     print("0000000000000");
    for (var i = 0; i < measuresOfDay.length; i++) {
     
      if (measuresOfDay[i] == 0) {
         print("0000000000000${measuresOfDay[i]}");
        list.add(Container());
      } else {
        list.add(
          ListTile(
              title: Text(
                measuresOfDay[i].toString(),
                style: TextStyle(color: Colors.blue[300], fontSize: 20),
              ),
              subtitle: Text(
                "",
                style: TextStyle(fontSize: 13, color: Colors.blueGrey),
              ),
              trailing: InkWell(
                child: ImageIcon(
                  AssetImage("assets/icons/ic_trash.png"),
                  color: Colors.red,
                ),
                onTap: () {
                  
                  deleteMeasurements(dateString, measuresOfDay[i]);
                  measuresOfDay.remove(measuresOfDay[i]);

                  setState(() {});
                },
              )),
        );
      }
    }

    return list;
  }

  void _handleSubmitted(
      BuildContext context, MainModel model, var value, String type) {
    
      addNewMeasurement(dateString,"$value");
      setState(() {
        
      });
 
    
  }
}
