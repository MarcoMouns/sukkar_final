import 'package:flutter/material.dart';
import 'package:health/languages/all_translations.dart';
import 'package:health/scoped_models/main.dart';

import 'package:intl/intl.dart' as intl;

import '../home.dart';

class BloodPressure extends StatefulWidget {
  MainModel model;

  BloodPressure(this.model);

  @override
  State<StatefulWidget> createState() {
    return _BloodPressureState();
  }
}

class _BloodPressureState extends State<BloodPressure> {
  FocusNode myFocusNode1, myFocusNode2, myFocusNode3;
  String now;

  @override
  void initState() {
    now = intl.DateFormat("yyyy MMM dd", allTranslations.locale.languageCode)
        .format(DateTime.now());

    super.initState();
    myFocusNode1 = FocusNode();
    myFocusNode2 = FocusNode();
    myFocusNode3 = FocusNode();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var SystolicPressure;
  var DiastolicPressure;

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: allTranslations.currentLanguage == "ar"
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: GestureDetector(
          onTap: () {
            myFocusNode1.unfocus();
            myFocusNode2.unfocus();
            myFocusNode3.unfocus();
          },
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  myFocusNode1.unfocus();
                  myFocusNode2.unfocus();
                  myFocusNode3.unfocus();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => MainHome()));
                },
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.info_outline,color: Colors.white,),
                  onPressed: () {
                    _showBottomSheetBloodPreassure();
                  },
                ),
              ],
              title: Text(allTranslations.text("blood preasure")),
              centerTitle: true,
            ),
            body: new Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 5,
                    ),
                    ListTile(
                      title: Text(
                        now,
                        style: TextStyle(color: Colors.red, fontSize: 25.0),
                      ),
                      subtitle: Text(
                        intl.DateFormat(
                                "h:m a", allTranslations.locale.languageCode)
                            .format(DateTime.now()),
                        style: TextStyle(color: Colors.red),
                      ),
                      trailing: Image.asset(
                        "assets/icons/ic_blood_pressure.png",
                        height: 50,
                        width: 50,
                        color: Colors.blue,
                      ),
                    ),
                    Text(
                      allTranslations.text(
                          "measure blood Preassure reg. it's fast and donsn't hurt and it's the only way to know weather your blood preassure is high or not"),
                      style: TextStyle(color: Colors.blueGrey, fontSize: 17),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Expanded(
                              child: Column(
                            children: <Widget>[
                              Stack(
                                alignment: Alignment.bottomRight,
                                children: <Widget>[
                                  TextFormField(
                                    maxLength: 3,
                                    textDirection: TextDirection.ltr,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                      color:  Colors.blue,
                                      fontSize: 25,
                                    ),
                                    onSaved: (String value) {
                                      DiastolicPressure = value;
                                    },
                                  ),
                                  Text(
                                    "mmHg",
                                    style: TextStyle(color:  Colors.blue,),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(2.3),
                                    color:  Colors.blue,
                                    child: Text(
                                        allTranslations.text("normal"),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text(
                                        allTranslations.text("Diastolic"),
                                      style: TextStyle(color: Colors.blueGrey),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                            ],
                          )),
                          SizedBox(
                            width: 20,
                          ),
                          new Expanded(
                              child: Column(
                                children: <Widget>[
                                  Stack(
                                    alignment: Alignment.bottomRight,
                                    children: <Widget>[
                                      TextFormField(
                                        maxLength: 3,
                                        textDirection: TextDirection.ltr,
                                        keyboardType: TextInputType.number,
                                        style: TextStyle(
                                          color:  Colors.red,
                                          fontSize: 25,
                                        ),
                                        onSaved: (String value) {
                                          SystolicPressure = value;
                                        },
                                      ),
                                      Text(
                                        "mmHg",
                                        style: TextStyle(color:  Colors.red,),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(2.3),
                                        color:  Colors.red,
                                        child: Text(
                                          allTranslations.text("danger"),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),

                                      Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Text(
                                          allTranslations.text("Systolic"),
                                          style: TextStyle(color: Colors.blueGrey),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      child: RaisedButton(
                        child: Text(allTranslations.text("Add")),
                        color: Colors.blue,
                        textColor: Colors.white,
                        onPressed: () {
                          myFocusNode1.unfocus();
                          myFocusNode2.unfocus();
                          myFocusNode3.unfocus();
                          if (!_formKey.currentState.validate()) {
                            return;
                          }
                          _formKey.currentState.save();
                          widget.model
                              .addMeasurements('SystolicPressure', SystolicPressure)
                              .then((result) async {
                            print(result);
                          });
                          widget.model
                              .addMeasurements('DiastolicPressure', DiastolicPressure)
                              .then((result) async {
                            print(result);
                          });
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => MainHome()));
                        },
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ));
  }


  void _showBottomSheetBloodPreassure() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Align(
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        "assets/icons/ic_list_blood_pressure.png",
                        color: Colors.red,
                        height: 50,
                        width: 50,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        allTranslations.text("blood preassure"),
                        style: TextStyle(color: Colors.red, fontSize: 20),
                      ),
                      _bottomSheetItem(Colors.green,"bloodpresure1","bloodpresure11","normal"),
                      _bottomSheetItem(Colors.orange,"bloodpresure2","bloodpresure22","prehigh"),
                      _bottomSheetItem(Colors.red,"bloodpresure3","bloodpresure33","high"),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  Widget _bottomSheetItem(Color color,String range1 , String range2 , String status) {
    return Directionality(
        textDirection: allTranslations.currentLanguage == "ar"
            ? TextDirection.rtl
            : TextDirection.ltr,
          child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(5.3),
              decoration: ShapeDecoration(
                  color: color,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4))),
              child: Text(
                allTranslations.text(status),
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  allTranslations.text(range1),
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  allTranslations.text(range2),
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  allTranslations.text("Diastolic"),
                  style: TextStyle(fontSize: 25),
                ),
                Text(
                  allTranslations.text("Systolic"),
                  style: TextStyle(fontSize: 25),
                ),
              ],
            ),
            Divider(
              color: Colors.grey,
              indent: 2,
            )
          ],
        ),
      ),
    );
  }
}
