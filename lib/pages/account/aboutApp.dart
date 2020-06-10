import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:health/helpers/loading.dart';
import 'package:health/languages/all_translations.dart';
import 'package:health/pages/Settings.dart';

class AboutApp extends StatefulWidget {
  @override
  AboutAppState createState() => AboutAppState();
}

class AboutAppState extends State<AboutApp> {
  String about;
  bool isloading = true;
  Response response;
  Dio dio = new Dio();
  void getAbout() async {
    response = await dio.get(
      "${Settings.baseApilink}/about",
    );
    about = response.data['about'];
    isloading = false;
    setState(() {});
  }

  initState() {
    super.initState();
    getAbout();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: allTranslations.currentLanguage == "ar"
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(allTranslations.text("about")),
        ),
        body: isloading == true
            ? Loading()
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  child: ListView(
                    children: <Widget>[
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        about,
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
