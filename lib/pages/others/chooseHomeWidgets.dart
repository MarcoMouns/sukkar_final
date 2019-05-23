import 'package:flutter/material.dart';

class ChooseMainWidgets extends StatefulWidget {
  final Widget child;

  ChooseMainWidgets({Key key, this.child}) : super(key: key);

  _ChooseMainWidgetsState createState() => _ChooseMainWidgetsState();
}

class _ChooseMainWidgetsState extends State<ChooseMainWidgets> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Image.asset("assets/icons/ic_cal.png",width: 40,height: 40,),
            title: Text("cals"),
            trailing: Image.asset("assets/icons/ic_radio_off.png",width: 40,height: 40,),
          ),
          Divider(),
            ListTile(
            leading: Image.asset("assets/icons/ic_cup.png",width: 40,height: 40,),
            title: Text("cups of water"),
            trailing: Image.asset("assets/icons/ic_choose_on.png",width: 40,height: 40,),
          ),Divider(),
            ListTile(
            leading: Image.asset("assets/icons/ic_blood_pressure.png",width: 40,height: 40,),
            title: Text("blood Preasure"),
            trailing: Image.asset("assets/icons/ic_radio_off.png",width: 40,height: 40,),
          ),Divider(),
            ListTile(
            leading: Image.asset("assets/icons/ic_heart_rate.png",width: 40,height: 40,),
            title: Text("Heart rate"),
            trailing: Image.asset("assets/icons/ic_choose_on.png",width: 40,height: 40,),
          ),Divider(),
            ListTile(
            leading: Image.asset("assets/icons/ic_steps.png",width: 40,height: 40,),
            title: Text("number of steps"),
            trailing: Image.asset("assets/icons/ic_radio_off.png",width: 40,height: 40,),
          ),Divider(),
            ListTile(
            leading: Image.asset("assets/icons/ic_location.png",width: 40,height: 40,),
            title: Text("Distance walked"),
            trailing: Image.asset("assets/icons/ic_choose_on.png",width: 40,height: 40,),
          ),
          
        ],
      ),
    );
  }
}
