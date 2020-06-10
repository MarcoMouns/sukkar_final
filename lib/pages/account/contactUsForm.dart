import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:health/languages/all_translations.dart';
import 'package:health/pages/Settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  FocusNode _subjectFocusNode = FocusNode();
  FocusNode _typeFocusNode = FocusNode();
  FocusNode _detailsFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();

  TextEditingController subjectController = new TextEditingController();
  TextEditingController typeController = new TextEditingController();
  TextEditingController detailsController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();

  void unFocusNodes() {
    _subjectFocusNode.unfocus();
    _typeFocusNode.unfocus();
    _detailsFocusNode.unfocus();
    _emailFocusNode.unfocus();
  }

  var _value;

  DropdownButton _normalDown() => DropdownButton<String>(
        isExpanded: true,
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.blue,
        ),
        items: [
          DropdownMenuItem<String>(
            value: "1",
            child: Center(
              child: Text(
                allTranslations.text('complain'),
              ),
            ),
          ),
          DropdownMenuItem<String>(
            value: "2",
            child: Center(
              child: Text(
                allTranslations.text('suggestion'),
              ),
            ),
          ),
        ],
        onChanged: (value) {
          setState(() {
            _value = value;
            typeController.text = value == "1" ? "complaint " : "suggestion";
            print(typeController.text);
          });
        },
        value: _value,
        hint: Text(
          allTranslations.text('choose type'),
          style: TextStyle(color: Colors.grey),
        ),
      );

  sendForm() async {
    Dio dio = new Dio();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, dynamic> authUser =
        jsonDecode(sharedPreferences.getString("authUser"));
    var data = FormData.fromMap({
      "email": emailController.text,
      "subject": subjectController.text,
      "message": detailsController.text,
      "type": typeController.text
    });
    Response response = await dio.post("${Settings.baseApilink}/contact-us",
        data: data,
        options: Options(
            headers: {"Authorization": "Bearer ${authUser['authToken']}"}));
    print(response.data);
  }

  Future<void> confirmFieldsDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: allTranslations.currentLanguage == "en"
              ? TextDirection.ltr
              : TextDirection.rtl,
          child: AlertDialog(
            title: Text(
              allTranslations.text("warning"),
            ),
            content: Text(
              allTranslations.text("your massage has been send successfully"),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  allTranslations.text("done"),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: allTranslations.currentLanguage == "ar"
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            allTranslations.text('contacts'),
          ),
        ),
        body: GestureDetector(
          onTap: () => unFocusNodes(),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 35.0, left: 10),
                    child: Container(
                      height: 25,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextField(
                        focusNode: _subjectFocusNode,
                        controller: subjectController,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        maxLines: 1,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[350]),
                          ),
                          hintStyle: TextStyle(
                            color: Color(0xff636363),
                          ),
                          border: InputBorder.none,
                          hintText: allTranslations.text('subject'),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 35.0, left: 10),
                    child: Container(
                      height: 25,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextField(
                        focusNode: _emailFocusNode,
                        controller: emailController,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        maxLines: 1,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[350]),
                          ),
                          hintStyle: TextStyle(
                            color: Color(0xff636363),
                          ),
                          border: InputBorder.none,
                          hintText: allTranslations.text('email'),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 35.0, left: 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: _normalDown(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Text(
                      allTranslations.text(
                          "please provide us with your compliment or suggestion so we can do our best:"),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 25.0, left: 10),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextField(
                        controller: detailsController,
                        focusNode: _detailsFocusNode,
                        maxLines: 10,
                        minLines: 8,
                        maxLength: 2000,
                        decoration: InputDecoration(
                          counterText: "",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffE8E8E8)),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          hintText: allTranslations.text('details'),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    child: Padding(
                      padding: EdgeInsets.only(top: 40.0),
                      child: Container(
                        height: 50.0,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Material(
                            color: Colors.blue,
                            elevation: 0.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            child: Center(
                                child: Text(
                              allTranslations.text('send'),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ))),
                      ),
                    ),
                    onTap: () {
                      sendForm();
                      Navigator.of(context).pop();
                      confirmFieldsDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    
  }
}
