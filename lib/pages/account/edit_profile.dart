import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:health/languages/all_translations.dart';

class EditProfileUser extends StatefulWidget {
  @override
  EditProfileUserState createState() => EditProfileUserState();
}

class EditProfileUserState extends State<EditProfileUser> {
  FocusNode _focusNode1 = FocusNode();
  FocusNode _focusNode2 = FocusNode();
  Response response;
  Dio dio = new Dio();


  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: allTranslations.currentLanguage == "ar"
            ? TextDirection.rtl
            : TextDirection.ltr,
        child:new GestureDetector(
            onTap: () {
              _focusNode1.unfocus();
              _focusNode2.unfocus();
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(allTranslations.text("editProfile")),
              ),
              body: ListView(
                children: <Widget>[
                  Text('edit')
                ],
              ),
            )));
  }
}
