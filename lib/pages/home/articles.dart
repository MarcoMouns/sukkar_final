import 'package:flutter/material.dart';
import 'package:health/Models/article_tab/article_detail_category.dart';
import 'package:health/scoped_models/main.dart';
import './articleDetails.dart';

import '../../languages/all_translations.dart';

class ArticlesPage extends StatefulWidget {
  final MainModel model;
  final id;
  final title;
  ArticlesPage(this.model, this.id, this.title);

  _ArticlesPageState createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage>
    with SingleTickerProviderStateMixin {
  List<DataListBean> articleCategories = List<DataListBean>();

  @override
  void initState() {
    super.initState();
    widget.model.fetchArticlesCategoriesDetails(widget.id).then((result) {
      if (result != null) {
        setState(() {
          articleCategories = result.articles.data;
        });
      } else {}
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: allTranslations.currentLanguage == "ar"
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                widget.title,
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
            ),
            body: Container(
              color: Colors.lightBlue[50],
              child: ListView.builder(
                padding: EdgeInsets.all(20.0),
                itemCount: articleCategories.length,
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
                              builder: (BuildContext context) => ArticleDetails(
                                  widget.model,
                                  articleCategories[index].name,
                                  articleCategories[index].id)));
                        },
                        leading: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      'http://api.sukar.co/${articleCategories[index].image}'))),
                        ),
                        title: Text(
                          articleCategories[index].name,
                          style: TextStyle(color: Colors.redAccent),
                        ),
                        subtitle: Text(articleCategories[index].text,
                            overflow: TextOverflow.ellipsis, softWrap: false),
                        isThreeLine: false,
                      ),
                    ),
                  );
                },
              ),
            )));
  }
}
