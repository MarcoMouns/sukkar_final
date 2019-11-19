import 'package:flutter/material.dart';
import 'package:health/Models/article_tab/article_category.dart';
import 'package:health/pages/home/articles.dart';
import 'package:health/scoped_models/main.dart';

import '../Settings.dart';

class ArticleCategory extends StatefulWidget {
  final MainModel model;
  ArticleCategory(this.model);

  @override
  _ArticleCategoryState createState() => _ArticleCategoryState();
}

class _ArticleCategoryState extends State<ArticleCategory> {
  List<DataListBean> articleCategory = List<DataListBean>();

  @override
  void initState() {
    super.initState();

    widget.model.fetchArticlesCategories().then((result) {
      if (result != null) {
        setState(() {
          Settings.currentIndex = 1;
          articleCategory = result.articleCategory.data;
          print('Result = > ${articleCategory[0].image}');
          print('Result = > ${articleCategory[0].titleAr}');
          print('Result = > ${articleCategory[0].titleEn}');
        });
      } else {}
    }).catchError((err) {
      print(err);
    });
  }
  @override
  Widget build(BuildContext context) {
    return
        new Container(
      color: Colors.lightBlue[50],
      child: ListView.builder(
        padding: EdgeInsets.all(20.0),
        itemCount: articleCategory.length,
        itemBuilder: (BuildContext context, index) {
          return InkWell(onTap: (){
            Navigator.push(context,MaterialPageRoute(builder: (context)=>ArticlesPage(widget.model,articleCategory[index].id,  articleCategory[index].titleAr)) );
          },
            child: Card(
              elevation: 5.0,
              margin: EdgeInsets.only(bottom: 20),
              child: Container(
                padding: const EdgeInsets.only(top: 10.0),
                height: 170,
                width: double.infinity,
                child: Container(
                    width: double.infinity,
                    color: Colors.black26,
                    child: Text(
                      articleCategory[index].titleAr,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    )),
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage('http://api.sukar.co/${ articleCategory[index].image}'))),
              ),
            ),
          );
        },
      ),
    );

  }
}
