import 'dart:io';

import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import '../../Settings.dart';
import '../../languages/all_translations.dart';

class NewUser extends StatefulWidget {
  _NewUserState createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  FocusNode _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: allTranslations.currentLanguage == "ar"
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: GestureDetector(
          onTap: () {
            _focusNode.unfocus();
          },
          child: Scaffold(
              body: new FormKeyboardActions(
                  keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
                  keyboardBarColor: Colors.grey[200],
                  nextFocus: true,
                  actions: [
                    KeyboardAction(
                      focusNode: _focusNode,
                    ),

                    /*KeyboardAction(
          focusNode: _nodeText3,
          onTapAction: () {
          showDialog(
          context: context,
          builder: (context) {
          return AlertDialog(
          content: Text("Custom Action"),
          actions: <Widget>[
          FlatButton(
          child: Text("OK"),
          onPressed: () => Navigator.of(context).pop(),
          )
          ],
          );
          });
          },
          ),
          KeyboardAction(
          focusNode: _nodeText4,
          displayCloseWidget: false,
    ),*/
                  ],
                  child: Container(
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
                                autoValidate: true,
                                name: "mobilePhone",
                                focusNode: _focusNode,
                                keyboard: TextInputType.numberWithOptions(
                                    decimal: false, signed: false),
                              ),
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 30.0),
                                  child: RaisedButton(
                                      elevation: 0.0,
                                      color: Settings.mainColor(),
                                      textColor: Colors.white,
                                      onPressed: () async {
                                        _focusNode.unfocus();
                                        await Navigator.of(context)
                                            .pushNamed('/verify');
                                      },
                                      child: Container(
                                          padding: EdgeInsets.all(10.0),
                                          width: double.infinity,
                                          child: Text(
                                            allTranslations.text("sendCode"),
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
                        )
                      ],
                    ),
                  ))),
        ));
  }
}
