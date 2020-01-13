import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:health/helpers/loading.dart';
import 'package:health/languages/all_translations.dart';

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
        "http://api.sukar.co/api/about",
      );

      about = response.data['about'];
      print("=======================================================");
      print(about);
      isloading = false;


    setState(() {});
  }

  initState() {
    super.initState();
    getAbout();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(allTranslations.text("about")),
      ),
      body: isloading == true ? Loading(): Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            Text(
                about,
                style:TextStyle(fontSize: 20),),
          ],
        ),
      ),
    );
  }
}
