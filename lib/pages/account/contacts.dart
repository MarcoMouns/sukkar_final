import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:health/helpers/loading.dart';
import 'package:health/languages/all_translations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  Response response;
  Dio dio = new Dio();
  String facebook;
  String snapChat;
  String twitter;
  String instagram;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getSocialLinks();
  }

  void getSocialLinks() async {
 try{
      response = await dio.get(
      "http://104.248.168.117/api/social",
    );

    snapChat = response.data['snapchat'];
    facebook = response.data['facebook'];
    twitter = response.data['twitter'];
    instagram = response.data['instagram'];
    loading = false;
 }
 catch(e){
   print("Error");
 }

    setState(() {});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(allTranslations.text("contacts")),
      ),
      body: loading == true ? ListView( children: <Widget>[
        Loading()
      ], ) :ListView(
        children: <Widget>[
          ListTile(
            title: Text(
              allTranslations.text("twitter"),
              style: TextStyle(color: Colors.grey),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.redAccent,
            ),
            onTap: () {
             var url = twitter;
              launch(url);
            },
          ),
          Divider(
            height: 0,
          ),
          ListTile(
            title: Text(
              allTranslations.text("Snapchat"),
              style: TextStyle(color: Colors.grey),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.redAccent,
            ),
            onTap: () {
              var url = snapChat;
              launch(url);
            },
          ),
          Divider(
            height: 0,
          ),
          ListTile(
            title: Text(
              allTranslations.text("instagram"),
              style: TextStyle(color: Colors.grey),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.redAccent,
            ),
            onTap: () {
              var url = instagram;
              launch(url);
            },
          ),
          Divider(
            height: 0,
          ),
          ListTile(
            title: Text(
              allTranslations.text("facebook"),
              style: TextStyle(color: Colors.grey),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.redAccent,
            ),
            onTap: () {
              var url = facebook;
              launch(url);
            },
          ),
          Divider(
            height: 0,
          ),
        ],
      ),
    );
  }
}
