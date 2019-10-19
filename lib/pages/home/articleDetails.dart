import 'package:health/helpers/loading.dart';
import 'package:health/scoped_models/main.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import '../../languages/all_translations.dart';
//import 'package:flutter_youtube/flutter_youtube.dart';

class ArticleDetails extends StatefulWidget {
  final MainModel model;
  final title;
  final id;

  ArticleDetails(this.model, this.title, this.id);

  _ArticleDetailsState createState() => _ArticleDetailsState();
}

class _ArticleDetailsState extends State<ArticleDetails> {
  var name='';
  var id=0;
  var text='';
  var image='';
  var file;
  var video;
  var startDate;
  bool loading=false;

  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
    });
    widget.model.fetchSingleArticle(widget.id).then((result) {
      if (result != null) {
        setState(() {
          name = result.article.name;
          id = result.article.id;
          text = result.article.text;
          image = result.article.image;
          file = result.article.file;
          video = result.article.video;
          startDate = result.article.startDate;
          setState(() {
            loading = false;
          });
        });
      } else {}
    }).catchError((err) {
      print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
      print(err);
      print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            //elevation: 0.0,
            leading: IconButton(
              onPressed: () {
                Share.share('check out my website https://example.com');
              },
              icon: Icon(
                Icons.share,
                color: Colors.black,
              ),
            ),
            title: Text(widget.title,style: TextStyle(color: Colors.red),),
            centerTitle: true,
            actions: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.close, color: Colors.redAccent),
              ),
              Padding(
                padding: EdgeInsets.only(
                    right: 10
                ),
              ),
            ],
          ),
   body: loading == true
       ? Loading()
       :ListView(
     children: <Widget>[
       Image.network('http://api.sukar.co/$image',
           height: 250, fit: BoxFit.contain),
       Padding(
         padding: const EdgeInsets.all(20.0),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: <Widget>[
             Text(
               startDate,
               style: TextStyle(color: Colors.redAccent),
             ),
           ],
         ),
       ),
       Padding(
         padding: const EdgeInsets.symmetric(horizontal: 20.0),
         child: Text(
           text,
           style: TextStyle(color: Colors.grey, fontSize: 15),
         ),
       ),
       InkWell(
         child: Padding(
           padding: EdgeInsets.symmetric(vertical: 20),
           child: Column(
             children: <Widget>[
               Image.asset(
                 "assets/icons/youtube.png",
                 width: 50,
                 height: 50,
               ),
               Text(
                 allTranslations.text("Check video"),
                 style: TextStyle(fontSize: 12, color: Colors.blue),
               )
             ],
           ),
         ),
         onTap: () async {
           var url = '$video';
           if (await canLaunch(url)) {
             await launch(url);
           } else {
             throw 'Could not launch $url';
           }
         },
       ),
       InkWell(
         child: Padding(
           padding: EdgeInsets.symmetric(vertical: 20),
           child: Text(
             allTranslations.text("simple Pdf"),
             style: TextStyle(color: Colors.blue),
             textAlign: TextAlign.center,
           ),
         ),
         onTap: () async {
           var url = '$file';
           if (await canLaunch(url)) {
             await launch(url);
           } else {
             throw 'Could not launch $url';
           }
         },
       ),
     ],
   ),

        ),
    );
  }
}
