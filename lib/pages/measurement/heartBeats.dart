import 'package:flutter/material.dart';
import 'package:health/Models/heartBeats.dart';

import 'package:health/languages/all_translations.dart';
import 'package:health/scoped_models/main.dart';
import 'package:intl/intl.dart' as intl;

class HeartBeats extends StatefulWidget {
  MainModel model;

  HeartBeats(this.model);

  @override
  _HeartBeatsState createState() => _HeartBeatsState();
}

class _HeartBeatsState extends State<HeartBeats> {
  String now;
  List<HeartBeat> heartBeats;
  var hearts;
  _getTime() async {
    now = intl.DateFormat("yyyy MMM dd", allTranslations.locale.languageCode)
        .format(DateTime.now());
    setState(() {});
  }

  _getDummySleepingTime() {
    heartBeats = List();
    heartBeats.add(HeartBeat(count: "80/100", date:  intl.DateFormat("dd MMM",allTranslations.locale.languageCode).format(DateTime.now())));
    // _sleepingTime.add(SleepTime(duration: "hours", time: "7aba w shoia"));
    // _sleepingTime.add(SleepTime(duration: "hours", time: "7aba w shoia"));
    /// _sleepingTime.add(SleepTime(duration: "hours", time: "7aba w shoia"));
    //  _sleepingTime.add(SleepTime(duration: "hours", time: "7aba w shoia"));
  }

  @override
  void initState() {
    _getDummySleepingTime();
    _getTime();
    super.initState();
  }

  Duration timer = const Duration();
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: allTranslations.currentLanguage == "ar"
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(allTranslations.text("add heart beat")),
            centerTitle: true,
          ),
          body:
//          new Center(
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
          new Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          now,
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        subtitle: Text(
                          intl.DateFormat("h:m a",allTranslations.locale.languageCode).format(DateTime.now()),
                          style: TextStyle(color: Colors.red),
                        ),
                        trailing: Image.asset(
                          "assets/icons/ic_list_hear_rate.png",
                          color: Colors.blue,height: 50,width: 50,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30, bottom: 40),
                        child: Text(
                          allTranslations.text("the normal from 61 to 79"),
                          style:
                              TextStyle(color: Colors.blueGrey, fontSize: 17),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          InkWell(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                              child: Text(
                                allTranslations.text("add measurement"),
                                textAlign: TextAlign.center,
                              ),
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.grey[300], width: 1.5),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                            onTap: () {
                              _addMeasurement();
                            },
                          ),
                        ],
                      ),
//                      new Padding(
//                        padding: EdgeInsets.only(top: 20),
//                        child: Column(
//                            children: heartBeats.map((heartBeat) {
//                          return Column(
//                            children: <Widget>[
//                              ListTile(
//                                title: Text(
//                                  heartBeat.count,
//                                  style: TextStyle(
//                                      color: Colors.blue[300], fontSize: 20),
//                                ),
//                                subtitle: Text(
//                                  heartBeat.date,
//                                  style: TextStyle(
//                                      fontSize: 13, color: Colors.blueGrey),
//                                ),
//                                trailing: InkWell(
//                                  child:
//                                   ImageIcon(AssetImage("assets/icons/ic_trash.png"),color: Colors.red,),
//                                  onTap: () {
//                                    heartBeats.remove(heartBeat);
//                                    setState(() {});
//                                  },
//                                ),
//                              ),
//                              Divider(
//                                height: 16,
//                                color: Colors.blueGrey,
//                              )
//                            ],
//                          );
//                        }).toList()),
//                      )
                    ],
                  ),
                ),
//                Container(
//                  width: MediaQuery.of(context).size.width / 1.5,
//                  child: FlatButton(
//                    color: Color(0xff009DDC),
//                    child: Text(
//                      allTranslations.text("save"),
//                      style: TextStyle(color: Colors.white, fontSize: 16),
//                    ),
//                    shape: RoundedRectangleBorder(
//                        borderRadius: BorderRadius.circular(30)),
//                    onPressed: () {
//                      Navigator.pop(context);
//                    },
//                  ),
//                )
              ],
            ),
          ),
        ));
  }

  _addMeasurement() {
    TextEditingController _controller = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Material(
                  type: MaterialType.transparency,
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      height: MediaQuery.of(context).size.height / 3,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FittedBox(
                          child: Column(
                            children: <Widget>[
                              Image.asset("assets/icons/ic_list_hear_rate.png",width: 50,height: 50,),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Text(allTranslations.text("add Heart rate")),
                              ),
                              Container(
                                width: 70,
                                decoration: ShapeDecoration(
                                    color: Colors.grey[300],
                                    shape: RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.all(
                                            Radius.circular(50)))),
                                child: TextField(
                                  textAlign: TextAlign.center,
                                  controller: _controller,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "70",
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SizedBox(),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                width: MediaQuery.of(context).size.width / 1.5,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: FlatButton(
                                  color: Color(0xff009DDC),
                                  child: Text(
                                    allTranslations.text("save"),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  onPressed: () {
                                    _save(_controller.text);
                                    widget.model
                                        .addMeasurements('Heartbeat', hearts)
                                        .then((result) async {
                                      print(result);
                                      Navigator.pop(context);
                                    });
                                  },
                                ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )),
                )),
          );
        });
  }

  void _save(String value) {
    heartBeats.add(HeartBeat(
        count: value,
        date: intl.DateFormat(
          " MMM dd",allTranslations.locale.languageCode
        ).format(DateTime.now())));
    setState(() {
      print('Value $value');
      hearts = value;
    });
  }
}
