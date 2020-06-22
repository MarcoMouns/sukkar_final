import 'package:flutter/material.dart';
import 'package:health/languages/all_translations.dart';
import 'package:url_launcher/url_launcher.dart';

class AdDetailsScreen extends StatefulWidget {
  String imgLInk;
  String text;
  String link;

  AdDetailsScreen(String imgLInk, String text, String link) {
    this.imgLInk = imgLInk;
    this.text = text;
    this.link = link;
  }
  @override
  _AdDetailsScreenState createState() => _AdDetailsScreenState();
}

class _AdDetailsScreenState extends State<AdDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: allTranslations.currentLanguage == "ar"
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(allTranslations.text("ad")),
        ),
        body: ListView(
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3, vertical: 5),
              decoration: ShapeDecoration(
                  image: DecorationImage(
                      image:
                          NetworkImage('http://api.sukar.co/${widget.imgLInk}'),
                      fit: BoxFit.cover),
                  color: Colors.grey[200],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              margin: EdgeInsets.symmetric(horizontal: 10),
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.width * 0.6,
            ),
            SizedBox(
              height: 15,
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text(
                  widget.text,
                  style: TextStyle(fontSize: 20),
                )),
            InkWell(
              onTap: () async {
                var url = '${widget.link}';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              child: Center(
                child: Container(
                  child: Text(
                    allTranslations.text("press here"),
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
