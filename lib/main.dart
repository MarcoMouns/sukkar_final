import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// @omar notify
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:health/%20firebase_notification_handler.dart';
import 'package:health/pages/measurement/addsugar.dart';
import 'package:health/shared-data.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './languages/all_translations.dart';
import './languages/translations.dart';

import './scoped_models/main.dart';
import 'package:health/pages/landPage.dart';
import 'package:health/pages/Settings.dart';

import './pages/account/profile.dart';
import './pages/account/reset.dart';
import './pages/account/login.dart';
import './pages/account/new.dart';
import './pages/others/map.dart';
import './pages/home.dart';
import './pages/others/offers.dart';
import 'Welcome screen.dart';

void main() async {
  // debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

  runApp(MyApp());
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    new FlutterLocalNotificationsPlugin();

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message

    final dynamic data = message['data'];
    showNotification("String title", "body");
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
    showNotification("String title", "body");
  }
}

showNotification(String title, body) async {
  var andriod = new AndroidNotificationDetails(
      "channelId", "channelName", "channelDescription",
      priority: Priority.High, importance: Importance.Max);
  var iOS = new IOSNotificationDetails();
  var platform = new NotificationDetails(andriod, iOS);
  await flutterLocalNotificationsPlugin.show(0, title, body, platform,
      payload: "wawwawawaw");
}

class SpLash extends StatefulWidget {
  @override
  _SpLashState createState() => new _SpLashState();
}

class _SpLashState extends State<SpLash> {
  @override
  void initState() {
    super.initState();
    onStartFunctions();
    if (mounted) {
      Timer(Duration(seconds: 3, milliseconds: 300), () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  sharedPreferences.get('authUser') == null
                      ? WelcomeScreen()
                      : MainHome(),
            ),
            ModalRoute.withName("langPage"));
      });
    }
  }

  onStartFunctions() async {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await allTranslations.init();
    allTranslations.setNewLanguage("ar");
    allTranslations.onLocaleChangedCallback = Settings.onLocaleChanged;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print(sharedPreferences.getKeys());
    getCustomerData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.blue,
      child: Image.asset(
        "assets/LOGO.png",
        scale: 3,
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String one = "";
  String two = "";
  SharedPreferences sharedPreferences;
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project

  @override
  void initState() {
    super.initState();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    // If you have skipped STEP 3 then change app_icon to @mipmap/ic_launcher

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_logo');
    var iOS = new IOSInitializationSettings();
    var initSettings = new InitializationSettings(android, iOS);

    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: onSelectNotification);

    //showNotification("title", "body");

    FirebaseMessaging().configure(
      onMessage: (Map<String, dynamic> message) async {
        print("oaaaaaaaaaaaanMessage $message");
        one = message['notification']['title'];
        two = message['notification']['body'];
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
        showNotification("title", "body");
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume $message");
      },
    );
    FirebaseMessaging().getToken().then((t) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Dio dio = new Dio();
      Response res;
      print("${prefs.get('authUser')} =======...fjdBLKg.acHn aLSBhflxvyhn");
      Map<String, dynamic> authUser = jsonDecode(prefs.getString("authUser"));

      print("${authUser['authToken']} 77777777777777");

    var headers = {
      "Authorization": "Bearer ${authUser['authToken']}",
    };

      res = await dio.post("http://api.sukar.co/api/auth/user/update-token?firebase_token=$t",
          options: Options(headers: headers));

      print("${res.data} ===========svhan;lsvdjclualmvxfkzlc");
    });

    getAuthentication();
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

// Method 1
  Future _showNotificationWithSound() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        sound: 'slow_spring_board',
        importance: Importance.Max,
        priority: Priority.High);
    var iOSPlatformChannelSpecifics =
        new IOSNotificationDetails(sound: "slow_spring_board.aiff");
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'New Post',
      'How to Show Notification in Flutter',
      platformChannelSpecifics,
      payload: 'Custom_Sound',
    );
  }

  void getAuthentication() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    final MainModel model = MainModel();
    return ScopedModel<MainModel>(
        model: model,
        child: MaterialApp(
          //debugShowMaterialGrid: true,
          showSemanticsDebugger: false,
          theme: ThemeData(
            canvasColor: Colors.white,
            primaryTextTheme: TextTheme(body1: TextStyle(color: Colors.blue)),
            backgroundColor: Colors.white,
            accentColor: Colors.white,
            bottomAppBarColor: Colors.white,
            secondaryHeaderColor: Colors.white,
            //  fontFamily: 'najed'
          ),
          title: allTranslations.text("app_title"),
          debugShowCheckedModeBanner: false,
          locale: model.appLocal,
          supportedLocales: allTranslations.supportedLocales(),
          localizationsDelegates: [
            const TranslationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            const FallbackCupertinoLocalisationsDelegate(),
          ],
          routes: <String, WidgetBuilder>{
            '/': (BuildContext context) => SpLash(),
            '/landPage': (BuildContext context) => LandPage(),
            '/logIn': (BuildContext context) => LogIn(),
            '/newUser': (BuildContext context) => NewUser(),
            // '/verify': (BuildContext context) => Verify(),
            '/reset': (BuildContext context) => Reset(),
            // '/complete': (BuildContext context) => Complete(),
            '/home': (BuildContext context) => MainHome(),
            '/editProfile': (BuildContext context) => EditProfile(),
            '/map': (BuildContext context) => MapPage(),
            '/offers': (BuildContext context) => OffersPage(),
            '/addSugar': (BuildContext context) => AddSugar(),
          },
          initialRoute: '/',
        ));
  }
}

class FallbackCupertinoLocalisationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      DefaultCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(FallbackCupertinoLocalisationsDelegate old) => false;
}
