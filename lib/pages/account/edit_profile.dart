import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:health/helpers/color_transform.dart';
import 'package:health/helpers/loading.dart';
import 'package:health/languages/all_translations.dart';
import 'package:health/pages/Social/friends.dart';
import 'package:health/pages/home.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared-data.dart';
import '../Settings.dart';
import 'package:path/path.dart';

final snackBar = SnackBar(content: Text('Yay! A SnackBar!'));

class EditProfileUser extends StatefulWidget {
  @override
  EditProfileUserState createState() => EditProfileUserState();
}

class EditProfileUserState extends State<EditProfileUser> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = true;
  bool firstLoad = true;
  bool hasPhoto = true;
  bool picdone = false;

  File profilePicture;
  Response response;
  Dio dio = new Dio();

  String email;
  String name;
  String password;
  String injuryDate;
  String birthDate;
  dynamic gender;

  TextEditingController nameCtrl = TextEditingController();
  TextEditingController _injuryDateController = TextEditingController();
  TextEditingController _birthDateController = TextEditingController();

  String img;

  initState() {
    getUserInfo();
    super.initState();
  }

  Future<Response> getUserInfo() async {
    Response response;

    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      Map<String, dynamic> authUser1 =
          jsonDecode(sharedPreferences.getString("authUser"));
      var headers = {
        "Authorization": "Bearer ${authUser1['authToken']}",
      };
      response = await dio.get("${Settings.baseApilink}/auth/me",
          options: Options(headers: headers));
      email = response.data['user']['email'];
      name = response.data['user']['name'];
      nameCtrl.text = name;
      isLoading = false;

      setState(() {});
    } catch (e) {
      print("error ===================== $e");
    }

    return response;
  }

  Future<Response> upDateProfile() async {
    Response response;
    isLoading = true;
    setState(() {});
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      Map<String, dynamic> authUser2 =
          jsonDecode(sharedPreferences.getString("authUser"));
      var headers = {
        "Authorization": "Bearer ${authUser2['authToken']}",
      };
      
      FormData formdata = new FormData();
      if (name != null) {
        formdata.add('name', name);
      }

      if (email != null) {
        formdata.add('email', email);
      }

      if (password != null) {
        formdata.add('password', password);
      }

      if (gender != null) {
        formdata.add('gender', gender);
      }

      if (phone != null) {
        formdata.add('phone', phone);
      }

      if (birthDate != null) {
        formdata.add('birth_date', birthDate);
      }
      if (injuryDate != null) {
        formdata.add('injuredDate', injuryDate);
      }
      if (profilePicture != null) {
        formdata.add(
          'image',
          UploadFileInfo(
            profilePicture,
            basename(profilePicture.path),
          ),
        );
      }

      formdata.add('_method', "PUT");
      print(formdata.toString());

      print("loook hereee");
      response = await dio.post("${Settings.baseApilink}/users/info",
          data: formdata,
          options: Options(
            headers: headers,
          ));
      print("loook hereee");
      print(response.data);
      print("loook hereee");

      sharedPreferences = await SharedPreferences.getInstance();
      String authUser = jsonEncode({
        "authToken": authUser2['authToken'],
        "id": response.data['user']['id'],
        "search_code": response.data['user']['search_code'],
        "userName": response.data['user']['name'],
        "phone": response.data['user']['phone'],
        "email": response.data['user']['email'],
        "birthDate": response.data['user']['birth_date'],
        "injuredDate": response.data['user']['injuredDate'],
        "state": response.data['user']['state'],
        "image": response.data['user']['image'],
        "gender": response.data['user']['gender'],
        "height": response.data['user']['hight'],
        "weight": response.data['user']['weight'],
        "fuid": response.data['user']['fuid'],
        "average_calorie": response.data['user']['average_calorie'],
        "verified": response.data['user']['type'],
        "fcmToken": response.data['user']['token_id'],
      });

      sharedPreferences.setString("authUser", authUser);

      print(email);
      isLoading = false;

      setState(() {});
    } catch (e) {
      isLoading = false;
    }

    return response;
  }

  void _getImage(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(source: source, maxWidth: 400.0).then((File image) {
      setState(() {
        profilePicture = image;
        img = image.path;
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
    Widget page;
    Locale myLocale = Localizations.localeOf(context);
    isLoading == true
        ? page = Loading()
        : page = Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: () => _imagePicker(context),
                    child: CircleAvatar(
                      radius: 45.0,
                      backgroundColor: Settings.mainColor(),
                      backgroundImage: SharedData.customerData['image'] == null
                          ? NetworkImage(
                              'https://i.pinimg.com/originals/7c/c7/a6/7cc7a630624d20f7797cb4c8e93c09c1.png')
                          : profilePicture == null
                              ? NetworkImage(
                                  'http://api.sukar.co${SharedData.customerData['image']}')
                              : AssetImage(profilePicture.path),
                    ),
                  ),
                  TextFormField(
                    onChanged: (val) {
                      name = val;
                    },
                    initialValue: name,
                    decoration: InputDecoration(
                        labelText: myLocale.languageCode.contains("en")
                            ? "Name"
                            : "الاسم"),
                    enabled: true,
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (String val) {
                      setState(() {
                        name = val;
                        print(val);
                      });
                    },
                    validator: (String val) {
                      if (val.isEmpty) {
                        return myLocale.languageCode.contains("en")
                            ? "userName is required."
                            : "اسم المستخدم مطلوب";
                      }
                    },
                  ),
                  TextFormField(
                      onChanged: (val) {
                        email = val;
                      },
                      initialValue: email,
                      decoration: InputDecoration(
                          labelText: myLocale.languageCode.contains("en")
                              ? "Email"
                              : "البريد الالكتروني"),
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (String val) {
                        setState(() {
                          email = val;
                        });
                      },
                      validator: (String val) {
                        if (val.isEmpty) {
                          return myLocale.languageCode.contains("en")
                              ? "Phone number is required"
                              : "رقم الجوال مطلوب";
                        }
                        Pattern pattern =
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                        RegExp regex = new RegExp(pattern);
                        if (!regex.hasMatch(val))
                          return myLocale.languageCode.contains("en")
                              ? "Not Valid Email."
                              : "البريد الالكترونى غير صحيح.";
                        else
                          return null;
                      }),
                  TextFormField(
                      onChanged: (val) {
                        phone = val;
                      },
                      initialValue: email,
                      decoration: InputDecoration(
                          labelText: myLocale.languageCode.contains("en")
                              ? "phone"
                              : "رقم الهاتف"),
                      keyboardType: TextInputType.number,
                      onSaved: (String val) {
                        setState(() {
                          phone = val;
                        });
                      },
                      validator: (String val) {}),
                  TextFormField(
                    obscureText: true,
                    onChanged: (val) {
                      password = val;
                    },
                    validator: (String val) {
                      if (val.length < 8) {
                        return myLocale.languageCode.contains("en")
                            ? "invalid password"
                            : "كلمة مرور غبر صالحة";
                      }
                    },
                    onSaved: (String val) {
                      setState(() {
                        password = val;
                      });
                    },
                    decoration: InputDecoration(
                        labelText: myLocale.languageCode.contains("en")
                            ? "Password"
                            : "كلمة السر"),
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  new InkWell(
                    onTap: () {
                      DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          minTime: DateTime(1900, 3, 5),
                          maxTime: DateTime.now(), onChanged: (date) {
                        birthDate =
                            (date.toString()).split(" ")[0];
                      }, onConfirm: (date) {
                        birthDate =
                            (date.toString()).split(" ")[0];
                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                    },
                    child: LogInInput(
                      enabled: false,
                      controller: _birthDateController,
                      name: "birthDate",
                      keyboard: TextInputType.datetime,
                      autoValidate: false,
                      onSaved: (String val) {
                        setState(() {
                          birthDate = val;
                        });
                      },
                      validator: (String val) {},
                    ),
                  ),
                  new InkWell(
                    onTap: () {
                      DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          minTime: DateTime(1900, 3, 5),
                          maxTime: DateTime.now(), onChanged: (date) {
                        injuryDate =
                            date.toString().split(" ")[0];
                      }, onConfirm: (date) {
                        injuryDate=
                            date.toString().split(" ")[0];
                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                    },
                    child: LogInInput(
                      autoValidate: false,
                      enabled: false,
                      controller: _injuryDateController,
                      name: "injuryDate",
                      keyboard: TextInputType.datetime,
                      onSaved: (String val) {
                        setState(() {
                          injuryDate= val;
                        });
                      },
                      validator: (String val) {},
                    ),
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                          child: Row(
                        children: <Widget>[
                          Radio(
                            activeColor: Colors.redAccent,
                            onChanged: (val) {
                              setState(() {
                                gender = 1;
                              });
                            },
                            value: 1,
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
                                gender = 0;
                              });
                            },
                            value: 0,
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
                    onPressed: () async {
                      try {
                        await upDateProfile();
                      } catch (e) {
                        print(e);
                      }
                      SharedData.customerData['userName'] = name;
                      await getCustomerData();
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => MainHome()));
                    },
                  )
                ],
              ),
            ),
          );
    return page;
  }
}
