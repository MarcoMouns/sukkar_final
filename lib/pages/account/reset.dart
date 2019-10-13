import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health/pages/account/reset_pass_verify_code.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scoped_models/main.dart';
import 'package:health/pages/Settings.dart';
import '../../languages/all_translations.dart';

class Reset extends StatefulWidget {
  _ResetState createState() => _ResetState();
}

class _ResetState extends State<Reset> {
  FocusNode _focusNode = FocusNode();
  String phoneNum;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  void _handleSubmit(BuildContext context, MainModel model) {
    Locale myLocale = Localizations.localeOf(context);
    if (!_formKey.currentState.validate()) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    model.requestResetPasswordCode(phoneNum).then((result) {
      if (result == true) {
        setState(() {
          _isLoading = false;
        });
        // go to check change password page
        Navigator.of(context).push(PageRouteBuilder(pageBuilder: (_, __, ___) {
          return ResetPassVerifyCode(phoneNum);
        }));
      } else {
        setState(() {
          _isLoading = false;
        });
        // show error
        showInSnackBar(myLocale.languageCode.contains("en")
            ? "Invalid phone number."
            : "رقم الجوال غير مسجل فى قاعدة البيانات");
      }
    }).catchError((err) {
      setState(() {
        _isLoading = false;
      });
      print(err);
    });
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
              _focusNode.unfocus();
            },
            child: Scaffold(
              key: _scaffoldKey,
              body: Form(
                key: _formKey,
                child: ScopedModelDescendant<MainModel>(
                  builder:
                      (BuildContext context, Widget child, MainModel model) {
                    return Container(
                      padding: Platform.isIOS
                          ? EdgeInsets.only(top: 50.0)
                          : EdgeInsets.only(top: 10.0),
                      child: Column(
                        children: <Widget>[
                          Flexible(
                            child: ListView(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Center(),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          _focusNode.unfocus();
                                          Navigator.of(context).pop();
                                        },
                                        child: Icon(Icons.close,
                                            color: Colors.grey),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Center(
                                        child: ImageIcon(
                                            AssetImage(
                                                "assets/icons/ic_password.png"),
                                            size: 70.0,
                                            color: Colors.grey),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(10.0),
                                      ),
                                      ListTile(
                                        title: Text(
                                          allTranslations
                                              .text("forgetMyPassword"),
                                          style: TextStyle(
                                              color: Colors.redAccent,
                                              fontSize:
                                                  Platform.isIOS ? 40.0 : 25),
                                        ),
                                        subtitle: Text(
                                          allTranslations
                                              .text("enterYourMobile"),
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize:
                                                  Platform.isIOS ? 20.0 : 15),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    LogInInput(
                                      enabled: true,
                                      onSaved: (String val) {
                                        setState(() {
                                          phoneNum = val;
                                        });
                                      },
                                      validator: (String val) {
                                        if (val.isEmpty) {
                                          return myLocale.languageCode
                                                  .contains("en")
                                              ? "Phone number is required"
                                              : "رقم الجوال مطلوب";
                                        }
                                      },
                                      autoValidate: true,
                                      name: "mobilePhone",
                                      focusNode: _focusNode,
                                      keyboard: TextInputType.phone,
                                    )
                                  ],
                                ),
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 40.0, horizontal: 30.0),
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
                                              _focusNode.unfocus();
                                              _handleSubmit(context, model);
                                              // await Navigator.of(context)
                                              //     .pushNamedAndRemoveUntil(
                                              //         '/home',
                                              //         ModalRoute.withName(
                                              //             '/home'));
                                            },
                                            child: Container(
                                                padding: EdgeInsets.all(10.0),
                                                width: double.infinity,
                                                child: Text(
                                                  allTranslations
                                                      .text("sendCode"),
                                                  style:
                                                      TextStyle(fontSize: 18.0),
                                                  textAlign: TextAlign.center,
                                                )),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0))),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            )));
  }
}
