import 'package:flutter/material.dart';

import 'package:health/languages/all_translations.dart';
import 'package:health/pages/Social/ProfieChart.dart';


class Chat extends StatefulWidget {
  bool isDoctor = false;
  Chat({this.isDoctor});
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  FocusNode _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: allTranslations.currentLanguage == "ar"
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: GestureDetector(
            onTap: () {
              _focusNode.unfocus();
            },
            child: Scaffold(
                body: SafeArea(
              child: Column(
                children: <Widget>[
                  Card(
                    child: Row(
                      children: <Widget>[
                        InkWell(
                          child: Image.asset(
                            "assets/icons/ic_back.png",width: 25,height: 25,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        ClipOval(
                            child: Image.asset(
                          "assets/imgs/profile.jpg",
                          width: 40,
                          height: 40,
                        )),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Dr.Sam Bladwin",
                              style: TextStyle(
                                  color: Color.fromRGBO(12, 163, 214, 1)),
                            ),
                      
                                Text("online",style: TextStyle(
                                  color: Colors.grey))
                          ],
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 0,
                          ),
                        ),
                      widget.isDoctor?SizedBox(height: 0,width: 0,):  InkWell(
                          child: Image.asset("assets/icons/ic_chart.png",width: 40,height: 40,),
                          onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProfileChart()));},
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                        padding: EdgeInsets.all(20),
                        child: ListView.builder(
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.fromLTRB(
                                  index % 2 == 0 ? 0 : 50,
                                  0,
                                  index % 2 == 0 ? 50 : 0,
                                  20),
                              decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  color: index % 2 == 0
                                      ? Color.fromRGBO(232, 244, 251, 1)
                                      : Color.fromRGBO(0, 159, 208, 1)),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 4),
                                    child: Text(
                                      "bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla",
                                      style: TextStyle(
                                          color: index % 2 == 0
                                              ? Color.fromRGBO(136, 142, 158, 1)
                                              : Colors.white),
                                    ),
                                  ),
                                  Align(
                                    child: Text(
                                      "10 :35 AM",
                                      style: TextStyle(
                                          color: index % 2 == 0
                                              ? Color.fromRGBO(181, 190, 202, 1)
                                              : Color.fromRGBO(14, 14, 14, 1)),
                                    ),
                                    alignment: index % 2 == 0
                                        ? Alignment.centerLeft
                                        : Alignment.centerRight,
                                  )
                                ],
                              ),
                              alignment: index % 2 == 0
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                            );
                          },
                        )),
                  ),
                  Divider(
                    height: 2,
                    color: Colors.grey,
                  ),

                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Image.asset("assets/icons/ic_emoticon.png",width: 25,height: 25,),
                          ),
                          Expanded(
                            child: TextField(
                              focusNode: _focusNode,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: allTranslations.text("Write message ...")),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                            child:
                                Image.asset("assets/icons/ic_send_button.png",width: 25,height: 25,),
                          ),
                          Text(
                         allTranslations.text(   "send"),
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      ))
                ],
              ),
            ))));
  }
}
