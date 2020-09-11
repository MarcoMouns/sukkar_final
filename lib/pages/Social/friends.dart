import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:health/Models/friends_tab/getFollowers.dart';
import 'package:health/Models/friends_tab/getFollowing.dart';
import 'package:health/languages/all_translations.dart';
import 'package:health/pages/Social/profileMeasuresDetails.dart';
import 'package:health/scoped_models/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  FriendsPage(this.model, this.fullScreen);

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
    // setState(() {
    //   widget.fullScreen ? Settings.currentIndex = 0 : Settings.currentIndex = 2;
    // });
    getAll();
  }

  getAll() async {
    await widget.model.getFollowers().then((result) {
      if (result != null) {
        setState(() {
          followers = result.data;
        });
      } else {}
    });
    setState(() {});
    await widget.model.getFollowing().then((result) {
      setState(() {});
      if (result != null) {
        setState(() {
          following = result.data;
        });
        following = result.data;
        setState(() {});
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
          appBar: AppBar(
            automaticallyImplyLeading: false,
          ),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
            child: Column(
              children: <Widget>[
                Material(
                  elevation: 4,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 10),
                    margin: EdgeInsets.fromLTRB(25, 0, 20, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: TextField(
                              controller: hiController,
                              onChanged: (value) async {
                                try {
                                  setState(() {
                                    check = true;
                                  });
                                  FormData formdata = new FormData();
                                  SharedPreferences sharedPreferences =
                                      await SharedPreferences.getInstance();
                                  Map<String, dynamic> authUser = jsonDecode(
                                      sharedPreferences.getString("authUser"));
                                  dio.options.headers = {
                                    "Authorization":
                                        "Bearer ${authUser['authToken']}",
                                  };

                                  response = await dio.get(
                                      "${Settings.baseApilink}/auth/searchCode/$value");

                                  if (response.data.isEmpty) {
                                    setState(() {
                                      check = true;
                                    });
                                  } else {
                                    setState(() {
                                      check = false;
                                    });
                                  }
                                  setState(() {
                                    name = response.data['name'].toString();
                                    image = response.data['image'].toString();
                                    state = response.data['state'];
                                    id = response.data['id'];
                                  });
                                  if (response.statusCode != 200 &&
                                      response.statusCode != 201) {
                                    return false;
                                  } else {
                                    return true;
                                  }
                                } on DioError catch (e) {
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
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                      borderRadius:
                                          BorderRadius.circular(25.0)),
                                  prefixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 0, color: Colors.white),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25.0))),
                                  disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 0, color: Colors.white))),
                            ),
                          ),
                        ),
                        widget.fullScreen
                            ? IconButton(
                                icon: Icon(Icons.arrow_forward_ios),
                                onPressed: () => Navigator.of(context).pop())
                            : Container(),
                      ],
                    ),
                  ),
                ),
                check == true
                    ? Text('')
                    : Column(
                        children: <Widget>[
                          Container(
                            child: ListTile(
                              onTap: () {
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
                                                'http://api.sukar.co/$image'))),
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
                                          "${Settings.baseApilink}/follow/$id");
                                      getAll();
                                      check = true;
                                      hiController.clear();
                                      FocusScope.of(context)
                                          .requestFocus(new FocusNode());
                                      setState(() {});
                                    } on DioError catch (e) {
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
                                                        onTap: () {},
                                                        leading: Container(
                                                          width: 40,
                                                          height: 40,
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            image:
                                                                DecorationImage(
                                                              fit: BoxFit.fill,
                                                              image: following[
                                                                              index]
                                                                          .image ==
                                                                      'Null'
                                                                  ? NetworkImage(
                                                                      'https://i.pinimg.com/originals/7c/c7/a6/7cc7a630624d20f7797cb4c8e93c09c1.png')
                                                                  : NetworkImage(
                                                                      'http://api.sukar.co/${following[index].image}'),
                                                            ),
                                                          ),
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
                                                                    return ProfileMeasurementDetails(
                                                                        following[index]
                                                                            .id);
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
                                                                            await dio.post("${Settings.baseApilink}/unfollow/${following[index].id}");
                                                                        setState(
                                                                            () {});

                                                                        following
                                                                            .removeAt(index);
                                                                        setState(
                                                                            () {});
                                                                      } on DioError catch (e) {
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
                                                                            await dio.post("${Settings.baseApilink}/unfollow/${following[index].id}");
                                                                        getAll();
                                                                        following
                                                                            .removeAt(index);
                                                                        setState(
                                                                            () {});
                                                                      } on DioError catch (e) {
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
                                                        onTap: () {},
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
                                                                    return ProfileMeasurementDetails(
                                                                        followers[index]
                                                                            .id);
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
                                                                            await dio2.post("${Settings.baseApilink}/unfollow/${followers[index].id}");
                                                                      } on DioError catch (e) {
                                                                        print(
                                                                            e);
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
                                                                            await dio2.post("${Settings.baseApilink}/follow/${followers[index].id}");
                                                                      } on DioError catch (e) {
                                                                        print(
                                                                            e);
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
        ));
  }
}
