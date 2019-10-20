import 'dart:io';

import 'package:flutter/material.dart';
import 'package:health/pages/account/termsAndConditions.dart';
import 'package:health/pages/account/verify.dart';
import 'package:flutter/cupertino.dart';
import 'package:health/pages/Settings.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scoped_models/main.dart';
import '../../languages/all_translations.dart';

class NewUser extends StatefulWidget {
  _NewUserState createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  FocusNode _focusNode = FocusNode();
  String phoneNum;
  bool _isLoading = false;
  bool isClicked = false;
  void clicked(){
    isClicked=true;
    setState(() {});
  }

  void policy(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => TermsAndConditions()));
    clicked();
  }

  _showPrivacyPolicy() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              allTranslations.text("Privacy policy"),
            ),
            content: Text("اقراء الشروط و الاحكام" , style: TextStyle(color: Colors.black),),
            actions: <Widget>[
              InkWell(
                child: Text(
                  allTranslations.text("Agree"),
                  style: TextStyle(color: Colors.blue),
                ),
                onTap: () async{
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  void _handleSubmit(BuildContext context, MainModel model) {
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
    model.addPhoneNumber(phoneNum).then((result) {
      if (result == true) {
        setState(() {
          _isLoading = false;
        });
        // go to check code page
        Navigator.of(context).push(PageRouteBuilder(pageBuilder: (_, __, ___) {
          return Verify(phoneNum);
        }));
      } else {
        setState(() {
          _isLoading = false;
        });
        // show error
        showInSnackBar("The phone has already been taken.");
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
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/imgs/bg.png"),
                              fit: BoxFit.cover)),
                      padding: Platform.isIOS
                          ? EdgeInsets.only(top: 50.0)
                          : EdgeInsets.only(top: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Center(
                                      child: Text(
                                    allTranslations.text("landPage_newAccount"),
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 30),
                                  )),
                                ),
                                InkWell(
                                  onTap: () {
                                    _focusNode.unfocus();
                                    Navigator.of(context).pop();
                                  },
                                  child: Icon(Icons.close, color: Colors.grey),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                LogInInput(
                                  enabled: true,
                                  autoValidate: true,
                                  name: "mobilePhone",
                                  validator: (String val) {
                                    if (val.isEmpty) {
                                      return myLocale.languageCode
                                              .contains("en")
                                          ? "Phone number is required"
                                          : "رقم الجوال مطلوب";
                                    }
                                  },
                                  onSaved: (String val) {
                                    setState(() {
                                      phoneNum = val;
                                    });
                                  },
                                  focusNode: _focusNode,
                                  keyboard: TextInputType.numberWithOptions(
                                      decimal: false, signed: false),
                                ),
                               // Padding(padding: EdgeInsets.only(top: 15)),
                                 Row(
                                    children: <Widget>[
                                      Checkbox(
                                        value: isClicked,
                                        onChanged: (bool v){
                                          policy();
                                        },
                                        checkColor: Colors.white,
                                        activeColor: Colors.blue,
                                      ),
                                      Text("الموافقة على الشروط و الاحكام ",style: TextStyle(fontSize: 13),),
                                      
                                    ],
                                  ),
                                  InkWell(
                                    child: Row(
                                      children: <Widget>[
                                        Text("  للإطلاع على الشروط و الاحكام انقر هنا  ", style: TextStyle(color: Colors.blueAccent),)
                                      ],
                                    ),
                                  onTap: () => policy(),
                                  ),
                                  
                                 

                                //Padding(padding: EdgeInsets.only(top: 15)),
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
                                              _focusNode.unfocus();
                                              // await Navigator.of(context)
                                              //     .pushNamed('/verify');
                                              isClicked==true?
                                              _handleSubmit(context, model):
                                              _showPrivacyPolicy();
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
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              )),
        ));
  }
}
