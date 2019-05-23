import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:scoped_model/scoped_model.dart';

import './languages/all_translations.dart';
import './languages/translations.dart';
// import './languages/appModel.dart';
import './scoped_models/main.dart';
import './landPage.dart';
import './Settings.dart';

import './pages/account/complete.dart';
import './pages/account/profile.dart';
import './pages/account/verify.dart';
import './pages/account/reset.dart';
import './pages/account/login.dart';
import './pages/account/new.dart';
import './pages/others/map.dart';
import './pages/home.dart';
import './pages/others/offers.dart';
//import 'package:flutter/foundation.dart';

void main() async {
 // debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await allTranslations.init();
  
  allTranslations.setNewLanguage("ar");
  allTranslations.onLocaleChangedCallback = Settings.onLocaleChanged;

  runApp(MyApp());
}


class SpLash extends StatefulWidget {
  @override
  _SpLashState createState() => new _SpLashState();
}

class _SpLashState extends State<SpLash> {
  @override
  void initState() {
   
    super.initState();
    if(mounted){
Timer(Duration(seconds: 3,milliseconds: 300),(){
      Navigator.of(context)
      .pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=>LandPage()),ModalRoute.withName("langPage"));
    
    });
    }
    
  }
  @override
  Widget build(BuildContext context) {
    return Container(child: new   Image(image: new AssetImage("assets/splash.gif",),fit: BoxFit.fill,),color: Colors.white,);
    
      
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MainModel model = MainModel();
    return ScopedModel<MainModel>(
        model: model,
        child: MaterialApp(
          //debugShowMaterialGrid: true,
          showSemanticsDebugger: false,
          theme: ThemeData(
            canvasColor: Colors.white,primaryTextTheme: TextTheme(body1: TextStyle(color: Colors.blue)),
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
            '/': (BuildContext context) => LandPage(),
            '/landPage': (BuildContext context) => LandPage(),
            '/logIn': (BuildContext context) => LogIn(),
            '/newUser': (BuildContext context) => NewUser(),
            '/verify': (BuildContext context) => Verify(),
            '/reset': (BuildContext context) => Reset(),
            '/complete': (BuildContext context) => Complete(),
            '/home': (BuildContext context) => MainHome(),
            '/editProfile': (BuildContext context) => EditProfile(),
            '/map': (BuildContext context) => MapPage(),
            '/offers': (BuildContext context) => OffersPage(),
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
