import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../helpers/color_transform.dart';
import '../../scoped_models/main.dart';
import '../../Settings.dart';
import '../../languages/all_translations.dart';

class Complete extends StatefulWidget {
  _CompleteState createState() => _CompleteState();
}

class _CompleteState extends State<Complete> {
  dynamic _gender = 'male';
  FocusNode _focusNode1 = FocusNode();
  FocusNode _focusNode2 = FocusNode();
  FocusNode _focusNode3 = FocusNode();
  FocusNode _focusNode4 = FocusNode();
  FocusNode _focusNode5 = FocusNode();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _passwrodController = TextEditingController();
  bool _isLoading = false;
  bool _autoValidate = false;

  Map<String, dynamic> _formData = {
    "image": null,
    "userName": null,
    "email": null,
    "injuredDate": null,
    "gender": null,
    "password": null
  };

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  void _getImage(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(source: source, maxWidth: 400.0).then((File image) {
      setState(() {
        _formData['image'] = image;
      });
      Navigator.pop(context);
    });
  }

  void _imagePicker(BuildContext context) {
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

  void _handleSubmitted(BuildContext context, MainModel model) {
    Locale myLocale = Localizations.localeOf(context);
    final FormState form = _formKey.currentState;
    setState(() {
      _formData['gender'] = _gender == 'male' ? 1 : 0;
    });
    if (!form.validate() || _formData['image'] == null) {
      _autoValidate = true; // Start validating on every change.

      showInSnackBar(myLocale.languageCode.contains("en")
          ? "Please fix errors before submit"
          : "من فضلك قم بتصحيح جميع الاخطاء اولا");
    } else {
      form.save();
      setState(() {
        _isLoading = true;
      });
      print("form data => $_formData");
      // model.userRegister(_formData).then((result) {
      //   if (result['success'] == true) {
      //     setState(() {
      //       _isLoading = false;
      //     });

      //     // show registration success
      //     showInSnackBar(myLocale.languageCode.contains("en")
      //         ? "Registratin Completed successfully"
      //         : "تم التسجيل بنجاح");
      //     // go to Home validation page

      //   } else {
      //     setState(() {
      //       _isLoading = false;
      //     });
      //     // show registration failed
      //     // and show error message
      //     showInSnackBar(myLocale.languageCode.contains("en")
      //         ? "Error ${result['error']}"
      //         : "خطأ ${result['error']}");
      //   }
      // });
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

                                      // CircleAvatar(
                                      //   backgroundColor: Colors.redAccent,
                                      //   radius: 50.0,
                                      //   child: _formData['image'] != null
                                      //       ? Image.file(
                                      //           _formData['image'],
                                      //           width: 100,
                                      //           height: 100,
                                      //           fit: BoxFit.fill,
                                      //         )
                                      //       : Icon(Icons.person,
                                      //           size: 50, color: Colors.white),
                                      // ),
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
                              LogInInput(
                                name: "username",
                                keyboard: TextInputType.text,
                                autoValidate: _autoValidate,
                                focusNode: _focusNode1,
                                onSaved: (String val) {
                                  setState(() {
                                    _formData['userName'] = val;
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
                              LogInInput(
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
                                  Pattern pattern =
                                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                  RegExp regex = new RegExp(pattern);
                                  if (!regex.hasMatch(val))
                                    return myLocale.languageCode.contains("en")
                                        ? "Not Valid Email."
                                        : "البريد الالكترونى غير صحيح.";
                                  else
                                    return null;
                                },
                              ),
                              LogInInput(
                                autoValidate: _autoValidate,
                                name: "injuryDate",
                                keyboard: TextInputType.datetime,
                                focusNode: _focusNode3,
                                onSaved: (String val) {
                                  setState(() {
                                    _formData['injuredDate'] = val;
                                  });
                                },
                                validator: (String val) {
                                  if (val.isEmpty) {
                                    return myLocale.languageCode.contains("en")
                                        ? "injury Date is required."
                                        : " تاريخ الاصابة مطلوب";
                                  }
                                },
                              ),
                              LogInInput(
                                autoValidate: _autoValidate,
                                name: "password",
                                isPassword: true,
                                focusNode: _focusNode4,
                                onSaved: (String val) {
                                  setState(() {
                                    _formData['password'] = val;
                                  });
                                },
                                validator: (String val) {
                                  if (val.toString().length < 6)
                                    return myLocale.languageCode.contains("en")
                                        ? "Password must contain at least 6 char"
                                        : "الرقم السرى يجب ان يحتوى على 6 حروف على الاقل";
                                  else
                                    return null;
                                },
                              ),
                              LogInInput(
                                name: "passwordConfirm",
                                autoValidate: _autoValidate,
                                controller: _passwrodController,
                                isPassword: true,
                                focusNode: _focusNode5,
                                validator: (String val) {
                                  if (_passwrodController.text != val) {
                                    return myLocale.languageCode.contains("en")
                                        ? "Password don't match."
                                        : "الرقم السرى غير صحيح";
                                  }
                                },
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
                          child: RaisedButton(
                              elevation: 0.0,
                              color: Settings.mainColor(),
                              textColor: Colors.white,
                              onPressed: () async {
                                _showPrivacyPolicy(model);
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
                                  borderRadius: BorderRadius.circular(20.0))),
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

  _showPrivacyPolicy(MainModel model) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              allTranslations.text("Privacy policy"),
            ),
            content: SingleChildScrollView(
                child: Text("bla bla bla bla bla bla bla bla bla bla bla bla")),
            actions: <Widget>[
              InkWell(
                child: Text(
                  allTranslations.text("Agree"),
                  style: TextStyle(color: Colors.blue),
                ),
                onTap: () {
                  _handleSubmitted(context, model);
                  Navigator.of(context).pop();
                  // Navigator.of(context).pushNamedAndRemoveUntil(
                  //     '/home', ModalRoute.withName('/home'));
                },
              ),
              InkWell(
                child: Text(
                  allTranslations.text("disagree"),
                  style: TextStyle(color: Colors.blue),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
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
    // else if (imageUrl != null && imageFile == null) {
    //   userImage = NetworkImage(imageUrl);
    // }
    return Center(
      child: CircleAvatar(
        backgroundColor: Colors.white,
        backgroundImage: userImage,
        radius: 30,
      ),
    );
  }
}
