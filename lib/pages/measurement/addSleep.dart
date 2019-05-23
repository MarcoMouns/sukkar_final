import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:health/Models/sleepTime.dart';
import 'package:health/languages/all_translations.dart';
import 'package:intl/intl.dart' as intl;


class AddSleep extends StatefulWidget {
  @override
  _AddSleepState createState() => _AddSleepState();
}

class _AddSleepState extends State<AddSleep> {
  List<SleepTime> _sleepingTime = List();
  String now = "";
  _getTime() async {
    now = intl.DateFormat("yyyy MMM dd", allTranslations.locale.languageCode)
        .format(DateTime.now());
    setState(() {});
  }

  _getDummySleepingTime() {
    
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
            title: Text(allTranslations.text("Add sleep")),
            centerTitle: true,
          ),
          body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          now,
                          style: TextStyle(color: Colors.red, fontSize: 25.0),
                        ),
                        subtitle: Text(
                          intl.DateFormat("h:m a",allTranslations.locale.languageCode).format(DateTime.now()),
                          style: TextStyle(color: Colors.red),
                        ),
                        trailing: Image.asset(
                          "assets/icons/ic_list_sleep.png",width: 50,height: 50,
                          color: Colors.blue,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30, bottom: 40),
                        child: Text(
                          allTranslations.text(
                              "measure blood Preassure reg. it's fast and donsn't hurt and it's the only way to know weather your blood preassure is high or not"),
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
                                allTranslations.text("add duration"),
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
                              _bottomSheetTimePicker();
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Column(
                            children: _sleepingTime.map((sleepTime) {
                          return Column(
                            children: <Widget>[
                              ListTile(
                                title: Text(
                                  sleepTime.duration,
                                  style: TextStyle(
                                      color: Colors.blue[300], fontSize: 20),
                                ),
                                subtitle: Text(
                                  sleepTime.time,
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.blueGrey),
                                ),
                                trailing: InkWell(
                                  child:
                                      ImageIcon(AssetImage("assets/icons/ic_trash.png"),color: Colors.red,),
                                  onTap: () {
                                    _sleepingTime.remove(sleepTime);
                                    setState(() {});
                                  },
                                ),
                              ),
                              Divider(
                                height: 16,
                                color: Colors.blueGrey,
                              )
                            ],
                          );
                        }).toList()),
                      )
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: FlatButton(
                    color: Color(0xff009DDC),
                    child: Text(
                      allTranslations.text("save"),
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }

  _bottomSheetTimePicker() {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(_addSleepTime);
        });
  }

  _addSleepTime(String duration, String time) {
    _sleepingTime.add(SleepTime(duration: duration, time: time));
    setState(() {});
  }
}

class CustomDialog extends StatefulWidget {
  @override
  _CustomDialogState createState() => _CustomDialogState();
 final  _addSleepTime;
  CustomDialog(this._addSleepTime);
}

class _CustomDialogState extends State<CustomDialog> {
  PageController _controller = PageController();
  DateTime from = DateTime.now();
  DateTime to = DateTime.now();
  _save() {
    DateTime duration =
        to.subtract(Duration(hours: from.hour, minutes: from.minute));
    widget._addSleepTime(
        " ${allTranslations.text("hour")} ${duration.hour} ,${allTranslations.text("minute")} ${duration.minute}",
        "${allTranslations.text("from")} ${from.hour.toString()}:${from.minute.toString()} ${allTranslations.text("to")} ${to.hour.toString()}:${to.minute.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Material(
        elevation: 24.0,
        type: MaterialType.card,
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width,
          child: PageView.builder(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 2,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: index == 0
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: <Widget>[
                  FlatButton(
                    textColor: Colors.blue,
                    child: Row(
                      textDirection:
                          index == 1 ? TextDirection.ltr : TextDirection.rtl,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        index == 0
                            ? SizedBox(
                                width: 0,
                                height: 0,
                              )
                            : FlatButton(
                                child: Text(allTranslations.text("save")),
                                textColor: Colors.blue,
                                onPressed: () {
                                  _save();
                                  Navigator.pop(context);
                                },
                              ),
                        Text(
                          index == 0
                              ? allTranslations.text("from")
                              : allTranslations.text("to"),
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                        Text(
                          index == 0
                              ? allTranslations.text("next")
                              : allTranslations.text("back"),
                          textAlign: TextAlign.end,
                        )
                      ],
                    ),
                    onPressed: () {
                      if (_controller.page == 1.0) {
                        _controller.animateToPage(0,
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeInOut);
                      } else {
                        _controller.animateToPage(1,
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeInOut);
                      }
                    },
                  ),
                  Expanded(
                    child: CupertinoDatePicker(
                      initialDateTime: DateTime.now(),
                      onDateTimeChanged: (value) {
                        if (index == 0) {
                          from = value;
                        } else {
                          to = value;
                        }
                      },
                      mode: CupertinoDatePickerMode.time,
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
