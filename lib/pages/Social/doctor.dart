import 'package:flutter/material.dart';
import 'package:health/Settings.dart';

import 'package:health/languages/all_translations.dart';
import 'package:health/pages/Social/chat.dart';
import 'package:health/pages/Social/doctorProfile.dart';

class Doctor extends StatefulWidget {
  @override
  _DoctorState createState() => _DoctorState();
}

class _DoctorState extends State<Doctor> {
  List<String> _doctors = List();
  @override
  void initState() {
    for (int i = 0; i < 30; i++) {
      _doctors.add("Dr.Sam");
    }
    super.initState();
  }

  _showBottomSheet(context) {
    showDialog(
        context: context,
        builder: (context) {
          return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Material(
                  type: MaterialType.transparency,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(bottom: 7),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        child: Container(
                            height: MediaQuery.of(context).size.height / 1.75,
                            margin: EdgeInsets.fromLTRB(16, 20, 16, 10),
                            child: ListView.builder(
                              itemCount: 30,
                              itemBuilder: (context, index) {
                                return InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          allTranslations
                                              .text("internal medicine"),
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Color.fromRGBO(
                                                  149, 149, 149, 1)),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Divider(
                                              color: Colors.grey[200],
                                              height: 20,
                                            ))
                                      ],
                                    ));
                              },
                            )),
                      )
                    ],
                  )));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            child: Container(
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                width: MediaQuery.of(context).size.width,
                child: Column(children: <Widget>[
                  Search(hintText: "search for doctor"),
                  SizedBox(height: 40,
                    child: InkWell(
                        onTap: () {
                          _showBottomSheet(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 10),

                          decoration: ShapeDecoration(
                              // color: Colors.grey,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                      color: Colors.grey[200], width: 2))),
                          child: Row(
                            children: <Widget>[
                              Image.asset(
                                "assets/icons/ic_doctor.png",
                                width: 20,
                                height: 20,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  allTranslations.text("heart"),
                                  style:
                                      TextStyle(color: Colors.grey, fontSize: 18),
                                ),
                              ),
                              Expanded(
                                child: SizedBox(),
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                color: Colors.blue,
                              )
                            ],
                          ),
                        )),
                  ),
                ])),
            preferredSize: Size(40, 80 )),
        body: ListView(
            children: _doctors.map((name) {
          return Column(
            children: <Widget>[
              ListTile(
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => DoctorProfile())),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage("assets/imgs/profile.jpg"))),
                ),
                trailing: InkWell(
                  child: Image.asset(
                    "assets/icons/ic_message.png",
                    width: 60,
                    height: 60,
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return Chat(
                        isDoctor: true,
                      );
                    }));
                  },
                ),
                title: Text("Dr.sam "),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      allTranslations.text("heart"),
                      style: TextStyle(color: Color.fromRGBO(243, 140, 142, 1)),
                    ),
                    Row(
                      children: <Widget>[
                        Image.asset(
                          "assets/icons/star_on.png",
                          width: 20,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Image.asset(
                          "assets/icons/star_on.png",
                          width: 20,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Image.asset(
                          "assets/icons/star_on.png",
                          width: 20,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Image.asset(
                          "assets/icons/star_off.png",
                          width: 20,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Image.asset(
                          "assets/icons/star_off.png",
                          width: 20,
                        )
                      ],
                    )
                  ],
                ),
              ),
              Divider(
                color: Colors.grey,
                height: 2,
                indent: 20,
              )
            ],
          );
        }).toList()));
  }
}
