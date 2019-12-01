import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

/// @omar notify
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
  // debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await allTranslations.init();

  allTranslations.setNewLanguage("ar");
  allTranslations.onLocaleChangedCallback = Settings.onLocaleChanged;
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  print(sharedPreferences.getKeys());
  getCustomerData();
  runApp(Main());
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SpLash(),
    );
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
    if (mounted) {
      Timer(Duration(seconds: 3, milliseconds: 300), () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => MyApp()),
            ModalRoute.withName("langPage"));
      });
    }


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFF0c9ccd),
        alignment: Alignment.center,
        child: Image.asset("assets/LOGO.png", scale: 3,),

      ),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    getAuthentication();

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
            '/': (BuildContext context) =>
                sharedPreferences.get('authUser') == null
                    ? WelcomeScreen()
                    : MainHome(),
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
