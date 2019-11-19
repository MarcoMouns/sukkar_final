import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health/helpers/color_transform.dart';
import 'package:health/helpers/loading.dart';
import 'package:health/languages/all_translations.dart';
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
  TextEditingController nameCtrl = TextEditingController();

  String img;
  final String baseUrl = 'http://api.sukar.co/api';

  initState() {
    getUserInfo();
    super.initState();
  }

  Future<Response> getUserInfo() async {
    Response response;

    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      Map<String, dynamic> authUser =
          jsonDecode(sharedPreferences.getString("authUser"));
      var headers = {
        "Authorization": "Bearer ${authUser['authToken']}",
      };
      response =
          await dio.get("$baseUrl/auth/me", options: Options(headers: headers));
      //print(response.data);
      email = response.data['user']['email'];
      name = response.data['user']['name'];

      nameCtrl.text = name;
      print(email);
      isLoading = false;

      setState(() {});
    } catch (e) {
      print("error =====================");
    }

    print('++++++++++++++++++++++++++++++++++from here we end the GETCAL');
    return response;
  }

  Future<Response> upDateProfile() async {
    Response response;

    isLoading = true;
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      Map<String, dynamic> authUser =
          jsonDecode(sharedPreferences.getString("authUser"));
      var headers = {
        "Authorization": "Bearer ${authUser['authToken']}",
      };

      FormData formdata = new FormData();

      // var body = {
      //   "image":profilePicture,
      //   "email":email,
      //   "name":name,
      //   "password":"111111",
      // };
      formdata.add('name', name);
      formdata.add('email', email);
      formdata.add('password', password);
      formdata.add('_method', "PUT");

      if (profilePicture != null) {
        formdata.add(
          "image",
          UploadFileInfo(
            profilePicture,
            basename(profilePicture.path),
          ),
        );
      }

      response = await dio.post("$baseUrl/users/info",
          data: formdata,
          options: Options(
            headers: headers,
          ));
      SharedData.customerData['userName'] = response.data['user']['name'];
      SharedData.customerData['image'] = response.data['user']['image'];
      Map<String, dynamic> userUpdateJson;
      userUpdateJson = jsonDecode(sharedPreferences.getString("authUser"));
      userUpdateJson['image'] = SharedData.customerData['image'];
      userUpdateJson['phone'] = 19999;
      String a7a = jsonEncode(userUpdateJson);
      sharedPreferences.setString("authUser", a7a);
      userUpdateJson = jsonDecode(sharedPreferences.getString("authUser"));
      print('som malaf al JSON -> $userUpdateJson');
      print(SharedData.customerData['image']);
      print('88888888888888888888888888888888888888888888');
      print(response);

      print(email);
      isLoading = false;

      setState(() {});
    } catch (e) {
      isLoading = false;
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
                  //////////////////////////////////////////
                  ///      Email

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
                  TextFormField(
                    obscureText: true,
                    onChanged: (val) {
                      password = val;
                    },
                    validator: (String val) {
                      if (val.isEmpty) {
                        return myLocale.languageCode.contains("en")
                            ? "Phone number is required"
                            : "رقم الجوال مطلوب";
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

                  FlatButton(
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: Text(
                      allTranslations.text("save"),
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      upDateProfile();
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
