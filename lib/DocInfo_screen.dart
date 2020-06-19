import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:health/pages/Settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat.dart';
import 'languages/all_translations.dart';

class DocInfo extends StatefulWidget {
  String peerId;
  String peerAvatar;
  int dId;

  DocInfo(
      {Key key,
      @required this.dId,
      @required this.peerId,
      @required this.peerAvatar})
      : super(key: key);

  @override
  _DocInfoState createState() => _DocInfoState();
}

class _DocInfoState extends State<DocInfo> {
  Response response;
  Dio dio = new Dio();
  bool isLoading = true;
  double starRating;

  void rateTheDoctor(double rating) async {
    print('**********************');
    print(widget.peerId);
    print(rating);
    print(authUser['authToken']);
    print('**********************');
    Response response;
    try {
      response = await Dio().post('http://api.sukar.co/api/rate-doctors',
          data: {"fuid": "${widget.peerId}", "rating": "$rating"},
          options: Options(
            headers: {HttpHeaders.authorizationHeader: "Bearer ${authUser['authToken']}"},
          ));
    } on DioError catch (e) {
      print(e.response.data);
    }

    Firestore.instance.collection('users').document(widget.peerId).get().then((value) {
      var oldRarting = value['rating'];
      print('========> $oldRarting');
      print('=> $rating');
      if (oldRarting != 0) rating = (rating + oldRarting) / 2;
      print(rating);
      Firestore.instance.collection('users').document(widget.peerId)
          .updateData({
        'rating': rating
      });
      starRating = rating;
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Map<String, dynamic> authUser;

  void getUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();


    authUser =
        jsonDecode(sharedPreferences.getString("authUser"));

    dio.options.headers = {
      "Authorization": "Bearer ${authUser['authToken']}",
    };
    response = await dio.get(
      "${Settings.baseApilink}/doctors/${widget.dId}",
    );

    Response responsex = await Dio().get('http://api.sukar.co/api/rate-doctors',
        options: Options(
          headers: {HttpHeaders.authorizationHeader: "Bearer ${authUser['authToken']}"},
        ));

    print('****************************');
    print(responsex);
    print('****************************');

    List<dynamic> data = responsex.data['ratings'];
    data.forEach((element) {
      if (element['fuid'] == widget.peerId)
        starRating = double.parse(element['rating']);
    });

    if (starRating == null)
      starRating = 0;

    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: allTranslations.currentLanguage == "ar"
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(allTranslations.text("doctorinfo")),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: isLoading
            ? Center(
                child: SpinKitWave(
                  size: 30,
                  itemBuilder: (_, int index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color: index.isEven ? Colors.blue : Colors.white,
                      ),
                    );
                  },
                ),
              )
            : ListView(
                children: <Widget>[
                  Container(
                    alignment: Alignment.topCenter,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.blue,
                    child: Column(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: response.data['doctor']['image'] ==
                                  null
                              ? AssetImage('assets/icons/ic_avatar.png')
                              : NetworkImage(
                                  'http://api.sukar.co${response.data['doctor']['image']}'),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                        ),
                        Text(
                          "${response.data['doctor']['name']}",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        Text(
                          "${response.data['doctor']['specialist']['title_ar']}",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 30,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                      InkWell(
                        child: Image.asset(
                          'assets/icons/ic_message.png',
                          scale: 2.5,
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Chat(
                              peerId: widget.peerId,
                              peerAvatar: widget.peerAvatar,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: RatingBar(
                      initialRating: starRating,
                      direction: Axis.horizontal,
                      textDirection: TextDirection.ltr,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemSize: 20,
                      itemBuilder: (context, _) =>
                          Icon(
                            Icons.star,
                            color: Colors.blue,
                          ),
                      onRatingUpdate: (rating) {
                        print(rating);
                        rateTheDoctor(rating);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          allTranslations.text("aboutDoctor"),
                          style: TextStyle(color: Colors.blue, fontSize: 20),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 5),
                          child: Text(
                            "${response.data['doctor']['doctor_cv'][0]['brief']}",
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                        ),
                        Text(
                          allTranslations.text("doctorSpecailty"),
                          style: TextStyle(color: Colors.blue, fontSize: 20),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 5),
                          child: Text(
                              "${response.data['doctor']['specialist']['title_ar']}",
                              style: TextStyle(fontSize: 17)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                        ),
                        Text(
                          allTranslations.text("workinghistory"),
                          style: TextStyle(color: Colors.blue, fontSize: 20),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 5),
                          child: Text(
                              "${response.data['doctor']['doctor_cv'][0]['place']}",
                              style: TextStyle(fontSize: 17)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                        ),
                        Text(
                          allTranslations.text("workingsince"),
                          style: TextStyle(color: Colors.blue, fontSize: 20),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 5),
                          child: Text(
                              "${response.data['doctor']['doctor_cv'][0]['work_from']}",
                              style: TextStyle(fontSize: 17)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                        ),
                        Text(
                          allTranslations.text("joinData"),
                          style: TextStyle(color: Colors.blue, fontSize: 20),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 5),
                          child: Text(
                              "${response.data['doctor']['work_since']}",
                              style: TextStyle(fontSize: 17)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                        ),
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }
}


