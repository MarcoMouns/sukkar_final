import 'package:flutter/material.dart';
import './articleDetails.dart';

import '../../languages/all_translations.dart';
import 'package:intl/intl.dart' as intl;
class ArticlesPage extends StatefulWidget {
  _ArticlesPageState createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage>
    with SingleTickerProviderStateMixin {
  @override


  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: allTranslations.currentLanguage == "ar"
            ? TextDirection.rtl
            : TextDirection.ltr,
        child:  Scaffold(
                appBar: AppBar(title: Text("Sports (30)",style: TextStyle(color: Colors.black),),
                  backgroundColor: Colors.white,
                  iconTheme: IconThemeData(color: Colors.black),
                ),
                body: Container(
                  color: Colors.lightBlue[50],
                  child: ListView.builder(
                    padding: EdgeInsets.all(20.0),
                    itemCount: 30,
                    itemBuilder: (BuildContext context, index) {
                      return Card(
                        elevation: 5,
                        margin: EdgeInsets.only(bottom: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(15.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ListTile(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ArticleDetails()));
                            },
                            leading: Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          "assets/imgs/landpage_bk.jpg"))),
                            ),
                            title: Text(
                             intl.DateFormat("dd MMM yyyy", allTranslations.locale.languageCode)
        .format(DateTime.now()),
                              style: TextStyle(color: Colors.redAccent),
                            ),
                            subtitle: Text(
                                "هل يجب إستخدام الاسبرين للوقاية الاولية من بعد حالة حرجة"),
                            isThreeLine: true,
                          ),
                        ),
                      );
                    },
                  ),
                )));
  }
}
