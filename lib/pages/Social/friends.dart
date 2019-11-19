import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:health/Models/friends_tab/getFollowers.dart';
import 'package:health/Models/friends_tab/getFollowing.dart';

import 'package:health/languages/all_translations.dart';
import 'package:health/pages/Social/profileMeasuresDetails.dart';
import 'package:health/scoped_models/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared-data.dart';
import '../Settings.dart';

var name;
var check = true;
String email;
String phone;
String image;
String tokenId;
String hight;
String birthDate;
String provider;
String providerId;
String specialistId;
String deletedAt;
String createdAt;
String updatedAt;
int id;
int gender;
int generatedCode;
int type;
int state;
int searchCode;
int rating;

class FriendsPage extends StatefulWidget {
  final MainModel model;
  bool fullScreen;

  FriendsPage(this.model,this.fullScreen);

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage>
    with SingleTickerProviderStateMixin {
  Response response;
  Dio dio = new Dio();
  Response response2;
  Dio dio2 = new Dio();
  Response response3;
  Dio dio3 = new Dio();
  TabController _tabController;
  List<DataListBean> followers = List<DataListBean>();
  List<DataListBean2> following = List<DataListBean2>();

  @override
  void initState() {
    _tabController = TabController(vsync: this, initialIndex: 0, length: 2);
    super.initState();
    setState(() {
      Settings.currentIndex = 2;
    });
    getAll();
  }


  getAll() {
    widget.model.getFollowers().then((result) {
      if (result != null) {
        setState(() {
          followers = result.data;
          print('******@@@@@@@@@@@!!!!!!!!!!!!! hi');
          print(
              '############################# Result followers= > ${followers}');
//          setState(() {
//            loading = false;
//          });
        });
      } else {}
    });
    setState(() {});
    print('************************************');
    widget.model.getFollowing().then((result) {
      print('#########################################');
      print(' Result following = > ${result.data[0].name}');
      setState(() {});
      if (result != null) {
        setState(() {
          following = result.data;
//          setState(() {
//            loading = false;
//          });
        });
        following = result.data;
        setState(() {});
        print('FROM THE FOLLOWING SETSTAT');
      } else {}
    }).catchError((err) {
      print(err);
    });
    setState(() {});
  }

  TextEditingController hiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: allTranslations.currentLanguage == "ar"
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: new Scaffold(
          appBar: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width, 44),
            child: Material(
              elevation: 4,
              child: Container(
                alignment: Alignment.center,
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                margin: EdgeInsets.fromLTRB(20, 0, 20, 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: TextField(
                          controller: hiController,
                          onChanged: (value) async {
                            try {
                              setState(() {
                                check = true;
                              });
                              FormData formdata = new FormData();
                              // get user token
                              SharedPreferences sharedPreferences =
                                  await SharedPreferences.getInstance();
                              Map<String, dynamic> authUser = jsonDecode(
                                  sharedPreferences.getString("authUser"));
                              dio.options.headers = {
                                "Authorization":
                                    "Bearer ${authUser['authToken']}",
                              };
                              print(
                                  "SharedData.customerData ====> ${SharedData.customerData['id']}");
                              formdata.forEach((e, r) {
                                print('{${e} : ${r}}');
                              });

                              response = await dio.get(
                                  "http://api.sukar.co/api/auth/searchCode/$value");
                              print('Respnsee --- > ${response.data}');

                              if (response.data.isEmpty) {
                                setState(() {
                                  check = true;
                                  print('====== Null ======');
                                });
                              } else {
                                setState(() {
                                  check = false;
                                  print('====== check ======');
                                });
                              }
                              setState(() {
                                name = response.data['name'].toString();
                                image = response.data['image'].toString();
                                state = response.data['state'];
                                id = response.data['id'];
//                                print(image);
//                                print(state);
                              });
                              if (response.statusCode != 200 &&
                                  response.statusCode != 201) {
                                return false;
                              } else {
                                return true;
                              }
                            } on DioError catch (e) {
                              print("errrrrrrrrrrrrrrrrrrroooooooorrrrrrrrr");
                              print(e);
                              print('*****************************************************************');
                              print(e.response.data);
                              return false;
                            }
                          },
                          enabled: true,
                          decoration: InputDecoration(
                              labelText:
                                  allTranslations.text('Search name or id'),
                              fillColor: Colors.grey.shade300,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10.0)),
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 0, color: Colors.white),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 0, color: Colors.white))),
                        ),
                      ),
                    ),
widget.fullScreen? IconButton(icon: Icon(Icons.arrow_forward_ios), onPressed: ()=>Navigator.of(context).pop()):Container(),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 6),
//                       child: Image.asset("assets/icons/ic_add_friends.png"),
//                     ),
                  ],
                ),
              ),
            ),
          ),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
            child: Column(
              children: <Widget>[
                check == true
                    ? Text('')
                    : Column(
                        children: <Widget>[
                          Container(
//        color: index % 2 == 0 ? Colors.white : Colors.grey[100],
                            child: ListTile(
                              onTap: () {
//                    Navigator.of(context).push(MaterialPageRoute(
//                        builder: (context) => Chat(isDoctor: false)));
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                              },
                              leading: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: image == 'Null'
                                            ? NetworkImage(
                                                'https://i.pinimg.com/originals/7c/c7/a6/7cc7a630624d20f7797cb4c8e93c09c1.png')
                                            : NetworkImage(
                                                'http://api.sukar.co/${image}'))),
                              ),
                              title: Text(
                                name,
                                style: TextStyle(
                                    color: Color.fromRGBO(112, 113, 113, 1)),
                              ),
                              trailing: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: FlatButton(
                                  child: Image.asset(
                                    "assets/icons/ic_remove_friend.png",
                                    fit: BoxFit.cover,
                                  ),
                                  padding: EdgeInsets.all(0),
                                  onPressed: () async {
                                    //add friend search
                                    try {
                                      // get user token
                                      SharedPreferences sharedPreferences =
                                          await SharedPreferences.getInstance();
                                      Map<String, dynamic> authUser =
                                          jsonDecode(sharedPreferences
                                              .getString("authUser"));
                                      dio3.options.headers = {
                                        "Authorization":
                                            "Bearer ${authUser['authToken']}",
                                      };

                                      response3 = await dio3.post(
                                          "http://api.sukar.co/api/follow/$id");
                                      getAll();
                                      check = true;
                                      hiController.clear();
                                      FocusScope.of(context)
                                          .requestFocus(new FocusNode());
                                      print(
                                          'nag7naaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
                                      print('Response = ${response3.data}');
                                      setState(() {

                                      });
                                    } on DioError catch (e) {
                                      print("sa2tnaaaaaaaaaaaaaaaaaaaaaaaaaa");
                                      print(e.response.data);
                                      return false;
                                    }
                                    return true;
                                  },
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            height: 3,
                            color: Colors.grey,
                          )
                        ],
                      ),
                Divider(
                  height: 2,
                ),
                Expanded(
                    child: Container(
                  margin: EdgeInsets.only(bottom: 10),
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                                    child: TabBar(
                                      controller: _tabController,
                                      labelColor: Colors.blue,
                                      indicatorColor: Colors.blue,
                                      labelPadding: EdgeInsets.all(3),
                                      tabs: <Widget>[
                                        Text(
                                          allTranslations.text('Followers'),
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  106, 106, 106, 1.0)),
                                        ),
                                        Text(
                                          allTranslations.text('Following'),
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  106, 106, 106, 1.0)),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                      child: TabBarView(
                                    controller: _tabController,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    children: <Widget>[
                                      following.isEmpty
                                          ? Center(
                                              child: Text(
                                                allTranslations
                                                    .text('emptyFollowing'),
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                          : ListView.builder(
                                              itemCount: following.length,
                                              itemBuilder: (context, index) {
                                                return new Column(
                                                  children: <Widget>[
                                                    Container(
                                                      color: index % 2 == 0
                                                          ? Colors.white
                                                          : Colors.grey[100],
                                                      child: ListTile(
                                                        onTap: () {
//                    Navigator.of(context).push(MaterialPageRoute(
//                        builder: (context) => Chat(isDoctor: false)));
                                                        },
                                                        leading: new Container(
                                                          width: 40,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              image: DecorationImage(
                                                                  image: following[index]
                                                                              .image ==
                                                                          'Null'
                                                                      ? NetworkImage(
                                                                          'https://i.pinimg.com/originals/7c/c7/a6/7cc7a630624d20f7797cb4c8e93c09c1.png')
                                                                      : NetworkImage(
                                                                          'http://api.sukar.co/${following[index].image}'),
                                                                  fit: BoxFit
                                                                      .fill),
                                                              color:
                                                                  Colors.blue),
                                                        ),
                                                        title: new Text(
                                                          following[index].name,
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      112,
                                                                      113,
                                                                      113,
                                                                      1)),
                                                        ),
                                                        trailing: new Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: <Widget>[
                                                            new InkWell(
                                                                child:
                                                                    Image.asset(
                                                                  "assets/icons/ic_chart.png",
                                                                  width: 60,
                                                                ),
                                                                onTap: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .push(MaterialPageRoute(
                                                                          builder:
                                                                              (context) {
                                                                    return ProfileMeasurementDetails(following[index].id);
                                                                  }));
                                                                }),
                                                            following[index]
                                                                        .state ==
                                                                    2
                                                                ? new IconButton(
                                                                    icon: Image
                                                                        .asset(
                                                                      "assets/icons/ic_remove.png",
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(0),
                                                                    onPressed:
                                                                        () async {
                                                                      try {
                                                                        print(
                                                                            'AAAAAAAAAAAAAAAA&&&&&&&&&&AAAAAAAAAAAA');
                                                                        // get user token
                                                                        SharedPreferences
                                                                            sharedPreferences =
                                                                            await SharedPreferences.getInstance();
                                                                        Map<String,
                                                                                dynamic>
                                                                            authUser =
                                                                            jsonDecode(sharedPreferences.getString("authUser"));
                                                                        dio.options
                                                                            .headers = {
                                                                          "Authorization":
                                                                              "Bearer ${authUser['authToken']}",
                                                                        };
                                                                        print(
                                                                            'KABL AL POST');
                                                                        response =
                                                                            await dio.post("http://api.sukar.co/api/unfollow/${following[index].id}");
                                                                        print(
                                                                            'Response = ${response.data}');
                                                                        print(
                                                                            'BEFORE THE GET ALL');
                                                                        setState(
                                                                            () {});
                                                                        print(
                                                                            'abl al GETALL');
                                                                        //getAll();
                                                                        print(
                                                                            'ba3d al GETALL');

                                                                        print(
                                                                            'after THE GET ALL');
                                                                        following
                                                                            .removeAt(index);
                                                                        following.isEmpty
                                                                            ? print('a7ba tete')
                                                                            : print('somaksommak');
                                                                        setState(
                                                                            () {});
                                                                      } on DioError catch (e) {
                                                                        print(
                                                                            "errrrrrrrrrrrrrrrrrrroooooooorrrrrrrrr");
                                                                        print(e
                                                                            .response
                                                                            .data);
                                                                        return false;
                                                                      }
                                                                      return true;
                                                                    },
                                                                  )
                                                                : new IconButton(
                                                                    icon: Image
                                                                        .asset(
                                                                      "assets/icons/ic_add_friend.png",
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(0),
                                                                    onPressed:
                                                                        () async {
                                                                      print(
                                                                          'here ea 3l2');
                                                                      try {
                                                                        // get user token
                                                                        SharedPreferences
                                                                            sharedPreferences =
                                                                            await SharedPreferences.getInstance();
                                                                        Map<String,
                                                                                dynamic>
                                                                            authUser =
                                                                            jsonDecode(sharedPreferences.getString("authUser"));
                                                                        dio.options
                                                                            .headers = {
                                                                          "Authorization":
                                                                              "Bearer ${authUser['authToken']}",
                                                                        };

                                                                        response =
                                                                            await dio.post("http://api.sukar.co/api/unfollow/${following[index].id}");
                                                                        print(
                                                                            'Response = ${response.data}');
                                                                        getAll();
                                                                        following
                                                                            .removeAt(index);
                                                                        following.isEmpty
                                                                            ? print('FAAAAAAAAADDDDDDDEEEEEEEe')
                                                                            : print(following);
                                                                        setState(
                                                                            () {});
                                                                      } on DioError catch (e) {
                                                                        print(
                                                                            "errrrrrrrrrrrrrrrrrrroooooooorrrrrrrrr");
                                                                        print(e
                                                                            .response
                                                                            .data);
                                                                        return false;
                                                                      }
                                                                      return true;
                                                                    },
                                                                  )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Divider(
                                                      height: 3,
                                                      color: Colors.grey,
                                                    )
                                                  ],
                                                );
                                              }),
                                      followers.isEmpty
                                          ? Center(
                                              child: Text(
                                              allTranslations
                                                  .text('emptyFollowers'),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ))
                                          : ListView.builder(
                                              itemCount: followers.length,
                                              itemBuilder: (context, index) {
                                                return new Column(
                                                  children: <Widget>[
                                                    Container(
                                                      color: index % 2 == 0
                                                          ? Colors.white
                                                          : Colors.grey[100],
                                                      child: ListTile(
                                                        onTap: () {
//                    Navigator.of(context).push(MaterialPageRoute(
//                        builder: (context) => Chat(isDoctor: false)));
                                                        },
                                                        leading: new Container(
                                                          width: 40,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              image: DecorationImage(
                                                                  image: followers[index]
                                                                              .image ==
                                                                          'Null'
                                                                      ? NetworkImage(
                                                                          'https://i.pinimg.com/originals/7c/c7/a6/7cc7a630624d20f7797cb4c8e93c09c1.png')
                                                                      : NetworkImage(
                                                                          'http://api.sukar.co/${followers[index].image}'),
                                                                  fit: BoxFit
                                                                      .fill),
                                                              color:
                                                                  Colors.blue),
                                                        ),
                                                        title: new Text(
                                                          followers[index].name,
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      112,
                                                                      113,
                                                                      113,
                                                                      1)),
                                                        ),
                                                        trailing: new Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: <Widget>[
                                                            new InkWell(
                                                                child:
                                                                    Image.asset(
                                                                  "assets/icons/ic_chart.png",
                                                                  width: 60,
                                                                ),
                                                                onTap: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .push(MaterialPageRoute(
                                                                          builder:
                                                                              (context) {
                                                                    return ProfileMeasurementDetails(followers[index].id);
                                                                  }));
                                                                }),
                                                            followers[index]
                                                                        .state ==
                                                                    0
                                                                ? new IconButton(
                                                                    icon: Image
                                                                        .asset(
                                                                      "assets/icons/ic_remove.png",
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(0),
                                                                    onPressed:
                                                                        () async {
                                                                      try {
                                                                        // get user token
                                                                        SharedPreferences
                                                                            sharedPreferences =
                                                                            await SharedPreferences.getInstance();
                                                                        Map<String,
                                                                                dynamic>
                                                                            authUser =
                                                                            jsonDecode(sharedPreferences.getString("authUser"));
                                                                        dio2.options
                                                                            .headers = {
                                                                          "Authorization":
                                                                              "Bearer ${authUser['authToken']}",
                                                                        };
                                                                        response2 =
                                                                            await dio2.post("http://api.sukar.co/api/unfollow/${followers[index].id}");
                                                                        print(
                                                                            'Response = ${response.data}');
                                                                      } on DioError catch (e) {
                                                                        print(
                                                                            "errrrrrrrrrrrrrrrrrrroooooooorrrrrrrrr");
                                                                        print(e
                                                                            .response
                                                                            .data);
                                                                        return false;
                                                                      }
                                                                      return true;
                                                                    },
                                                                  )
                                                                : new IconButton(
                                                                    icon: Image
                                                                        .asset(
                                                                      "assets/icons/ic_remove_friend.png",
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(0),
                                                                    onPressed:
                                                                        () async {
                                                                      try {
                                                                        // get user token
                                                                        SharedPreferences
                                                                            sharedPreferences =
                                                                            await SharedPreferences.getInstance();
                                                                        Map<String,
                                                                                dynamic>
                                                                            authUser =
                                                                            jsonDecode(sharedPreferences.getString("authUser"));
                                                                        dio2.options
                                                                            .headers = {
                                                                          "Authorization":
                                                                              "Bearer ${authUser['authToken']}",
                                                                        };

                                                                        response2 =
                                                                            await dio2.post("http://api.sukar.co/api/follow/${followers[index].id}");
                                                                        print(
                                                                            'Response = ${response.data}');
                                                                      } on DioError catch (e) {
                                                                        print(
                                                                            "errrrrrrrrrrrrrrrrrrroooooooorrrrrrrrr");
                                                                        print(e
                                                                            .response
                                                                            .data);
                                                                        return false;
                                                                      }
                                                                      return true;
                                                                    },
                                                                  )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Divider(
                                                      height: 3,
                                                      color: Colors.grey,
                                                    )
                                                  ],
                                                );
                                              }),
                                    ],
                                  ))
                                ],
                              ),
                            )),
                      )
                    ],
                  ),
                ))
              ],
            ),
          ),
        )
//          Center(
//            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.center,
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                Container(
//                  padding: EdgeInsets.all(20),
//                  margin: EdgeInsets.only(bottom: 20),
//                  decoration: BoxDecoration(
//                      borderRadius: BorderRadius.all(Radius.circular(100)),
//                      color: Colors.redAccent
//                  ),
//                  child: Icon(
//                    Icons.developer_mode,
//                    size: 60,
//                    color: Colors.white,
//                  ),
//                ),
//                Text('Under Development',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),)
//              ],
//            ),
//          )

        );
  }
}
