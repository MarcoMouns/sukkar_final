import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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

  runApp(MyApp());
}


Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message


  }

  if (message.containsKey('notification')) {
    // Handle notification message

  }
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

  @override
  void initState() {
    super.initState();

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
      Map<String, dynamic> authUser = jsonDecode(prefs.getString("authUser"));


    var headers = {
      "Authorization": "Bearer ${authUser['authToken']}",
    };

    await dio.post("http://api.sukar.co/api/auth/user/update-token?firebase_token=$t",
          options: Options(headers: headers));

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


  void getAuthentication() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    final MainModel model = MainModel();
    return ScopedModel<MainModel>(
        model: model,
        child: MaterialApp(

          showSemanticsDebugger: false,
          theme: ThemeData(
            canvasColor: Colors.white,
            primaryTextTheme: TextTheme(body1: TextStyle(color: Colors.blue)),
            backgroundColor: Colors.white,
            accentColor: Colors.white,
            bottomAppBarColor: Colors.white,
            secondaryHeaderColor: Colors.white,
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
            '/reset': (BuildContext context) => Reset(),
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
