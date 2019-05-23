import 'package:flutter/material.dart';
import 'package:health/pages/home/articles.dart';

class ArticleCategory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlue[50],
      child: ListView.builder(
        padding: EdgeInsets.all(20.0),
        itemCount: 30,
        itemBuilder: (BuildContext context, index) {
          return InkWell(onTap: (){
            Navigator.push(context,MaterialPageRoute(builder: (context)=>ArticlesPage()) );
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
                      "Sports (30)",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    )),
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/imgs/landpage_bk.jpg"))),
              ),
            ),
          );
        },
      ),
    );
  }
}
