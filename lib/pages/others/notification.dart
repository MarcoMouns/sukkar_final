import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:health/Models/notifications.dart';
import 'package:health/helpers/loading.dart';
import 'package:health/scoped_models/main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  List<NotificationsBean> articleCategories = List<NotificationsBean>();
  Dio dio = new Dio();
  Response response;
  final String baseUrl = 'http://104.248.168.117/api';
  var data;
  var length;
  bool loading;

  @override
  void initState() {
    super.initState();
    getNotifications();
     var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon'); 
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin() ;
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
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


  

  getNotifications() async{
    setState(() {
      loading = true;
    });
    SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    Map<String, dynamic> authUser =
    jsonDecode(sharedPreferences.getString("authUser"));
    dio.options.headers = {
      "Authorization": "Bearer ${authUser['authToken']}",
    };
    response = await dio.get(
      "$baseUrl/notifications",
    );
//    print('data = > \n ${response.data['notifications']}');
    data = response.data['notifications']['data'];
    print('data = > \n ${data}');
    length = data.length;
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      new ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          return  Scaffold(
              appBar: AppBar(),
              body: loading == true
                  ? Loading()
                  :new ListView.builder(
                  itemCount: length,
                  itemBuilder: (context, index) {
                    FontWeight fontWeight = index % 2 == 0 ? FontWeight.bold : null;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.red,
                        child: Icon(Icons.notifications, color: Colors.white,),
                      ),
                      title: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(data[index]['title'],
                              style: TextStyle(
                                  color: Colors.black, fontWeight: fontWeight)),
//                          Expanded(
//                            child: SizedBox(),
//                          ),
//                          Text("3 apr",
//                              style: TextStyle(
//                                  color: Colors.black, fontWeight: fontWeight))
                        ],
                      ),
                      subtitle: Text(
                        data[index]['body'],
                        style: TextStyle(
                            color: Colors.black, fontWeight: fontWeight),
                      ),
                    );
                  })
          );
        },
      );
  }
}
