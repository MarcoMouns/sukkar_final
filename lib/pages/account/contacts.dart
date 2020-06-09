import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:health/helpers/loading.dart';
import 'package:health/languages/all_translations.dart';
import 'package:health/pages/Settings.dart';
import 'package:health/pages/account/contactUsForm.dart';
import 'package:url_launcher/url_launcher.dart';

class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  final _key = GlobalKey<FormState>();
  Response response;
  Dio dio = new Dio();
  String facebook;
  String snapChat;
  String twitter;
  String instagram;
  bool loading = true;

  String email;
  String type;
  String msg;
  String subject;
  String selectedType;

  @override
  void initState() {
    super.initState();
    getSocialLinks();
  }


  void getSocialLinks() async {
    try {
      response = await dio.get(
        "${Settings.baseApilink}/social",
      );

      snapChat = response.data['snapchat'];
      facebook = response.data['facebook'];
      twitter = response.data['twitter'];
      instagram = response.data['instagram'];
      loading = false;
    } catch (e) {
      print("Error");
    }

    setState(() {});
  }

  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);
    return Directionality(
      textDirection: allTranslations.currentLanguage == "ar"
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(allTranslations.text("contacts")),
        ),
        body: loading == true
            ? ListView(
                children: <Widget>[Loading()],
              )
            : ListView(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      allTranslations.text("twitter"),
                      style: TextStyle(color: Colors.grey),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.redAccent,
                    ),
                    onTap: () {
                      var url = twitter;
                      launch(url);
                    },
                  ),
                  Divider(
                    height: 0,
                  ),
                  ListTile(
                    title: Text(
                      allTranslations.text("Snapchat"),
                      style: TextStyle(color: Colors.grey),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.redAccent,
                    ),
                    onTap: () {
                      var url = snapChat;
                      launch(url);
                    },
                  ),
                  Divider(
                    height: 0,
                  ),
                  ListTile(
                    title: Text(
                      allTranslations.text("instagram"),
                      style: TextStyle(color: Colors.grey),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.redAccent,
                    ),
                    onTap: () {
                      var url = instagram;
                      launch(url);
                    },
                  ),
                  Divider(
                    height: 0,
                  ),
                  ListTile(
                    title: Text(
                      allTranslations.text("facebook"),
                      style: TextStyle(color: Colors.grey),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.redAccent,
                    ),
                    onTap: () {
                      var url = facebook;
                      launch(url);
                    },
                  ),
                  Divider(
                    height: 0,
                  ),
                  ListTile(
                    title: Text(
                      allTranslations.text("contacts"),
                      style: TextStyle(color: Colors.grey),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.redAccent,
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => ContactUs()));
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
