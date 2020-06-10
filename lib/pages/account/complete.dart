import 'dart:io';
import 'dart:math';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../helpers/color_transform.dart';
import '../../scoped_models/main.dart';
import 'package:health/pages/Settings.dart';
import '../../languages/all_translations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Complete extends StatefulWidget {
  final String phone;
  Complete(this.phone);
  _CompleteState createState() => _CompleteState();
}

class _CompleteState extends State<Complete> {
  dynamic _gender = 'male';
  FocusNode _focusNode1 = FocusNode();
  FocusNode _focusNode2 = FocusNode();
  FocusNode _focusNode3 = FocusNode();
  FocusNode _focusNode4 = FocusNode();
  FocusNode _focusNode5 = FocusNode();
  FocusNode _focusNode6 = FocusNode();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _injuryDateController = TextEditingController();
  TextEditingController _birthDateController = TextEditingController();
  bool _isLoading = false;
  bool _autoValidate = false;
  bool hasPhoto = true;
  bool picdone = false;
  bool isMatched = true;

  Map<String, dynamic> _formData = {
    "image": null,
    "phone": null,
    "userName": null,
    "email": null,
    "injuredDate": null,
    "birthDate": null,
    "gender": null,
    "password": null,
    "fuid": null,
  };

  @override
  void initState() {
    super.initState();
    setState(() {
      _formData['phone'] = widget.phone;
    });
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  String img;
  void _getImage(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(source: source, maxWidth: 400.0).then((File image) {
      setState(() {
        _formData['image'] = image;
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

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  SharedPreferences prefs;
  String uidx;

  static const chars = "abcdefghijklmnopqrstuvwxyz0123456789";
  String randomString(int strlen) {
    Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
    String result = "";
    for (var i = 0; i < strlen; i++) {
      result += chars[rnd.nextInt(chars.length)];
    }
    return result;
  }

  Future<String> createFirebaseAccount() async {
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      final FirebaseUser user =
          (await _firebaseAuth.createUserWithEmailAndPassword(
        email: _formData['email'] == null || _formData['email'] == ""
            ? "a${randomString(9)}@gmail.com"
            : _formData['email'],
        password: "11112222",
      ))
              .user;
      return user.uid;
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showInSnackBar("من فضلك قم بأدخال بريد اليكتروني صحيح");
    }
  }

  Future<Null> CreateCFSaccount(String uid) async {
    if (!_formKey.currentState.validate() || _formData['phone'] == null) {
      _autoValidate = true;
      showInSnackBar("من فضلك قم بتصحيح جميع الاخطاء اولا");
    } else {
      _formKey.currentState.save();
      setState(() {
        _isLoading = true;
      });
      Firestore.instance.collection('users').document(uid).setData({
        'nickname': _formData['userName'],
        'id': uid,
        'isDoctor': false,
        'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
        'chattingWith': null
      });

      prefs = await SharedPreferences.getInstance();
      await prefs.setString('Rid', uid);
      await prefs.setString('Rnickname', _formData['userName']);
    }
  }

  void _handleSubmitted(
    BuildContext context,
    MainModel model,
  ) {
    Locale myLocale = Localizations.localeOf(context);
//    final FormState form = _formKey.currentState;
    print(_formData);
    setState(() {
      _formData['gender'] = _gender == 'male' ? 1 : 0;
    });
    if (!_formKey.currentState.validate() || _formData['phone'] == null) {
      _autoValidate = true;

      showInSnackBar(myLocale.languageCode.contains("en")
          ? "Please fix errors before submit"
          : "من فضلك قم بتصحيح جميع الاخطاء اولا");
    } else {
      _formKey.currentState.save();
      setState(() {
        _isLoading = true;
      });
      model.userRegister(_formData).then((result) async {
        if (result == true) {
          setState(() {
            _isLoading = false;
          });

          await Navigator.of(context).pushNamedAndRemoveUntil(
              '/home', (Route<dynamic> route) => false);
        } else {
          setState(() {
            _isLoading = false;
          });
          showInSnackBar(myLocale.languageCode.contains("en")
              ? "The email has already been taken."
              : "البريد الالكترونى موجود مسبقا");
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);
    return Directionality(
        textDirection: allTranslations.currentLanguage == "ar"
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: GestureDetector(
          onTap: () {
            _focusNode1.unfocus();
            _focusNode2.unfocus();
            _focusNode3.unfocus();
            _focusNode4.unfocus();
            _focusNode5.unfocus();
            _focusNode6.unfocus();
          },
          child: Scaffold(
            key: _scaffoldKey,
            body: ScopedModelDescendant<MainModel>(
              builder: (BuildContext context, Widget child, MainModel model) {
                return Form(
                  key: _formKey,
                  child: Container(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: ListView(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(0.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 24,
                                    ),
                                    InkWell(
                                      onTap: () => _imagePicker(context),
                                      child: UserImage(_formData['image']),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Icon(Icons.close,
                                            color: Colors.grey),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              new LogInInput(
                                enabled: true,
                                name: "email",
                                autoValidate: _autoValidate,
                                keyboard: TextInputType.emailAddress,
                                focusNode: _focusNode2,
                                onSaved: (String val) {
                                  setState(() {
                                    _formData['email'] = val;
                                  });
                                },
                                validator: (String val) {
                                  if (val.isNotEmpty) {
                                    Pattern pattern =
                                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                    RegExp regex = new RegExp(pattern);
                                    if (!regex.hasMatch(val))
                                      return myLocale.languageCode
                                              .contains("en")
                                          ? "Not Valid Email."
                                          : "البريد الالكترونى غير صحيح.";
                                    else
                                      return null;
                                  }
                                },
                              ),
                              new InkWell(
                                onTap: () {
                                  DatePicker.showDatePicker(context,
                                      showTitleActions: true,
                                      minTime: DateTime(1900, 3, 5),
                                      maxTime: DateTime.now(),
                                      onChanged: (date) {
                                    _birthDateController.text =
                                        (date.toString()).split(" ")[0];
                                  }, onConfirm: (date) {
                                    _birthDateController.text =
                                        (date.toString()).split(" ")[0];
                                  },
                                      currentTime: DateTime.now(),
                                      locale: LocaleType.en);
                                },
                                child: LogInInput(
                                  enabled: false,
                                  controller: _birthDateController,
                                  autoValidate: _autoValidate,
                                  name: "birthDate",
                                  keyboard: TextInputType.datetime,
                                  focusNode: _focusNode6,
                                  onSaved: (String val) {
                                    setState(() {
                                      _formData['birthDate'] = val;
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
                                      maxTime: DateTime.now(),
                                      onChanged: (date) {
                                    _injuryDateController.text =
                                        date.toString().split(" ")[0];
                                  }, onConfirm: (date) {
                                    _injuryDateController.text =
                                        date.toString().split(" ")[0];
                                  },
                                      currentTime: DateTime.now(),
                                      locale: LocaleType.en);
                                },
                                child: LogInInput(
                                  enabled: false,
                                  controller: _injuryDateController,
                                  autoValidate: _autoValidate,
                                  name: "injuryDate",
                                  keyboard: TextInputType.datetime,
                                  focusNode: _focusNode3,
                                  onSaved: (String val) {
                                    setState(() {
                                      _formData['injuredDate'] = val;
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
                                            _gender = val;
                                          });
                                        },
                                        value: 'male',
                                        groupValue: _gender,
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
                                            _gender = val;
                                          });
                                        },
                                        value: 'female',
                                        groupValue: _gender,
                                      ),
                                      Text(allTranslations.text("female"))
                                    ],
                                  ))
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          //margin: MediaQuery.of(context).viewInsets,
                          padding: EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 30.0),
                          child: _isLoading
                              ? CupertinoActivityIndicator(
                                  animating: true,
                                  radius: 15,
                                )
                              : Column(
                                  children: <Widget>[
                                    RaisedButton(
                                        elevation: 0.0,
                                        color: Colors.grey,
                                        textColor: Colors.white,
                                        onPressed: () async {
                                          if (hasPhoto &&
                                              picdone &&
                                              isMatched == true) {
                                            uidx =
                                                await createFirebaseAccount();
                                            _formData['fuid'] = uidx;
                                            CreateCFSaccount(uidx);
                                            _handleSubmitted(
                                              context,
                                              model,
                                            );
                                          } else {
                                            hasPhoto = false;
                                            setState(() {});
                                          }
                                        },
                                        child: Container(
                                            padding: EdgeInsets.all(0.0),
                                            width: double.infinity,
                                            child: Text(
                                              allTranslations.text("verify"),
                                              style: TextStyle(fontSize: 18.0),
                                              textAlign: TextAlign.center,
                                            )),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0))),
                                    RaisedButton(
                                        elevation: 0.0,
                                        color: Settings.mainColor(),
                                        textColor: Colors.white,
                                        onPressed: () async {
                                          uidx = await createFirebaseAccount();
                                          _formData['fuid'] = uidx;
                                          CreateCFSaccount(uidx);
                                          _handleSubmitted(
                                            context,
                                            model,
                                          );
                                        },
                                        child: Container(
                                            padding: EdgeInsets.all(0.0),
                                            width: double.infinity,
                                            child: Text(
                                              allTranslations.text("skip"),
                                              style: TextStyle(fontSize: 18.0),
                                              textAlign: TextAlign.center,
                                            )),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0))),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ));
  }
}

class UserImage extends StatelessWidget {
  final File imageFile;

  UserImage(this.imageFile);
  @override
  Widget build(BuildContext context) {
    dynamic userImage = NetworkImage("https://i.imgur.com/8Y3SdQZ.png");
    if (imageFile != null) {
      userImage = FileImage(imageFile);
    }
    return Center(
        child: Stack(
      alignment: Alignment.center,
      children: <Widget>[
        CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: userImage,
          radius: 30,
        ),
        Container(
          width: 80,
          height: 80,
        ),
        imageFile == null
            ? Positioned(
                right: 1,
                bottom: 1,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blue, width: 2),
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                ),
              )
            : Container(),
      ],
    ));
  }
}
