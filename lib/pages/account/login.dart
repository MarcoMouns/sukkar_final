import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health/pages/Settings.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../languages/all_translations.dart';
import '../../scoped_models/main.dart';

class LogIn extends StatefulWidget {
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController _emailOrPhoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _autoValidate = false;

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  int activeType = 1;
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();

  Map<String, dynamic> _formData = {
    "phone": null,
    "email": null,
    "password": null
  };

  void _handleSubmitted(BuildContext context, MainModel model) {
    Locale myLocale = Localizations.localeOf(context);
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      _autoValidate = true; // Start validating on every change.

      showInSnackBar(allTranslations.currentLanguage == "en"
          ? "Please fix errors before submit"
          : "من فضلك قم بتصحيح جميع الاخطاء اولا");
    } else {
      form.save();
      setState(() {
        _isLoading = true;
      });
      model
          .userLogin(_formData, activeType == 1 ? "password" : "email")
          .then((result) async {
        if (result == true) {
          setState(() {
            _isLoading = false;
          });
          // show registration success
          showInSnackBar(allTranslations.currentLanguage == "en"
              ? "login Completed successfully"
              : "تم التسجيل بنجاح");
          // go to Home  page
          await Navigator.of(context).pushNamedAndRemoveUntil(
              '/home', (Route<dynamic> route) => false);
        } else {
          setState(() {
            _isLoading = false;
          });
          // show registration failed
          // and show error message
          activeType == 1
              ? showInSnackBar(allTranslations.currentLanguage == "en"
                  ? "Invalid phone or password."
                  : "الهاتف المحمول او الرقم السري غير صحيح")
              : showInSnackBar(allTranslations.currentLanguage == "en"
                  ? "Invalid email or password."
                  : "البريد الالكتروني او الرقم السري غير صحيح");
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
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
            focusNode1.unfocus();
            focusNode2.unfocus();
          },
          child: Scaffold(
            key: _scaffoldKey,
            body: ScopedModelDescendant<MainModel>(
              builder: (BuildContext context, Widget child, MainModel model) {
                return Form(
                  key: _formKey,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/imgs/bg.png"),
                            fit: BoxFit.cover)),
                    padding: EdgeInsets.only(top: 10.0),
                    child: Column(
                      children: <Widget>[
                        Flexible(
                          child: ListView(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Center(
                                          child: Text(
                                        allTranslations.text("loginBy"),
                                        style: TextStyle(color: Colors.grey),
                                      )),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child:
                                          Icon(Icons.close, color: Colors.grey),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 30.0),
                                child: Row(
                                  children: <Widget>[
                                    LoginType(
                                        icon: Icons.phone_android,
                                        onPress: () {
                                          setState(() {
                                            activeType = 1;
                                            _emailOrPhoneController.text = "";
                                            _passwordController.text = "";
                                          });
                                        },
                                        isActive: activeType == 1),
                                    LoginType(
                                        icon: Icons.alternate_email,
                                        onPress: () {
                                          setState(() {
                                            activeType = 2;
                                            _emailOrPhoneController.text = "";
                                            _passwordController.text = "";
                                          });
                                        },
                                        isActive: activeType == 2),
                                  ],
                                ),
                              ),
                              LogInInput(
                                keyboard: activeType == 1
                                    ? TextInputType.number
                                    : TextInputType.emailAddress,
                                autoValidate: _autoValidate,
                                controller: _emailOrPhoneController,
                                onSaved: (String value) {
                                  if (activeType == 1) {
                                    setState(() {
                                      _formData['phone'] = value;
                                    });
                                  } else if (activeType == 2) {
                                    _formData['email'] = value;
                                  }
                                },
                                validator: activeType == 1
                                    ? (String value) {
                                        if (value.isEmpty) {
                                          return allTranslations
                                                      .currentLanguage ==
                                                  "en"
                                              ? "Phone number is required"
                                              : "رقم الجوال مطلوب";
                                        }
                                      }
                                    : (String val) {
                                        Pattern pattern =
                                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                        RegExp regex = new RegExp(pattern);
                                        if (!regex.hasMatch(val))
                                          return allTranslations
                                                      .currentLanguage ==
                                                  "en"
                                              ? "Not Valid Email."
                                              : "البريد الالكترونى غير صحيح.";
                                        else
                                          return null;
                                      },
                                enabled: true,
                                focusNode: focusNode1,
                                name:
                                    "${activeType == 1 ? "mobilePhone" : "email"}",
                              ),
                              activeType < 3
                                  ? LogInInput(
                                      controller: _passwordController,
                                      name: "password",
                                      enabled: true,
                                      onSaved: (String value) {
                                        setState(() {
                                          _formData['password'] = value;
                                        });
                                      },
                                      validator: (String value) {
                                        if (value.toString().length < 6)
                                          return allTranslations
                                                      .currentLanguage ==
                                                  "en"
                                              ? "Password must contain at least 6 char"
                                              : "الرقم السرى يجب ان يحتوى على 6 حروف على الاقل";
                                        else
                                          return null;
                                      },
                                      autoValidate: _autoValidate,
                                      isPassword: true,
                                      focusNode: focusNode2,
                                    )
                                  : Wrap(),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 40.0),
                                child: InkWell(
                                  onTap: () async {
                                    await Navigator.of(context)
                                        .pushNamed('/reset');
                                  },
                                  child: Text(
                                    allTranslations.text("forgetPassword"),
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 30.0),
                            child: _isLoading
                                ? CupertinoActivityIndicator(
                                    animating: true,
                                    radius: 15,
                                  )
                                : RaisedButton(
                                    elevation: 0.0,
                                    color: Settings.mainColor(),
                                    textColor: Colors.white,
                                    onPressed: () async {
                                      _handleSubmitted(context, model);
                                    },
                                    child: Container(
                                        padding: EdgeInsets.all(10.0),
                                        width: double.infinity,
                                        child: Text(
                                          allTranslations
                                              .text("landPage_logIn"),
                                          style: TextStyle(fontSize: 18.0),
                                          textAlign: TextAlign.center,
                                        )),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0))),
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
