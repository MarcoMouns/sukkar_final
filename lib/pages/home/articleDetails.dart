
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter/material.dart';
import '../../languages/all_translations.dart';
//import 'package:flutter_youtube/flutter_youtube.dart';

class ArticleDetails extends StatefulWidget {
  _ArticleDetailsState createState() => _ArticleDetailsState();
}

class _ArticleDetailsState extends State<ArticleDetails> {
  // Future<File> createFileOfPdfUrl() async {
  //   final url = "http://web.iitd.ac.in/~prbijwe/Book_Abstracts/The%20Secret.pdf";
  //   final filename = url.substring(url.lastIndexOf("/") + 1);
  //   var request = await HttpClient().getUrl(Uri.parse(url));
  //   var response = await request.close();
  //   var bytes = await consolidateHttpClientResponseBytes(response);
  //   String dir = (await getApplicationDocumentsDirectory()).path;
  //       File file = new File('$dir/$filename');
  //       await file.writeAsBytes(bytes);
  //       return file;
  //     }

  // _play() {

  //   FlutterYoutube.playYoutubeVideoByUrl(
  //     apiKey: TargetPlatform.android == Theme.of(context).platform
  //         ? "AIzaSyBkWamebc1sg2kJBjymTvl43s8VPc8CjQ8"
  //         : "AIzaSyBVUJ2zozrmxg8RiTrn7QNhZl_Ac9RYoho",
  //     videoUrl: "https://www.youtube.com/watch?v=SuwTMeStGRg",

  //     autoPlay: true, //default falase
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: allTranslations.currentLanguage == "ar"
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Material(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: <Widget>[
               
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(onPressed: (){
                      
                    },
                      icon: Icon(
                        Icons.share,
                        color: Colors.redAccent,
                      ),
                    ),
                    Expanded(
                      child: Center(child: Text(allTranslations.text("news"))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(Icons.close, color: Colors.redAccent),
                      ),
                    )
                  ],
                ),

                Image.asset("assets/imgs/profile.jpg",
                  height: 250,

                          fit: BoxFit.cover),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        intl.DateFormat("dd MMM yyyy", allTranslations.locale.languageCode)
        .format(DateTime.now())
                        ,
                        style: TextStyle(color: Colors.redAccent),
                      ),
                      Text(
                        intl.DateFormat.jm( allTranslations.locale.languageCode)
        .format(DateTime.now())
                        ,
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "هل يجب إستخدام الاسبرين للوقاية الاولية من بعد حالة حرجة",
                    style: TextStyle(color: Colors.grey, fontSize: 20,fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    "هل يجب إستخدام الاسبرين للوقاية الاولية من بعد حالة حرجة هل يجب إستخدام الاسبرين للوقاية الاولية من بعد حالة حرجة هل يجب إستخدام الاسبرين للوقاية الاولية من بعد حالة حرجة هل يجب إستخدام الاسبرين للوقاية الاولية من بعد حالة حرجة هل يجب إستخدام الاسبرين للوقاية الاولية من بعد حالة حرجة هل يجب إستخدام الاسبرين للوقاية الاولية من بعد حالة حرجة هل يجب إستخدام الاسبرين للوقاية الاولية من بعد حالة حرجة هل يجب إستخدام الاسبرين للوقاية الاولية من بعد حالة حرجة هل يجب إستخدام الاسبرين للوقاية الاولية من بعد حالة حرجة هل يجب إستخدام الاسبرين للوقاية الاولية من بعد حالة حرجة هل يجب إستخدام الاسبرين للوقاية الاولية من بعد حالة حرجة هل يجب إستخدام الاسبرين للوقاية الاولية من بعد حالة حرجةهل يجب إستخدام الاسبرين للوقاية الاولية من بعد حالة حرجة هل يجب إستخدام الاسبرين للوقاية الاولية من بعد حالة حرجة هل يجب إستخدام الاسبرين للوقاية الاولية من بعد حالة حرجة هل يجب إستخدام الاسبرين للوقاية الاولية من بعد حالة حرجة هل يجب إستخدام الاسبرين للوقاية الاولية من بعد حالة حرجة هل يجب إستخدام الاسبرين للوقاية الاولية من بعد حالة حرجةهل يجب إستخدام الاسبرين للوقاية الاولية من بعد حالة حرجة هل يجب إستخدام الاسبرين للوقاية الاولية من بعد حالة حرجة هل يجب إستخدام الاسبرين للوقاية الاولية من بعد حالة حرجة هل يجب إستخدام الاسبرين للوقاية الاولية من بعد حالة حرجة هل يجب إستخدام الاسبرين للوقاية الاولية من بعد حالة حرجة هل يجب إستخدام الاسبرين للوقاية الاولية من بعد حالة حرجةهل يجب إستخدام الاسبرين للوقاية الاولية من بعد حالة حرجة هل يجب إستخدام الاسبرين للوقاية الاولية من بعد حالة حرجة هل يجب إستخدام الاسبرين للوقاية الاولية من بعد حالة حرجة هل يجب إستخدام الاسبرين للوقاية الاولية من بعد حالة حرجة هل يجب إستخدام الاسبرين للوقاية الاولية من بعد حالة حرجة هل يجب إستخدام الاسبرين للوقاية الاولية من بعد حالة حرجة",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                InkWell(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: <Widget>[
                        Image.asset("assets/icons/youtube.png",width: 50,height: 50,),
                     Text(allTranslations.text("Check video"),style: TextStyle(fontSize: 12,color: Colors.blue),) ],
                    ),
                  ),
                  onTap: () async {
                    const url = 'https://www.youtube.com/watch?v=cBVGlBWQzuc';
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
                      style: TextStyle(color: Colors.blue),textAlign: TextAlign.center,
                    ),
                  ),
                  onTap: () async {
                    const url =
                        'http://www.africau.edu/images/default/sample.pdf';
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
        ));
  }

  getApplicationDocumentsDirectory() {}
}
