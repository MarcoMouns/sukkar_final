import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:health/helpers/color_transform.dart';
import 'package:health/languages/all_translations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared-data.dart';
import '../Settings.dart';
import 'complete.dart';

class EditProfileUser extends StatefulWidget {
  @override
  EditProfileUserState createState() => EditProfileUserState();
}

class EditProfileUserState extends State<EditProfileUser> {
  final _formKey = GlobalKey<FormState>();
  bool firstLoad = true;
  bool hasPhoto = true;
  bool picdone = false;
  String gender;
  File profilePicture;
  Response response;
  Dio dio = new Dio();
  String phoneNum;
  String email;
  String birthDate;
  String name;
  TextEditingController _injuryDateController = TextEditingController();

  String img;
  final String baseUrl = 'http://104.248.168.117/api';

  Future<Response> getMeasurements(String date1) async {
    Response response;

    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      Map<String, dynamic> authUser =
          jsonDecode(sharedPreferences.getString("authUser"));
      var headers = {
        "Authorization": "Bearer ${authUser['authToken']}",
      };

      response = await dio.get("$baseUrl/measurements/sugarReads?date=$date1",
          options: Options(headers: headers));

      List<dynamic> date = new List();
      List<dynamic> suger = new List();

      for (int i = 0; i <= 6; i++) {
        date.add(response.data['week'][i]['date']);

        var holder = [0, 0, 0];
        for (var j = 0; j < 3; j++) {
          holder[j] = response.data['week'][i]['sugar'][j]['sugar'];
        }
        suger.add(holder);
      }

      setState(() {});
    } catch (e) {
      print("error =====================");
    }

    print('++++++++++++++++++++++++++++++++++from here we end the GETCAL');
    return response;
  }

  void _getImage(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(source: source, maxWidth: 400.0).then((File image) {
      setState(() {
        profilePicture = image;
        img = image.path;
        print('********************************');
        print(img);
        print('********************************');
      });
      picdone = true;
      Navigator.pop(context);
    });
  }

  void _imagePicker(BuildContext context) {
    hasPhoto = true;
    Locale myLocale = Localizations.localeOf(context);
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            cancelButton: CupertinoButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: <Widget>[
              CupertinoButton(
                child: Row(
                  children: <Widget>[
                    Icon(CupertinoIcons.photo_camera_solid),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      myLocale.languageCode.contains("en")
                          ? 'Camera'
                          : 'الكاميرا',
                      style: TextStyle(
                        color: Color(getColorHexFromStr("#444444")),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                onPressed: () => _getImage(context, ImageSource.camera),
              ),
              CupertinoButton(
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.insert_photo,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      myLocale.languageCode.contains("en")
                          ? 'Gallery'
                          : 'الاستديو',
                      style: TextStyle(
                        color: Color(getColorHexFromStr("#444444")),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                onPressed: () => _getImage(context, ImageSource.gallery),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: allTranslations.currentLanguage == "ar"
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(
            title: Text(allTranslations.text("editProfile")),
          ),
          body: ListView(
            children: <Widget>[editProfileForm(context)],
          ),
        ));
  }

  Widget editProfileForm(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: () => _imagePicker(context),
              child: CircleAvatar(
                radius: 45.0,
                backgroundColor: Settings.mainColor(),
                backgroundImage: profilePicture == 'Null' ||
                        profilePicture == null
                    ? NetworkImage(
                        'https://i.pinimg.com/originals/7c/c7/a6/7cc7a630624d20f7797cb4c8e93c09c1.png')
                    : NetworkImage(
                        'http://104.248.168.117${SharedData.customerData['image']}'),
              ),
            ),
            LogInInput(
              autoValidate: true,
              enabled: true,
              name: "username",
              keyboard: TextInputType.text,
              onSaved: (String val) {
                setState(() {
                  name = val;
                  print(val);
                });
              },
              validator: (String val) {
                if (val.isEmpty && firstLoad == false) {
                  return myLocale.languageCode.contains("en")
                      ? "userName is required."
                      : "اسم المستخدم مطلوب";
                }
              },
            ),
            //////////////////////////////////////////
            ///      Email

            LogInInput(
              autoValidate: true,
              enabled: true,
              name: "email",
              keyboard: TextInputType.emailAddress,
              onSaved: (String val) {
                setState(() {
                  email = val;
                });
              },
              validator: (String val) {
                Pattern pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regex = new RegExp(pattern);
                if (!regex.hasMatch(val) && firstLoad == false)
                  return myLocale.languageCode.contains("en")
                      ? "Not Valid Email."
                      : "البريد الالكترونى غير صحيح.";
                else
                  return null;
              },
            ),
            //////////////////////////////////////////
            ///      Mobile Number
            LogInInput(
              
              enabled: true,
              autoValidate: true,
              name: "mobilePhone",
              validator: (String val) {
                if (val.isEmpty && firstLoad == false) {
                  return myLocale.languageCode.contains("en")
                      ? "Phone number is required"
                      : "رقم الجوال مطلوب";
                }
              },
              onSaved: (String val) {
                setState(() {
                  phoneNum = val;
                });
              },
              keyboard: TextInputType.numberWithOptions(
                  decimal: false, signed: false),
            ),
            InkWell(
              onTap: () {
                DatePicker.showDatePicker(context,
                    showTitleActions: true,
                    minTime: DateTime(1900, 3, 5),
                    maxTime: DateTime(2030, 6, 7), onChanged: (date) {
                  _injuryDateController.text = date.toString();
                  print('change $date');
                }, onConfirm: (date) {
                  _injuryDateController.text = date.toString();
                  print('confirm $date');
                },
                    currentTime: DateTime.now(),
                    locale: myLocale.languageCode.contains("en")
                        ? LocaleType.en
                        : LocaleType.ar);
              },
              child: LogInInput(
                enabled: false,
                autoValidate: true,
                name: "birthDate",
                keyboard: TextInputType.datetime,
                onSaved: (String val) {
                  setState(() {
                    birthDate = val;
                  });
                },
                validator: (String val) {
                  if (val.isEmpty && firstLoad == false) {
                    return myLocale.languageCode.contains("en")
                        ? "injury Date is required."
                        : " تاريخ الاصابة مطلوب";
                  }
                },
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child: Row(
                  children: <Widget>[
                    Radio(
                      activeColor: Colors.redAccent,
                      onChanged: (val) {
                        setState(() {
                          gender = val;
                        });
                      },
                      value: 'male',
                      groupValue: gender,
                    ),
                    Text(allTranslations.text("male"))
                  ],
                )),
                Expanded(
                    child: Row(
                  children: <Widget>[
                    Radio(
                      activeColor: Colors.redAccent,
                      onChanged: (val) {
                        setState(() {
                          gender = val;
                        });
                      },
                      value: 'female',
                      groupValue: gender,
                    ),
                    Text(allTranslations.text("female"))
                  ],
                ))
              ],
            ),

            FlatButton(
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              child: Text(
                allTranslations.text("save"),
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
