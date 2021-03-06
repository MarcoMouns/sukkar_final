import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:health/height/card_title.dart';
import 'package:health/height/height_picker.dart';
import 'package:health/height/widget_utils.dart';
import 'package:health/languages/all_translations.dart';
import "package:after_layout/after_layout.dart";
import 'package:health/pages/Settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeightAndHeight extends StatefulWidget {
  @override
  _WeightAndHeightState createState() => _WeightAndHeightState();
}

class _WeightAndHeightState extends State<WeightAndHeight>
    with AfterLayoutMixin {
  FocusNode _focusNode1 = FocusNode();
  FocusNode _focusNode2 = FocusNode();


  double screenHeiget;

  double drawingHeigth;

  int height;
  String userWidth = '0';
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


  TextEditingController _heightController;
  void initState() {
    super.initState();
    height = height ?? 170;
    _heightController = TextEditingController();
    _heightController.addListener(() {
      setState(() {});
    });
  }

  Widget isEven() {
    return Container(
      width: 40,
      height: 3,
      color: Colors.grey,
    );
  }

  Widget isOdd() {
    return Container(
      width: 25,
      height: 3,
      color: Colors.grey,
    );
  }

  Widget isOther() {
    return Container(
      width: 15,
      height: 3,
      color: Colors.grey,
    );
  }


  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("تنبية"),
            content: Text("يرجى ادخال الوزن و الطول"),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "تم",
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
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
                //physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Center(
                        child: Container(
                          height: MediaQuery.of(context).size.height - 200,
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: Card(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: screenAwareSize(16.0, context)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    CardTitle("HEIGHT", subtitle: "(cm)"),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            bottom:
                                                screenAwareSize(8.0, context)),
                                        child: LayoutBuilder(
                                            builder: (context, constraints) {
                                          return HeightPicker(
                                            widgetHeight: constraints.maxHeight,
                                            height: height,
                                            onChange: (val) =>
                                                setState(() => height = val),
                                          );
                                        }),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
                                    onChanged: (value) {
                                      height = int.parse(value);
                                    },
                                    textDirection: TextDirection.ltr,
                                    keyboardType: TextInputType.number,
                                    maxLength: 3,
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

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Stack(
                                    alignment: Alignment.bottomRight,
                                    children: <Widget>[
                                      SizedBox(
                                        width: 100,
                                        child: TextField(
                                          maxLength: 3,
                                          focusNode: _focusNode2,
                                          textDirection: TextDirection.ltr,
                                          keyboardType: TextInputType.number,
                                          onChanged: (String v) {
                                            userWidth = v;
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
                      onPressed: () async {
                        if (userWidth.isEmpty || height == 90) {
                          _showDialog();
                        } else {
                          try {
                            int average_calorie = (66 +
                                    (6.2 * int.parse(userWidth)) +
                                    (12.7 * height) -
                                    (6.76 * 25))
                                .toInt();
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
                                "${Settings.baseApilink}/users/height-weight",
                                data: {
                                  "_method": 'PUT',
                                  "height": height,
                                  "weight": userWidth.toString(),
                                  "average_calorie": average_calorie,
                                });
                            Navigator.pop(context, true);
                          } on DioError catch (e) {
                            return false;
                          }
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
