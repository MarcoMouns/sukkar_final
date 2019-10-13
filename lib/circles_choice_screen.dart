import 'package:flutter/material.dart';

class CirclesChoiceScreen extends StatefulWidget {
  @override
  _CirclesChoiceScreenState createState() => _CirclesChoiceScreenState();
}

class _CirclesChoiceScreenState extends State<CirclesChoiceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("change circles"),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 10)),
              ListTile(
                title: Row(
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: Image.asset('assets/icons/ic_cal.png')
                    ),
                    Text("  الكلورى ")
                  ],
                ),
                trailing: Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red
                  ),
                  child: Icon(Icons.check,color: Colors.white,size: 30,),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width *0.9,
                child: Divider(
                  thickness: 0.7,
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              ListTile(
                title: Row(
                  children: <Widget>[
                    SizedBox(
                        height: 50,
                        width: 50,
                        child: Image.asset('assets/icons/ic_cup.png')
                    ),
                    Text("  عدد اكواب المياة ")
                  ],
                ),
                trailing: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width *0.9,
                child: Divider(
                  thickness: 0.7,
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              ListTile(
                title: Row(
                  children: <Widget>[
                    SizedBox(
                        height: 50,
                        width: 50,
                        child: Image.asset('assets/icons/ic_heart_rate.png')
                    ),
                    Text("  ضربات القلب ")
                  ],
                ),
                trailing: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width *0.9,
                child: Divider(
                  thickness: 0.7,
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              ListTile(
                title: Row(
                  children: <Widget>[
                    SizedBox(
                        height: 50,
                        width: 50,
                        child: Image.asset('assets/icons/ic_steps.png')
                    ),
                    Text("  عدد الخطوات ")
                  ],
                ),
                trailing: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width *0.9,
                child: Divider(
                  thickness: 0.7,
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              ListTile(
                title: Row(
                  children: <Widget>[
                    SizedBox(
                        height: 50,
                        width: 50,
                        child: Image.asset('assets/icons/ic_location.png')
                    ),
                    Text("  المسافة ")
                  ],
                ),
                trailing: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
