import 'dart:io';

import 'package:flutter/material.dart';
import 'package:health/Welcome%20screen.dart';
import 'package:health/pages/Settings.dart';
import '../languages/all_translations.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class LandPage extends StatefulWidget {
  _LandPageState createState() => _LandPageState();
}

class _LandPageState extends State<LandPage> {




  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: allTranslations.currentLanguage == "ar"
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: WillPopScope(
          onWillPop: () {
            Navigator.of(context).pop();
          },
          child: Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      return LandPageSliderItem(
                        image: "assets/imgs/slider$index.png",
                        title: "landPage_title",
                        subtitle: "landPage_subtitle",
                      );
                    },
                    itemCount: 6,
                    pagination: new SwiperPagination(),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 30.0),
                    child: RaisedButton(
                        elevation: 0.0,
                        color: Settings.mainColor(),
                        textColor: Colors.white,
                        onPressed: () async {
                          await Navigator.of(context).pushNamed('/logIn');
                        },
                        child: Container(
                            padding: EdgeInsets.all(10.0),
                            width: double.infinity,
                            child: Text(
                              allTranslations.text("landPage_logIn"),
                              style: TextStyle(fontSize: 18.0),
                              textAlign: TextAlign.center,
                            )),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                  ),
                ),
                Container(
                  padding: Platform.isIOS
                      ? EdgeInsets.only(bottom: 30.0)
                      : EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: FlatButton(
                          onPressed: () async {
                            await Navigator.of(context).pushNamed('/newUser');
                          },
                          child: Text(
                            allTranslations.text("landPage_newAccount"),
                            style: TextStyle(color: Settings.mainColor()),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: FlatButton(
                            onPressed: () async {
                              await Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) => WelcomeScreen()));
                            },
                            child: Text(
                              allTranslations.text("landPage_notNow"),
                              style: TextStyle(color: Settings.mainColor()),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class LandPageBk extends StatelessWidget {
  final String image;
  LandPageBk({Key key, this.image}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.fill,
        )));
  }
}

class LandPageHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isIOS;
  LandPageHeader({Key key, this.title, this.subtitle, this.isIOS = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0.0,
      left: 0.0,
      right: 0.0,
      child: Container(
          color: Colors.white.withAlpha(1000),
          child: Padding(
            padding: isIOS
                ? EdgeInsets.only(top: 50.0, bottom: 20.0)
                : EdgeInsets.only(top: 20.0, bottom: 20.0),
            child: ListTile(
              title: Text(allTranslations.text(title),
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Settings.mainColor(),
                  )),
              subtitle: Text(
                allTranslations.text(subtitle),
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          )),
    );
  }
}

class LandPageSliderItem extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final bool isIOS;
  LandPageSliderItem(
      {Key key, this.image, this.title, this.subtitle, this.isIOS = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, children: [
      LandPageBk(image: image),
      LandPageHeader(title: title, subtitle: subtitle, isIOS: isIOS),
      Positioned(
        bottom: 50,
        left: 50,
        //   right: 50,
        child: Image.asset(
          "assets/icons/ic_logo2.png",
          fit: BoxFit.contain,
          height: 150,
        ),
      )
    ]);
  }
}
