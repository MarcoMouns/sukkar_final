import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'languages/all_translations.dart';

class CirclesChoiceScreen extends StatefulWidget {
  @override
  _CirclesChoiceScreenState createState() => _CirclesChoiceScreenState();
}

class _CirclesChoiceScreenState extends State<CirclesChoiceScreen> {
  bool calories = false;
  bool water = false;
  bool heartRate = false;
  bool steps = false;
  bool distance = false;
  bool bloodPressure = false;
  bool finish = false;
  List<bool> finished = [false, false, false];

  int index1;
  int index2;
  int index3;
  int index4;
  int index5;
  int index6;
  int counter = 0;
  int selectednumber = 0;

  Widget w1 = Container(
    width: 50,
    height: 50,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: Colors.grey, width: 2),
    ),
  );
  Widget w2 = Container(
    width: 50,
    height: 50,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: Colors.grey, width: 2),
    ),
  );
  Widget w3 = Container(
    width: 50,
    height: 50,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: Colors.grey, width: 2),
    ),
  );
  Widget w4 = Container(
    width: 50,
    height: 50,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: Colors.grey, width: 2),
    ),
  );
  Widget w5 = Container(
    width: 50,
    height: 50,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: Colors.grey, width: 2),
    ),
  );
  Widget w6 = Container(
    width: 50,
    height: 50,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: Colors.grey, width: 2),
    ),
  );
  Widget check = Container(
    width: 50,
    height: 50,
    alignment: Alignment.center,
    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
    child: Icon(
      Icons.check,
      color: Colors.white,
      size: 30,
    ),
  );
  Widget notcheck = Container(
    width: 50,
    height: 50,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: Colors.grey, width: 2),
    ),
  );

  void isChecked1(bool x) {
    x
        ? w1 = Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.red),
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 30,
            ),
          )
        : w1 = Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey, width: 2),
            ),
          );
    x ? selectednumber++ : selectednumber--;
    setState(() {});
  }

  void isChecked2(bool x) {
    x
        ? w2 = Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.red),
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 30,
            ),
          )
        : w2 = Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey, width: 2)),
          );
    x ? selectednumber++ : selectednumber--;
    setState(() {});
  }

  void isChecked3(bool x) {
    x
        ? w3 = Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.red),
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 30,
            ),
          )
        : w3 = Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey, width: 2)),
          );
    x ? selectednumber++ : selectednumber--;
    setState(() {});
  }

  void isChecked4(bool x) {
    x
        ? w4 = Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.red),
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 30,
            ),
          )
        : w4 = Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey, width: 2)),
          );
    x ? selectednumber++ : selectednumber--;
    setState(() {});
  }

  void isChecked5(bool x) {
    x
        ? w5 = Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.red),
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 30,
            ),
          )
        : w5 = Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey, width: 2)),
          );
    x ? selectednumber++ : selectednumber--;
    setState(() {});
  }

  void isChecked6(bool x) {
    x
        ? w6 = Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.red),
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 30,
            ),
          )
        : w6 = Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey, width: 2)),
          );
    x ? selectednumber++ : selectednumber--;
    setState(() {});
  }

  bool isFinished() {
    for (int i = 0; i <= 2; i++) {
      if (finished[i] == false) {
        finish = false;
        break;
      } else {
        finish = true;
      }
    }
    setState(() {});
    return finish;
  }

  int checkEmptyPlaces() {
    for (int i = 0; i <= 2; i++) {
      if (finished[i] == false) {
        return i;
      }
    }
  }
 Response response;
    Dio dio = new Dio();
  void sendData() async {
   

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, dynamic> authUser =
        jsonDecode(sharedPreferences.getString("authUser"));
    var headers = {
      "Authorization": "Bearer ${authUser['authToken']}",
    };
    FormData formdata = new FormData();
    formdata.add('calorie', 0);
    formdata.add('steps', 0);
    formdata.add('distance', 1);
    formdata.add('water', 1);
    formdata.add('heart', 1);
    formdata.add('blood', 0);
    formdata.add('ـmethod', "PUT");

    response = await dio.post("104.248.168.117/api/users/circles",
        data: formdata,
        options: Options(
          headers: headers,
          method: 'PUT'
        ));

    print(response.data);
  }

  Future _showDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("من فضلك اختر ثلاث دوائر"),
            content: Text("لقد اخترت " +
                "$selectednumber" +
                " تبقى " +
                "${3 - selectednumber}"),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(allTranslations.text("changeCircles")),
          centerTitle: true,
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 10)),
                ListTile(
                  title: Row(
                    children: <Widget>[
                      SizedBox(
                          height: 50,
                          width: 50,
                          child: Image.asset('assets/icons/ic_cal.png')),
                      Padding(padding: EdgeInsets.only(right: 15)),
                      Text(allTranslations.text("Changecircle_calories"))
                    ],
                  ),
                  trailing: isFinished() == true && calories == false
                      ? notcheck
                      : isFinished() == true && calories == true ? check : w1,
                  onTap: () {
                    if (isFinished() == true && calories == true) {
                      calories = false;
                      isChecked1(calories);
                      counter = index1;
                      finished[index1] = false;
                      isFinished();
                    } else if (isFinished() == true) {
                      return null;
                    } else {
                      calories = !calories;
                      if (calories == true) {
                        index1 = counter;
                        isChecked1(calories);
                        finished[index1] = true;
                        counter = checkEmptyPlaces();
                        isFinished();
                      } else {
                        isChecked1(calories);
                        counter = index1;
                        finished[index1] = false;
                        isFinished();
                      }
                    }
                    setState(() {});
                  },
//                  trailing: Container(
//                    width: 50,
//                    height: 50,
//                    alignment: Alignment.center,
//                    decoration: BoxDecoration(
//                        shape: BoxShape.circle, color: Colors.red),
//                    child: Icon(
//                      Icons.check,
//                      color: Colors.white,
//                      size: 30,
//                    ),
//                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Divider(
                    thickness: 0.7,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                ListTile(
                  title: Row(
                    children: <Widget>[
                      SizedBox(
                          height: 50,
                          width: 50,
                          child: Image.asset('assets/icons/ic_cup.png')),
                      Padding(padding: EdgeInsets.only(right: 15)),
                      Text(allTranslations.text("Changecircle_Water"))
                    ],
                  ),
                  trailing: isFinished() == true && water == false
                      ? notcheck
                      : isFinished() == true && water == true ? check : w2,
                  onTap: () {
                    if (isFinished() == true && water == true) {
                      water = false;
                      isChecked2(water);
                      counter = index2;
                      finished[index2] = false;
                      isFinished();
                    } else if (isFinished() == true) {
                      return null;
                    } else {
                      water = !water;
                      if (water == true) {
                        index2 = counter;
                        isChecked2(water);
                        finished[index2] = true;
                        counter = checkEmptyPlaces();
                        isFinished();
                      } else {
                        isChecked2(water);
                        counter = index2;
                        finished[index2] = false;
                        isFinished();
                      }
                    }
                    setState(() {});
                  },
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Divider(
                    thickness: 0.7,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                ListTile(
                  title: Row(
                    children: <Widget>[
                      SizedBox(
                          height: 50,
                          width: 50,
                          child: Image.asset('assets/icons/ic_heart_rate.png')),
                      Padding(padding: EdgeInsets.only(right: 15)),
                      Text(allTranslations.text("Changecircle_HeartBeat"))
                    ],
                  ),
                  trailing: isFinished() == true && heartRate == false
                      ? notcheck
                      : isFinished() == true && heartRate == true ? check : w3,
                  onTap: () {
                    if (isFinished() == true && heartRate == true) {
                      heartRate = false;
                      isChecked3(heartRate);
                      counter = index3;
                      finished[index3] = false;
                      isFinished();
                    } else if (isFinished() == true) {
                      return null;
                    } else {
                      heartRate = !heartRate;
                      if (heartRate == true) {
                        index3 = counter;
                        isChecked3(heartRate);
                        finished[index3] = true;
                        counter = checkEmptyPlaces();
                        isFinished();
                      } else {
                        isChecked3(heartRate);
                        counter = index3;
                        finished[index3] = false;
                        isFinished();
                      }
                    }
                    setState(() {});
                  },
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Divider(
                    thickness: 0.7,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                ListTile(
                  title: Row(
                    children: <Widget>[
                      SizedBox(
                          height: 50,
                          width: 50,
                          child: Image.asset('assets/icons/ic_steps.png')),
                      Padding(padding: EdgeInsets.only(right: 15)),
                      Text(allTranslations.text("Changecircle_Steps"))
                    ],
                  ),
                  trailing: isFinished() == true && steps == false
                      ? notcheck
                      : isFinished() == true && steps == true ? check : w4,
                  onTap: () {
                    if (isFinished() == true && steps == true) {
                      steps = false;
                      isChecked4(steps);
                      counter = index4;
                      finished[index4] = false;
                      isFinished();
                    } else if (isFinished() == true) {
                      return null;
                    } else {
                      steps = !steps;
                      if (steps == true) {
                        index4 = counter;
                        isChecked4(steps);
                        finished[index4] = true;
                        counter = checkEmptyPlaces();
                        isFinished();
                      } else {
                        isChecked4(steps);
                        counter = index4;
                        finished[index4] = false;
                        isFinished();
                      }
                    }
                    setState(() {});
                  },
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Divider(
                    thickness: 0.7,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                ListTile(
                  title: Row(
                    children: <Widget>[
                      SizedBox(
                          height: 50,
                          width: 50,
                          child: Image.asset('assets/icons/ic_location.png')),
                      Padding(padding: EdgeInsets.only(right: 15)),
                      Text(allTranslations.text("Changecircle_dictance"))
                    ],
                  ),
                  trailing: isFinished() == true && distance == false
                      ? notcheck
                      : isFinished() == true && distance == true ? check : w5,
                  onTap: () {
                    if (isFinished() == true && distance == true) {
                      distance = false;
                      isChecked5(distance);
                      counter = index5;
                      finished[index5] = false;
                      isFinished();
                    } else if (isFinished() == true) {
                      return null;
                    } else {
                      distance = !distance;
                      if (distance == true) {
                        index5 = counter;
                        isChecked5(distance);
                        finished[index5] = true;
                        counter = checkEmptyPlaces();
                        isFinished();
                      } else {
                        isChecked5(distance);
                        counter = index5;
                        finished[index5] = false;
                        isFinished();
                      }
                    }
                    setState(() {});
                  },
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Divider(
                    thickness: 0.7,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                ListTile(
                  title: Row(
                    children: <Widget>[
                      SizedBox(
                          height: 50,
                          width: 50,
                          child: Image.asset(
                              'assets/icons/ic_blood_pressure.png')),
                      Padding(padding: EdgeInsets.only(right: 15)),
                      Text(allTranslations.text("Changecircle_presure"))
                    ],
                  ),
                  trailing: isFinished() == true && bloodPressure == false
                      ? notcheck
                      : isFinished() == true && bloodPressure == true
                          ? check
                          : w6,
                  onTap: () {
                    if (isFinished() == true && bloodPressure == true) {
                      bloodPressure = false;
                      isChecked6(bloodPressure);
                      counter = index6;
                      finished[index6] = false;
                      isFinished();
                    } else if (isFinished() == true) {
                      return null;
                    } else {
                      bloodPressure = !bloodPressure;
                      if (bloodPressure == true) {
                        index6 = counter;
                        isChecked6(bloodPressure);
                        finished[index6] = true;
                        counter = checkEmptyPlaces();
                        isFinished();
                      } else {
                        isChecked6(bloodPressure);
                        counter = index6;
                        finished[index6] = false;
                        isFinished();
                      }
                    }
                    setState(() {});
                  },
                ),
                Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top)),
                InkWell(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.6,
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
                    if (isFinished()) {
                      sendData();
                    } else {
                      _showDialog();
                    }
                  },
                )
              ],
            ),
          ),
        ));
  }
}
