import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:health/languages/all_translations.dart';
import 'package:health/pages/bluetooth/bluetoothDevice.dart';
import 'package:health/scoped_models/main.dart';
import 'package:health/scoped_models/measurements.dart';
import 'package:intl/intl.dart' as intl;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:health/pages/Settings.dart' as settings;

import '../home.dart';

class AddSugar extends StatefulWidget {
  static DateTime date;
  FormData formData = new FormData();
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
  String initSuger;

  initState() {
    super.initState();
    _getTime();
    dateString = '${date.year}-${date.month}-${date.day}';
    getMeasurementsForDay(dateString);
  }

  String now = "";

  List<Widget> measuresOfDayList = new List();
  List<dynamic> measuresOfDay = new List();
  List<dynamic> timeOfMeasures = new List();

  MeasurementsScopedModel model;
  _getTime() async {
    now = intl.DateFormat("yyyy MMM dd", allTranslations.locale.languageCode)
        .format(date);
    setState(() {});
  }

  Response response;
  Dio dio = new Dio();

  Future<Response> addNewMeasurement(String date, var suger) async {
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
      var now = new DateTime.now();
      var formatter = new intl.DateFormat('hh:mm a');
      String formatted = formatter.format(now);
      var response = await dio.post(
          "$baseUrl/measurements/sugar?sugar=$suger&date=$date&time=$formatted",
          options: Options(headers: headers));
      print("$baseUrl/measurements/sugar?sugar=$suger&date=$date");
      //print(response.data);
      getMeasurementsForDay(dateString);
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

      if (measuresOfDay.isNotEmpty) {
        measuresOfDay.clear();
        timeOfMeasures.clear();
      }
      for (var i = 0; i < 3; i++) {
        measuresOfDay.add(response.data["Measurements"]["sugar"][i]["sugar"]);
        timeOfMeasures.add(response.data["Measurements"]["sugar"][i]["time"]);
        print(measuresOfDay);
      }

      print(measuresOfDay);
      setState(() {});
    } catch (e) {
      print("error =====================");
    }

    return response;
  }

  Future<Response> deleteMeasurements(String date, int val, String time) async {
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
          "$baseUrl/measurements/sugar?date=$date&sugar=$val&time=$time",
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
          title: Text(allTranslations.text("sugar")),
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => MainHome()));
            },
          ),
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
                        style: TextStyle(color: Colors.blueGrey, fontSize: 17),
                      ),
                    ),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          InkWell(
                            child: Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width / 3,
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
                              width: MediaQuery.of(context).size.width / 3,
                              height: 60,
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
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        BlueToothDevice(model)),
                              );
                            },
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
      ),
    );
  }

  Future<void> _ackAlert(BuildContext context) async {
    return await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('نتيجة القياس'),
          content: int.parse(initSuger) >= 70 && int.parse(initSuger) < 90
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "السكر لديك معدلاته اقل من الطبيعي",
                        style: TextStyle(
                          color: Colors.green,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      Text("تعرف على اعراض هبوط السكر:"),
                      Text("1-" +
                          " تعرف على اعراض هبوط السكر مثل(الدوخة ,التعرق , الخفقان, الدوار , الجوع الشديد , الرعشة"),
                      Text("2-" +
                          " لا تقم بممارسة اي مجهود رياضي الا بعد تناول وجبة خفيفة"),
                      Text("3-" +
                          " احمل معك قطعة من الحلوى تناولها في حال الاحساس بأعراض الهبوط"),
                    ],
                  ),
                )
              : int.parse(initSuger) >= 90 && int.parse(initSuger) <= 200
                  ? Text(
                      "مستوى السكر لديك بالمعدل الطبيعي واصل اهتمامك قياس السكر",
                      style: TextStyle(color: Colors.green),
                      textAlign: TextAlign.center,
                    )
                  : int.parse(initSuger)> 200
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height * 0.27,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "انتبه مستوى السكر لديك مرتفع",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Padding(padding: EdgeInsets.only(top: 10)),
                              Text("عليك إتباع النصائح التالية:"),
                              Text("1-" + " المحافظة على نظام صحي غذائى."),
                              Text("2-" + " ممارسة الرياضة بانتظام."),
                              Text("3-" + " الالتزام بتناول أدوية السكر."),
                              Text("4-" + " مراجعة عيادة السكري بشكل دوري."),
                              Text("5-" + " قياس السكر باستمرار."),
                            ],
                          ),
                        )
                      : SizedBox(
                          height: MediaQuery.of(context).size.height * 0.35,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "انتبه مستوى السكر لديك منخفض",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Padding(padding: EdgeInsets.only(top: 10)),
                              Text("عليك إتباع النصائح التالية:"),
                              Text("1-" +
                                  " تعرف على أعراض هبوط السكر مثل ( الدوخه ، التعرق ، الخفقان ، الدوار ، الجوع الشدٌد ، الرعشة ) "),
                              Text("2-" +
                                  " لاتقم بممارسة أي مجهود رياضة إلا بعد تناول وجبة خفيفة."),
                              Text("3-" +
                                  " احمل معك قطعة من الحلوى ، تناولها فى حالة الاحساس بأعراض الهبوط ."),
                            ],
                          ),
                        ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Ok',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                initSuger = null;
              },
            ),
          ],
        );
      },
    );
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
                initSuger = null;
                _handleSubmitted(context, model, value, type);
                setState(() {
                  getMeasurementsForDay(dateString);
                  initSuger = value;
                });
                return value;
              });
        }).then((v) {
      Timer(Duration(seconds: 1), () {
          print(initSuger);
         if(initSuger  != null)
         { _ackAlert(context);}
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
              title: RichText(
                text: new TextSpan(
                  // Note: Styles for TextSpans must be explicitly defined.
                  // Child text spans will inherit styles from parent
                  style: new TextStyle(color: Colors.blue[300], fontSize: 20),
                  children: <TextSpan>[
                    new TextSpan(
                        text: measuresOfDay[i].toString(),
                        style: new TextStyle(fontWeight: FontWeight.bold)),
                    new TextSpan(
                        text: ' mg/dl', style: new TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              subtitle: Text(
                timeOfMeasures[i].toString(),
                style: TextStyle(fontSize: 13, color: Colors.blueGrey),
              ),
              trailing: InkWell(
                child: ImageIcon(
                  AssetImage("assets/icons/ic_trash.png"),
                  color: Colors.red,
                ),
                onTap: () {
                  deleteMeasurements(
                      dateString, measuresOfDay[i], timeOfMeasures[i]);
                  measuresOfDay.remove(measuresOfDay[i]);
                  timeOfMeasures.remove(timeOfMeasures[i]);

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
    addNewMeasurement(dateString, "$value");
    setState(() {});
  }
}
