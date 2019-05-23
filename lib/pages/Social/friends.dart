import 'package:flutter/material.dart';
import 'package:health/Settings.dart';

import 'package:health/languages/all_translations.dart';
import 'package:health/pages/Social/chat.dart';
import 'package:health/pages/Social/ProfieChart.dart';

class FriendsPage extends StatefulWidget {
  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {

  @override
  Widget build(BuildContext context) {
    return  Directionality(
          textDirection: allTranslations.currentLanguage == "ar"
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size(MediaQuery.of(context).size.width, 44),
              child: Material(
                elevation: 4,
                child: Container(
                  alignment: Alignment.center,padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  margin: EdgeInsets.fromLTRB(20,0,20,4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1),
                          child: Search(
                              hintText:
                                 "Search name or id"),
                        ),
                      ),
                     Padding(
                       padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 6),
                       child: Image.asset("assets/icons/ic_add_friends.png"),
                     ),

                    ],
                  ),
                ),
              ),
            ),
            body: Column(
              children: <Widget>[
                _newestTalk(context),
                Divider(height: 2,),
                Expanded(child: _FollowingAndFollowers())
              ],
            ),
          )
    );
  }
}

class _FollowingAndFollowers extends StatefulWidget {
  @override
  __FollowingAndFollowersState createState() => __FollowingAndFollowersState();
}

class __FollowingAndFollowersState extends State<_FollowingAndFollowers>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(vsync: this, initialIndex: 0, length: 2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                          tabs: <Widget>[
                            Text(
                              allTranslations.text("Followers"),
                              style: TextStyle(
                                  color: Color.fromRGBO(106, 106, 106, 1.0)),
                            ),
                            Text(
                              allTranslations.text("Following"),
                              style: TextStyle(
                                  color: Color.fromRGBO(106, 106, 106, 1.0)),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                          child: TabBarView(
                        controller: _tabController,
                        physics: AlwaysScrollableScrollPhysics(),
                        children: <Widget>[_peopleList(), _peopleList()],
                      ))
                    ],
                  ),
                )),
          )
        ],
      ),
    );
  }

  Widget _peopleList() {
    return ListView.builder(
        itemCount: 30,
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              Container(
                color: index % 2 == 0 ? Colors.white : Colors.grey[100],
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Chat(isDoctor: false)));
                  },
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage("assets/imgs/profile.jpg"))),
                  ),
                  title: Text(
                    "marvin Nichols",
                    style: TextStyle(color: Color.fromRGBO(112, 113, 113, 1)),
                  ),
                  subtitle: Text(
                    "35cal",
                    style: TextStyle(color: Color.fromRGBO(242, 128, 129, 1)),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      InkWell(
          
                          child: Image.asset(
                            "assets/icons/ic_chart.png",
                            width: 60,
                          ),
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return ProfileChart(isMyProfile: false,date: "");
                            }));
                          }),
                      index % 2 == 0
                          ? Image.asset(
                              "assets/icons/ic_remove.png",
                              width: 60,
                            )
                          : Image.asset(
                              "assets/icons/ic_remove_friend.png",
                              width: 60,
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
        });
  }
}

Widget _newestTalk(context) {
  return Container(
    height: 150,
    width: MediaQuery.of(context).size.width,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Text(
              allTranslations.text("Newest Talks"),
              style: TextStyle(
                  fontSize: 20, color: Color.fromRGBO(137, 137, 139, 1)),
            ),
          ),
        ),
        
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (context, index) {
              return Padding(
                  padding: EdgeInsets.only(right: 10, left: 10),
                  child: InkWell(
                 
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Chat(
                                  isDoctor: false,
                                )));
                      },
                      child: Column(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: index % 2 == 0
                                            ? Color.fromRGBO(13, 156, 205, 1)
                                            : Colors.grey,
                                        width: 2),
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "assets/imgs/profile.jpg"))),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: CircleAvatar(
                                  radius: 10,
                                  backgroundColor: Colors.redAccent,
                                  child: Text(
                                    "4",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Text(allTranslations.text("name")),
                          )
                        ],
                      )));
            },
          ),
        )
      ],
    ),
  );
}
