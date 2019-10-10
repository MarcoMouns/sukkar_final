import 'package:flutter/material.dart';
import 'package:health/languages/all_translations.dart';
import 'package:health/pages/measurement/itemList.dart';
import 'package:health/scoped_models/main.dart';

import 'package:intl/intl.dart' as intl;
import 'package:keyboard_actions/keyboard_actions.dart';

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
    Locale myLocale = Localizations.localeOf(context);
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
                  Navigator.pop(context);
                },
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.info_outline),
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
//                          _inputText(
//                              allTranslations.text("Diastolic"),
//                              allTranslations.text("normal"),
//                              Colors.blue,
//                              myFocusNode1),
                          new Expanded(
                              child: Column(
                            children: <Widget>[
                              Stack(
                                alignment: Alignment.bottomRight,
                                children: <Widget>[
                                  TextFormField(
                                    focusNode: myFocusNode1,
                                    textDirection: TextDirection.ltr,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                      color:  Colors.blue,
                                      fontSize: 25,
                                    ),
                                    onSaved: (String value) {
                                      print('value => $value');
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
//                          _inputText(
//                              allTranslations.text("Systolic"),
//                              allTranslations.text("danger"),
//                              Colors.red,
//                              myFocusNode2),
                          new Expanded(
                              child: Column(
                                children: <Widget>[
                                  Stack(
                                    alignment: Alignment.bottomRight,
                                    children: <Widget>[
                                      TextFormField(
                                        focusNode: myFocusNode1,
                                        textDirection: TextDirection.ltr,
                                        keyboardType: TextInputType.number,
                                        style: TextStyle(
                                          color:  Colors.red,
                                          fontSize: 25,
                                        ),
                                        onSaved: (String value) {
                                          print('value => $value');
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
//                            _isLoading = false;
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
                        Navigator.of(context).pop();
                        },
                      ),
                    ),
//                  Container(
//                    height: 65,
//                    margin: EdgeInsets.all(3),
//                    decoration: new ShapeDecoration(
//                        color: Colors.white,
//                        shadows: [
//                          BoxShadow(
//                              color: Colors.grey,
//                              spreadRadius: 0.5,
//                              blurRadius: 2)
//                        ],
//                        shape: new RoundedRectangleBorder(
//                            borderRadius: new BorderRadius.all(
//                                Radius.elliptical(100, 100)))),
//                    child:new  Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                      children: <Widget>[
//                        Container(
//                            margin: EdgeInsets.only(right: 10),
//                            child: InkWell(
//                              child: Text(allTranslations.text("Add")),
//                              onTap: () {
//                                myFocusNode1.unfocus();
//                                myFocusNode2.unfocus();
//                                myFocusNode3.unfocus();
//                                Navigator.push(
//                                  context,
//                                  MaterialPageRoute(
//                                      builder: (context) => ItemList(
//                                            isfood: false,
//                                          )),
//                                );
//                              },
//                            ),
//                            padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
//                            decoration: new ShapeDecoration(
//                                color: Colors.white,
//                                shadows: [
//                                  BoxShadow(
//                                      color: Colors.red,
//                                      spreadRadius: 0.5,
//                                      blurRadius: 0)
//                                ],
//                                shape: new RoundedRectangleBorder(
//                                    borderRadius: new BorderRadius.all(
//                                        Radius.circular(10))))),
//                        Padding(
//                          padding: EdgeInsets.all(5),
//                          child: Row(
//                            children: <Widget>[
//                              Text(
//                                allTranslations.text("medicne"),
//                                style: TextStyle(
//                                    color: Colors.blueGrey, fontSize: 22),
//                              ),
//                              SizedBox(
//                                width: 10,
//                              ),
//                              Image.asset(
//                                "assets/icons/ic_med.png",
//                                width: 40,
//                                height: 40,
//                              ),
//                              Align(
//                                alignment: Alignment.topRight,
//                                child: Column(
//                                  children: <Widget>[
//                                    SizedBox(
//                                      height: 10,
//                                    ),
//                                    CircleAvatar(
//                                      backgroundColor: Colors.red,
//                                      radius: 10,
//                                      child: Text(
//                                        "4",
//                                        style: TextStyle(
//                                            decorationColor: Colors.red),
//                                      ),
//                                    )
//                                  ],
//                                ),
//                              ),
//                            ],
//                          ),
//                        )
//                      ],
//                    ),
//                  ),
//                  new Padding(
//                    padding: EdgeInsets.only(top: 30),
//                    child: Container(
//                      decoration: new ShapeDecoration(
//                          color: Color.fromRGBO(218, 218, 218, 1),
//                          shape: new RoundedRectangleBorder(
//                              borderRadius: new BorderRadius.all(
//                                  Radius.elliptical(10, 10)))),
//                      padding: EdgeInsets.all(7),
//                      child: TextField(
//                        focusNode: myFocusNode3,
//                        maxLines: 6,
//                        keyboardType: TextInputType.multiline,
//                        decoration: InputDecoration(
//                            hintText: allTranslations.text("notes..."),
//                            filled: true,
//                            border: InputBorder.none,
//                            fillColor: Color.fromRGBO(218, 218, 218, 1)),
//                      ),
//                    ),
//                  )
                  ],
                ),
              ),
            ),
//              new Center(
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    Container(
//                      padding: EdgeInsets.all(20),
//                      margin: EdgeInsets.only(bottom: 20),
//                      decoration: BoxDecoration(
//                          borderRadius: BorderRadius.all(Radius.circular(100)),
//                          color: Colors.redAccent
//                      ),
//                      child: Icon(
//                        Icons.developer_mode,
//                        size: 60,
//                        color: Colors.white,
//                      ),
//                    ),
//                    Text('Under Development',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),)
//                  ],
//                ),
//              )
          ),
        ));
  }

  Widget _inputText(
      String input, String state, Color color, FocusNode focusNode) {

    return new Expanded(
        child: Column(
      children: <Widget>[
        Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            TextFormField(
              focusNode: focusNode,
              textDirection: TextDirection.ltr,
              keyboardType: TextInputType.number,
              style: TextStyle(
                color: color,
                fontSize: 25,
              ),
              onSaved: (String value) {
                print('value => $value');
              },
            ),
            Text(
              "mmHg",
              style: TextStyle(color: color),
            )
          ],
        ),
        SizedBox(
          height: 6,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(2.3),
              color: color,
              child: Text(
                state,
                style: TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                input,
                style: TextStyle(color: Colors.blueGrey),
              ),
            )
          ],
        ),
        SizedBox(
          height: 30,
        ),
      ],
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
                      _bottomSheetItem(Colors.blue),
                      _bottomSheetItem(Colors.orange),
                      _bottomSheetItem(Colors.red),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  Widget _bottomSheetItem(Color color) {
    return Padding(
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
              allTranslations.text("normal"),
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
                "${allTranslations.text("maore than")} 10",
                style: TextStyle(color: Colors.grey),
              ),
              Text(
                "${allTranslations.text("maore than")} 20",
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
    );
  }
}
