import 'dart:io';

import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import '../../Settings.dart';
import '../../languages/all_translations.dart';

class Verify extends StatefulWidget {
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  TextEditingController _controller = new TextEditingController();

  final FocusNode _focusNode = FocusNode();

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
              body:  FormKeyboardActions(
                  keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
                  keyboardBarColor: Colors.grey[200],
                  nextFocus: true,
                  actions: [
                    KeyboardAction(
                      focusNode: _focusNode,
                    ),
                  ],
                  child: Container(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: ListView(
                            //    crossAxisAlignment: CrossAxisAlignment.start,
                            //      mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                             _focusNode.unfocus();
                                        Navigator.of(context).pop();
                                      },
                                      child:
                                          Icon(Icons.close, color: Colors.grey),
                                    ),
                                    Center(
                                      child: ImageIcon(
                                          AssetImage(
                                              "assets/icons/ic_verify.png"),
                                          size: 70.0,
                                          color: Colors.grey),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(10.0),
                                    ),
                                    ListTile(
                                      title: Text(
                                        allTranslations.text("verifyThat"),
                                        style: TextStyle(
                                            color: Colors.redAccent,
                                            fontSize:
                                                Platform.isIOS ? 40.0 : 25),
                                      ),
                                      subtitle: Text(
                                        allTranslations.text("enterVerifyCode"),
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
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Row(
                                      children: <Widget>[
                                        InkWell(
                                          child: Text(
                                              allTranslations.text("edit"),
                                              style: TextStyle(
                                                  fontSize: Platform.isIOS
                                                      ? 30.0
                                                      : 20,
                                                  color: Colors.grey)),
                                        ),
                                        Expanded(
                                          child: Center(
                                              child: Text(
                                            "96643355353",
                                            style: TextStyle(
                                                fontSize:
                                                    Platform.isIOS ? 30.0 : 20,
                                                color: Colors.grey),
                                          )),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    height: 40,
                                    margin: EdgeInsets.only(bottom: 10),
                                    child: TextField(
                                      decoration: InputDecoration(
                                          hintText: "", counterText: ""),
                                      controller: _controller,
                                      focusNode: _focusNode,
                                      maxLength: 4,
                                      maxLengthEnforced: true,
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                        "03:22",
                                        style: TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 18),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Center(
                                  child: Text(
                                allTranslations.text("retryAgain"),
                                style: TextStyle(color: Colors.grey),
                              )),
                            ],
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: RaisedButton(
                                elevation: 0.0,
                                color: Settings.mainColor(),
                                textColor: Colors.white,
                                onPressed: () async {
                                       _focusNode.unfocus();
                                  await Navigator.of(context)
                                      .pushNamed('/complete');
                                },
                                child: Container(
                                    padding: EdgeInsets.all(10.0),
                                    width: double.infinity,
                                    child: Text(
                                      allTranslations.text("verify"),
                                      style: TextStyle(fontSize: 18.0),
                                      textAlign: TextAlign.center,
                                    )),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0))),
                          ),
                        ),
                      ],
                    ),
                  )),
            )));
  }
}
