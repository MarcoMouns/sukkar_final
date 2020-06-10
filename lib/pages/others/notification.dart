import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:health/Models/notifications.dart';
import 'package:health/helpers/loading.dart';
import 'package:health/languages/all_translations.dart';
import 'package:health/pages/Settings.dart';
import 'package:health/scoped_models/main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notifications extends StatefulWidget {
  @override
  NotificationsState createState() => NotificationsState();
}

class NotificationsState extends State<Notifications> {
  List<NotificationsBean> articleCategories = List<NotificationsBean>();

  Dio dio = new Dio();
  Response response;

  var data;
  var length;
  bool loading;

  @override
  void initState() {
    super.initState();
    getNotifications();
  }

  Future onSelectNotification(String payload) async {
    showDialog(
      context: context,
      builder: (_) {
        return new AlertDialog(
          title: Text("PayLoad"),
          content: Text("Payload : $payload"),
        );
      },
    );
  }

  getNotifications() async {
    setState(() {
      loading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, dynamic> authUser =
        jsonDecode(sharedPreferences.getString("authUser"));
    dio.options.headers = {
      "Authorization": "Bearer ${authUser['authToken']}",
    };
    response = await dio.get(
      "${Settings.baseApilink}/notifications",
    );

    data = response.data['notifications']['data'];
    length = data.length;
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Directionality(
          textDirection: allTranslations.currentLanguage == "ar"
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: Scaffold(
              appBar: AppBar(),
              body: loading == true
                  ? Loading()
                  : new ListView.builder(
                      itemCount: length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: <Widget>[
                            Container(
                              height: 1,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.grey[250],
                            ),
                            Container(
                              color: index % 2 == 0
                                  ? Color(0xfff5f5f5)
                                  : Colors.white,
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.red,
                                      child: Icon(
                                        Icons.notifications,
                                        color: Colors.white,
                                      ),
                                    ),
                                    title: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Text(data[index]['title'],
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    subtitle: Text(
                                      data[index]['body'],
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      })),
        );
      },
    );
  }
}
