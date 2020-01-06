import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsManager {
  // Making Singleton
  NotificationsManager._privateConstructor();
  static final NotificationsManager instance =
      NotificationsManager._privateConstructor();

  // instance of Required Stuff.
  FlutterLocalNotificationsPlugin _localNotify =
      FlutterLocalNotificationsPlugin();

  bool _init = false;
  BuildContext context;

  Future<void> initialize() async {
    if (_init) {
      return;
    } else {
      var initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
        // there is other params needs to check !!
      );
      var initializationSettings = InitializationSettings(
        initializationSettingsAndroid,
        initializationSettingsIOS,
      );
      _localNotify.initialize(
        initializationSettings,
        onSelectNotification: _onSelectNotification,
      );

      // set _init to true;
      _init = true;
    }
  }

  Future<void> _onSelectNotification(payload) async {
    try {
//      Navigator.of(context).push(
//        MaterialPageRoute(
//          builder: (context) => Notifications(),
//        ),
//      );
    } catch (e) {
//      Crashlytics.instance.recordError(
//        "Manuel Report ${e.toString()}",
//        stackTrace,
//      );
    }
  }

  Future<void> _onDidReceiveLocalNotification(
    int id,
    String title,
    String body,
    String payload,
  ) async {
/*    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
//              await Navigator.push(
//                context,
//                MaterialPageRoute(
//                  builder: (context) => SecondScreen(payload),
//                ),
//              );
            },
          )
        ],
      ),
    );
 */
  }

  Future<void> showNotification({
    @required title,
    @required body,
    @required payload,
    @required context,
  }) async {
    this.context = context;
    await initialize();
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'ReservationChannelID',
      'ProviderChannel',
      'ReservationProviderChannel',
      importance: Importance.Max,
      priority: Priority.High,
      ticker: 'ticker',
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics,
      iOSPlatformChannelSpecifics,
    );
    await _localNotify.show(
      Random().nextInt(999),
      '$title',
      '$body',
      platformChannelSpecifics,
      payload: json.encode(payload),
    );
  }

  dispose() {}
}
