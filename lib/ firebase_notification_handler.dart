// import 'dart:io';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     new FlutterLocalNotificationsPlugin();

// Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
//   if (message.containsKey('data')) {
//     // Handle data message
//     final dynamic data = message['data'];
//   }

//   if (message.containsKey('notification')) {
//     // Handle notification message
//     final dynamic notification = message['notification'];
//   }
// }

// class FirebaseNotifications {
//   FirebaseMessaging _firebaseMessaging;

//   static var initializationSettingsAndroid =
//       AndroidInitializationSettings('app_icon');
//   static var initializationSettingsIOS = IOSInitializationSettings();

//   var initializationSettings = InitializationSettings(
//       initializationSettingsAndroid, initializationSettingsIOS);

//   void setUpFirebase() {
//     _firebaseMessaging = FirebaseMessaging();

//     firebaseCloudMessaging_Listeners();
//   }

//   void firebaseCloudMessaging_Listeners() {
//     if (Platform.isIOS) iOS_Permission();

//     _firebaseMessaging.getToken().then((token) {
//       print("this the token:    $token");
//     });

//     _firebaseMessaging.configure(
//       onMessage: (Map<String, dynamic> message) async {},
//       onBackgroundMessage: myBackgroundMessageHandler,
//       onResume: (Map<String, dynamic> message) async {
//         print('on resume $message');
//       },
//       onLaunch: (Map<String, dynamic> message) async {
//         print('on launch $message');
//       },
//     );
//   }

//   void iOS_Permission() {
//     _firebaseMessaging.requestNotificationPermissions(
//         IosNotificationSettings(sound: true, badge: true, alert: true));
//     _firebaseMessaging.onIosSettingsRegistered
//         .listen((IosNotificationSettings settings) {
//       print("Settings registered: $settings");
//     });
//   }
// }
