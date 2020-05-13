import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:health/pages/Settings.dart';
import 'package:health/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'languages/all_translations.dart';

class CirclesChoiceScreen extends StatefulWidget {
  @override
  _CirclesChoiceScreenState createState() => _CirclesChoiceScreenState();
}

class _CirclesChoiceScreenState extends State<CirclesChoiceScreen> {
  bool o1 = false;
  bool o2 = false;
  bool o3 = false;
  bool o4 = false;
  bool o5 = false;
  bool o6= false;
  bool finish = false;
  List<bool> finished = [false, false, false];

  int calorie=0;
  int water=0;
  int heart=0;
  int steps=0;
  int distance=0;
  int blood=0;

  int index1;
  int index2;
  int index3;
  int index4;
  int index5;
  int index6;

  int counter = 0;
  int selectednumber=0;


  Widget w1= Container(
    width: 50,
    height: 50,
    decoration: BoxDecoration(
        shape: BoxShape.circle, border: Border.all(color: Colors.grey,width: 2),),
  );
  Widget w2= Container(
    width: 50,
    height: 50,
    decoration: BoxDecoration(
        shape: BoxShape.circle, border: Border.all(color: Colors.grey,width: 2),),
  );
  Widget w3= Container(
    width: 50,
    height: 50,
    decoration: BoxDecoration(
        shape: BoxShape.circle, border: Border.all(color: Colors.grey,width: 2),),
  );
  Widget w4= Container(
    width: 50,
    height: 50,
    decoration: BoxDecoration(
        shape: BoxShape.circle, border: Border.all(color: Colors.grey,width: 2),),
  );
  Widget w5= Container(
    width: 50,
    height: 50,
    decoration: BoxDecoration(
        shape: BoxShape.circle, border: Border.all(color: Colors.grey,width: 2),),
  );
  Widget w6= Container(
    width: 50,
    height: 50,
    decoration: BoxDecoration(
        shape: BoxShape.circle, border: Border.all(color: Colors.grey,width: 2),),
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
        shape: BoxShape.circle, border: Border.all(color: Colors.grey,width: 2),),
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
                shape: BoxShape.circle, border: Border.all(color: Colors.grey,width: 2),),
          );
    x?selectednumber++:selectednumber--;
    setState(() {

    });
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
                shape: BoxShape.circle, border: Border.all(color: Colors.grey,width: 2)),
          );
    x?selectednumber++:selectednumber--;
    setState(() {

    });
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
                shape: BoxShape.circle, border: Border.all(color: Colors.grey,width: 2)),
          );
    x?selectednumber++:selectednumber--;
    setState(() {

    });
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
                shape: BoxShape.circle, border: Border.all(color: Colors.grey,width: 2)),
          );
    x?selectednumber++:selectednumber--;
    setState(() {

    });
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
                shape: BoxShape.circle, border: Border.all(color: Colors.grey,width: 2)),
          );
    x?selectednumber++:selectednumber--;
    setState(() {

    });
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
          shape: BoxShape.circle, border: Border.all(color: Colors.grey,width: 2)),
    );
    x?selectednumber++:selectednumber--;
    setState(() {

    });
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
    setState(() {

    });
    return finish;
  }

  int checkEmptyPlaces() {
    for (int i = 0; i <= 2; i++) {
      if (finished[i] == false) {
        return i;
      }
    }
  }

  void changeToInt(){
    if(o1==true){
      calorie=1;
    }
    if(o2==true){
      water=1;
    }
    if(o3==true){
      heart=1;
    }
    if(o4==true){
      steps=1;
    }
    if(o5==true){
      distance=1;
    }
    if(o6==true){
      blood=1;
    }
    setState(() {});
  }

  void sendData() async {
    Response response;
    Dio dio = new Dio();
    FormData _formData;
    _formData = FormData.fromMap({
      "calorie": calorie,
      "steps": steps,
      "distance": distance,
      "water": water,
      "heart": heart,
      "blood": blood,
    });

    SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    Map<String, dynamic> authUser =
    jsonDecode(sharedPreferences.getString("authUser"));
    var headers = {
      "Authorization": "Bearer ${authUser['authToken']}",
    };

    try{
      response = await dio.post(
          "${Settings.baseApilink}/users/circles",
          data: _formData,
          options: Options(headers: headers));

      if(response.statusCode==201){
        print('nag7naaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
      }
      else{
        print('shiiiiiiiiiiiiiiiiiiiiiiiiiiiiiit');
      }
    }
    catch(e){
      print(e);
    }


  }

  

  Future _errorShowDialog(){
    return showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("من فضلك اختر ثلاث دوائر"),
          content:
              Text("لقد اخترت "+"$selectednumber"+" تبقى "+"${3-selectednumber}"),
        );
      }
    );
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
                  trailing: isFinished() == true && o1 == false
                      ? notcheck
                      : isFinished() == true && o1 == true ? check : w1,
                  onTap: () {
                    if (isFinished() == true && o1 == true) {
                      o1 = false;
                      isChecked1(o1);
                      counter = index1;
                      finished[index1] = false;
                      isFinished();
                    } else if (isFinished() == true) {
                      return null;
                    } else {
                      o1 = !o1;
                      if (o1 == true) {
                        index1 = counter;
                        isChecked1(o1);
                        finished[index1] = true;
                        counter = checkEmptyPlaces();
                        isFinished();
                      } else {
                        isChecked1(o1);
                        counter = index1;
                        finished[index1] = false;
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
                          child: Image.asset('assets/icons/ic_cup.png')),
                      Padding(padding: EdgeInsets.only(right: 15)),
                      Text(allTranslations.text("Changecircle_Water"))
                    ],
                  ),
                  trailing: isFinished() == true && o2 == false
                      ? notcheck
                      : isFinished() == true && o2 == true ? check : w2,
                  onTap: () {
                    if (isFinished() == true && o2 == true) {
                      o2 = false;
                      isChecked2(o2);
                      counter = index2;
                      finished[index2] = false;
                      isFinished();
                    } else if (isFinished() == true) {
                      return null;
                    } else {
                      o2 = !o2;
                      if (o2 == true) {
                        index2 = counter;
                        isChecked2(o2);
                        finished[index2] = true;
                        counter = checkEmptyPlaces();
                        isFinished();
                      } else {
                        isChecked2(o2);
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
                  trailing: isFinished() == true && o3 == false
                      ? notcheck
                      : isFinished() == true && o3 == true ? check : w3,
                  onTap: () {
                    if (isFinished() == true && o3 == true) {
                      o3 = false;
                      isChecked3(o3);
                      counter = index3;
                      finished[index3] = false;
                      isFinished();
                    } else if (isFinished() == true) {
                      return null;
                    } else {
                      o3 = !o3;
                      if (o3 == true) {
                        index3 = counter;
                        isChecked3(o3);
                        finished[index3] = true;
                        counter = checkEmptyPlaces();
                        isFinished();
                      } else {
                        isChecked3(o3);
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
                  trailing: isFinished() == true && o4 == false
                      ? notcheck
                      : isFinished() == true && o4 == true ? check : w4,
                  onTap: () {
                    if (isFinished() == true && o4 == true) {
                      o4 = false;
                      isChecked4(o4);
                      counter = index4;
                      finished[index4] = false;
                      isFinished();
                    } else if (isFinished() == true) {
                      return null;
                    } else {
                      o4 = !o4;
                      if (o4 == true) {
                        index4 = counter;
                        isChecked4(o4);
                        finished[index4] = true;
                        counter = checkEmptyPlaces();
                        isFinished();
                      } else {
                        isChecked4(o4);
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
                  trailing: isFinished() == true && o5 == false
                      ? notcheck
                      : isFinished() == true && o5 == true ? check : w5,
                  onTap: () {
                    if (isFinished() == true && o5 == true) {
                      o5 = false;
                      isChecked5(o5);
                      counter = index5;
                      finished[index5] = false;
                      isFinished();
                    } else if (isFinished() == true) {
                      return null;
                    } else {
                      o5 = !o5;
                      if (o5 == true) {
                        index5 = counter;
                        isChecked5(o5);
                        finished[index5] = true;
                        counter = checkEmptyPlaces();
                        isFinished();
                      } else {
                        isChecked5(o5);
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
                  trailing: isFinished() == true && o6 == false
                      ? notcheck
                      : isFinished() == true && o6 == true ? check : w6,
                  onTap: () {
                    if (isFinished() == true && o6 == true) {
                      o6 = false;
                      isChecked6(o6);
                      counter = index6;
                      finished[index6] = false;
                      isFinished();
                    } else if (isFinished() == true) {
                      return null;
                    } else {
                      o6 = !o6;
                      if (o6 == true) {
                        index6 = counter;
                        isChecked6(o6);
                        finished[index6] = true;
                        counter = checkEmptyPlaces();
                        isFinished();
                      } else {
                        isChecked6(o6);
                        counter = index6;
                        finished[index6] = false;
                        isFinished();
                      }
                    }
                    setState(() {});
                  },
                ),
                Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top)),
                InkWell(
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.6,
                    height: MediaQuery.of(context).size.height*0.07,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    alignment: Alignment.center,
                    child: Text("حفظ",style: TextStyle(color: Colors.white,fontSize: 20),),
                  ),
                  onTap: () {
                    if(isFinished()){
                      changeToInt();
                      sendData();
                       Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => MainHome()));
                    }
                    else{
                      _errorShowDialog();
                    }
                  },
                )
              ],
            ),
          ),
        ));
  }
}
