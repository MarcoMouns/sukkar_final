import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:health/helpers/loading.dart';
import 'package:health/languages/all_translations.dart';
import 'package:health/pages/Settings.dart';
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

  sendForm() async {
    var data = {
      "email": email,
      "subject": subject,
      "message": msg,
      "type": type
    };
    Response response =
        await dio.post("${Settings.baseApilink}/contact-us", data: data);

    print(response.data);
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
                  SizedBox(height: 15),
                  Form(
                    key: _key,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                            onChanged: (val) {
                              email = val;
                            },
                            decoration: InputDecoration(
                                labelText: myLocale.languageCode.contains("en")
                                    ? "Email"
                                    : "البريد الالكتروني"),
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (String val) {
                              setState(() {
                                email = val;
                              });
                            },
                            validator: (String val) {
                              if (val.isEmpty) {
                                return myLocale.languageCode.contains("en")
                                    ? "Email number is required"
                                    : "البريد الالكترونى مطلوب";
                              }
                              Pattern pattern =
                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                              RegExp regex = new RegExp(pattern);
                              if (!regex.hasMatch(val))
                                return myLocale.languageCode.contains("en")
                                    ? "Not Valid Email."
                                    : "البريد الالكترونى غير صحيح.";
                              else
                                return null;
                            }),
                        TextFormField(
                          onChanged: (val) {
                            subject = val;
                          },
                          decoration: InputDecoration(
                              labelText: myLocale.languageCode.contains("en")
                                  ? "subject"
                                  : "العنوان"),
                          enabled: true,
                          keyboardType: TextInputType.text,
                          onFieldSubmitted: (String val) {
                            setState(() {
                              subject = val;
                              print(val);
                            });
                          },
                          validator: (String val) {
                            if (val.isEmpty) {
                              return myLocale.languageCode.contains("en")
                                  ? "subject is required."
                                  : "العنوان مطلوب";
                            }
                          },
                        ),
                        TextFormField(
                          onChanged: (val) {
                            msg = val;
                          },
                          decoration: InputDecoration(
                              labelText: myLocale.languageCode.contains("en")
                                  ? "’message"
                                  : "نص الرسالة"),
                          enabled: true,
                          keyboardType: TextInputType.text,
                          onFieldSubmitted: (String val) {
                            setState(() {
                              msg = val;
                              print(val);
                            });
                          },
                          validator: (String val) {
                            if (val.isEmpty) {
                              return myLocale.languageCode.contains("en")
                                  ? "’message is required."
                                  : "نص الرسالة مطلوب";
                            }
                          },
                        ),
                        new DropdownButton<String>(
                          items:
                              <String>['A', 'B', 'C', 'D'].map((String value) {
                            return new DropdownMenuItem<String>(
                              value: selectedType,
                              child: new Text(value),
                            );
                          }).toList(),
                          onChanged: (_) {
                            type  = selectedType;
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
