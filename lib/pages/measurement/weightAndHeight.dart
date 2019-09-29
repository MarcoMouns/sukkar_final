import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:health/languages/all_translations.dart';
import "package:after_layout/after_layout.dart";
import 'package:intl/intl.dart' as prefix0;
import 'package:shared_preferences/shared_preferences.dart';

class WeightAndHeight extends StatefulWidget {
  @override
  _WeightAndHeightState createState() => _WeightAndHeightState();
}

class _WeightAndHeightState extends State<WeightAndHeight>
    with AfterLayoutMixin {
  FocusNode _focusNode1 = FocusNode();
  FocusNode _focusNode2 = FocusNode();

  //---------------

  double screenHeiget;

  double drawingHeigth;

  int userHeight = 90;
  String userWidth ;
  Response response;
  Dio dio = new Dio();

  @override
  void afterFirstLayout(BuildContext context) {
    setState(() {
      screenHeiget = MediaQuery.of(context).size.height - 200;
      print("screenHeight $screenHeiget");
      drawingHeigth = screenHeiget - 40;
    });
  }

  double get _pixelsPerUnit {
    return drawingHeigth / 101;
  }

  double get _sliderPosition {
    double halfOfBottomLabel = 11.5;
    int unitsFromBottom = userHeight - 90;
    return halfOfBottomLabel + unitsFromBottom * _pixelsPerUnit;
  }

  //-----------

  TextEditingController _heightController;
  void initState() {
    super.initState();
    _heightController = TextEditingController();
    _heightController.addListener(() {
//_range=ratio*double.parse(_heightController.text)+90;
      setState(() {});
    });
  }

  Widget _drawSlider() {
    return Positioned(
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Row(
            // mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                width: 5,
              ),
              Container(
                width: 75,
                height: 1,
                color: Colors.blue,
              ),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
          Positioned(
            right: 110,
            bottom: 0.0,
            child: Text(
              "$userHeight",
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
      left: 0.0,
      right: 0.0,
      bottom: _sliderPosition,
    );
  }

  Widget isEven() {
    return Container(
      // alignment: Alignment.centerRight,
      width: 40,
      height: 3,
      color: Colors.grey,
    );
  }

  Widget isOdd() {
    return Container(
      // alignment: Alignment.centerRight,
      width: 25,
      height: 3,
      color: Colors.grey,
    );
  }

  Widget isOther() {
    return Container(
      // alignment: Alignment.centerRight,
      width: 15,
      height: 3,
      color: Colors.grey,
    );
  }

  Widget _drawLabels() {
    List<Widget> labels = List.generate(
      // labelsToDisplay,
      101,
          (idx) {
        // print(idx);
        if (idx == 100) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              isEven(),
            ],
          );
        } else if (idx % 10 == 0) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              isEven(),
            ],
          );
        } else if (idx % 5 == 0) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              isOdd(),
            ],
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              isOther(),
            ],
          );
        }
      },
    );

    return Align(
      alignment: Alignment.centerRight,
      child: IgnorePointer(
        child: Padding(
          padding: EdgeInsets.only(
            right: 0.0,
            bottom: 20,
            top: 20,
          ),
          child: Column(
            children: labels,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenHeiget = MediaQuery.of(context).size.height;
    return Directionality(
        textDirection: allTranslations.currentLanguage == "ar"
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: GestureDetector(
            onTap: () {
              _focusNode1.unfocus();
              _focusNode2.unfocus();
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(allTranslations.text("weight and height")),
              ),
              body: ListView(
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Center(
                        child: Container(
                          height: MediaQuery.of(context).size.height - 200,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: GestureDetector(
                            onVerticalDragUpdate: (DragUpdateDetails drag) {
                              print("----------- ${drag.delta.dy}");
                              if (drag.delta.dy > 0 && userHeight > 90) {
                                setState(() {
                                  userHeight--;
                                });
                              } else if (drag.delta.dy < 0 &&
                                  userHeight < 190) {
                                setState(() {
                                  userHeight++;
                                });
                              }

                              _heightController.text = userHeight.toString();

                              print("user height $userHeight");
                            },
                            child: Stack(
                              children: <Widget>[
                                _drawLabels(),
                                _drawSlider(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 20),
                            alignment: Alignment.center,
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: <Widget>[
                                SizedBox(
                                  width: 100,
                                  child: TextField(
                                    focusNode: _focusNode1,
                                    controller: _heightController,
                                    textDirection: TextDirection.ltr,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                                Text(
                                  allTranslations.text("heigh"),
                                  style: TextStyle(color: Colors.blue[400]),
                                )
                              ],
                            ),
                          ),
                          Image.asset(
                            "assets/icons/ic_body.png",
                            height: MediaQuery.of(context).size.height - 400,
                            fit: BoxFit.fitHeight,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  "assets/icons/ic_circle_min.png",
                                  height: 25,
                                  width: 25,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Stack(
                                    alignment: Alignment.bottomRight,
                                    children: <Widget>[
                                      SizedBox(
                                        width: 100,
                                        child: TextField(
                                          focusNode: _focusNode2,
                                          textDirection: TextDirection.ltr,
                                          keyboardType: TextInputType.number,
                                          onChanged:  (String v){
                                            userWidth = v;
                                            print('weight $v');
                                          },
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 25,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        allTranslations.text("Weight"),
                                        style:
                                        TextStyle(color: Colors.blue[400]),
                                      ),
                                    ],
                                  ),
                                ),
                                Image.asset(
                                  "assets/icons/ic_circle_add.png",
                                  height: 25,
                                  width: 25,
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 0,
                        height: 0,
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width / 7,
                        20,
                        MediaQuery.of(context).size.width / 7,
                        20),
                    child: FlatButton(
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Text(
                        allTranslations.text("Add"),
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async{
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        try {
                          int cal= (66 + (6.2 * int.parse(userWidth)) + (12.7 * userHeight) - (6.76 * 25)).toInt();
                          prefs.setInt('ncal', cal);
                          print('***********************************************');
                          print(cal);
                          print('***********************************************');
                          // get user token
                          SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                          Map<String, dynamic> authUser = jsonDecode(
                              sharedPreferences.getString("authUser"));
                          dio.options.headers = {
                            "Authorization":
                            "Bearer ${authUser['authToken']}",
                          };

                          response = await dio.post(
                              "http://104.248.168.117/api/users/height-weight",data: {
                            "_method": 'PUT',
                            "height": userHeight,
                            "weight": userWidth.toString()
                          });
                          print('Response = ${response.data}');
                          Navigator.of(context).pop();
                        } on DioError catch (e) {
                          print(
                              "errrrrrrrrrrrrrrrrrrroooooooorrrrrrrrr");
                          print(e.response.data);
                          return false;
                        }
                        return true;
                      },
                    ),
                  )
                ],
              ),
            )));
  }
}
