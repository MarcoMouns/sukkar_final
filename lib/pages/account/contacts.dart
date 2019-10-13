import 'package:flutter/material.dart';
import 'package:health/languages/all_translations.dart';
import 'package:url_launcher/url_launcher.dart';

class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(allTranslations.text("contacts")),
      ),
      body: ListView(
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
              const url = 'https://twitter.com/SukarDm';
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
              const url = 'http://www.snapchat.com/add/SukarDM';
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
              const url = 'https://www.instagram.com/sukar_dm/';
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
              const url = 'https://www.facebook.com/sukardm1';
              launch(url);
            },
          ),
          Divider(
            height: 0,
          ),
        ],
      ),
    );
  }
}
