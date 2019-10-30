import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat.dart';

class DocInfo extends StatefulWidget {
  String peerId;
  String peerAvatar;
  int dId;


  DocInfo({Key key, @required this.dId, @required this.peerId, @required this.peerAvatar}) : super(key: key);

  @override
  _DocInfoState createState() => _DocInfoState();
}

class _DocInfoState extends State<DocInfo> {

  Response response;
  Dio dio = new Dio();
  bool isLoading=true;
  double starRating=3;

  @override
  void initState() {
    super.initState();
    getUser();
  }


  void getUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    Map<String, dynamic> authUser =
    jsonDecode(sharedPreferences.getString("authUser"));
    print(authUser['authToken']);

    dio.options.headers = {
      "Authorization": "Bearer ${authUser['authToken']}",
    };

    response = await dio.get(
      "http://api.sukar.co/api/doctors/${widget.dId}",
    );

    print('*********************************************');
    print(response);
    print('*********************************************');
    isLoading=false;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: Text("معلومات عن الطبيب"),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: isLoading?
      Center(
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
      :
      ListView(
        children: <Widget>[
          Container(
            alignment: Alignment.topCenter,
            width: MediaQuery.of(context).size.width,
            color: Colors.blue,
            child: Column(
              children: <Widget>[
                CircleAvatar(
                  radius: 40,
                  backgroundImage:
                  response.data['doctor']['image']==null? AssetImage('assets/icons/ic_avatar.png'):
                  NetworkImage('http://api.sukar.co${response.data['doctor']['image']}'),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 5
                  ),
                ),
                Text("${response.data['doctor']['name']}",style: TextStyle(color: Colors.white,fontSize: 20),),
                Text("${response.data['doctor']['specialist']['title_ar']}",style: TextStyle(color: Colors.white,fontSize: 20),),
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
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 20,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.blue,
              ),
              onRatingUpdate: (rating) {
                print(rating);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              
              children: <Widget>[
                Text("عن الدكتور",style: TextStyle(color: Colors.blue,fontSize: 20),),
                Container(
                  margin: EdgeInsets.only(right: 5),
                  child: Text("${response.data['doctor']['doctor_cv'][0]['brief']}",style: TextStyle(fontSize: 17),),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                Text("التخصص",style: TextStyle(color: Colors.blue,fontSize: 20),),
                Container(
                  margin: EdgeInsets.only(right: 5),
                  child: Text("${response.data['doctor']['specialist']['title_ar']}",style: TextStyle(fontSize: 17)),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                Text("الاماكن التى شغلتها",style: TextStyle(color: Colors.blue,fontSize: 20),),
                Container(
                  margin: EdgeInsets.only(right: 5),
                  child: Text("${response.data['doctor']['doctor_cv'][0]['place']}",style: TextStyle(fontSize: 17)),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                Text("امارس مهنتى منذ",style: TextStyle(color: Colors.blue,fontSize: 20),),
                Container(
                  margin: EdgeInsets.only(right: 5),
                  child: Text("${response.data['doctor']['doctor_cv'][0]['work_from']}",style: TextStyle(fontSize: 17)),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                Text("انا مشترك منذ",style: TextStyle(color: Colors.blue,fontSize: 20),),
                Container(
                  margin: EdgeInsets.only(right: 5),
                  child: Text("${response.data['doctor']['work_since']}",style: TextStyle(fontSize: 17)),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
