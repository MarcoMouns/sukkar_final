import 'dart:io';

import 'package:flutter/material.dart';
import 'package:health/helpers/color_transform.dart';
import 'package:health/pages/account/new.dart';
import 'package:health/pages/measurement/weightAndHeight.dart';
import 'package:health/pages/others/chooseHomeWidgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:health/pages/Settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../languages/all_translations.dart';
import 'dart:convert';

import '../../shared-data.dart';
import 'edit_profile.dart';

class EditProfile extends StatefulWidget {
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: allTranslations.currentLanguage == "ar"
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Material(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(color: Settings.mainColor()),
                child: Column(
                  children: <Widget>[
                    new Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SharedData.customerData == null
                            ? Container(width: 30)
                            : Container(width: 30),
//                        new InkWell(
//                                onTap: () {
////                            Navigator.of(context).pop();
////                            Navigator.push(
////                                context,
////                                MaterialPageRoute(
////                                    builder: (context) => NewUser()));
//                                },
//                                child: Text(
//                                  allTranslations.text("edit"),
//                                  style: TextStyle(color: Colors.white),
//                                ),
//                              ),
                        SharedData.customerData == null
                            ? new Expanded(
                                child: Center(
                                  child: Column(
                                    children: <Widget>[
                                      CircleAvatar(
                                          radius: 45.0,
                                          backgroundImage: NetworkImage(
                                              'https://www.allsolutionslocksmiths.com.au/wp-content/uploads/2011/07/user.png')),
                                      Divider(color: Colors.white,),
                                      Text(
                                        allTranslations.text("not logged"),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : new Expanded(
                                child: Center(
                                  child: Column(
                                    children: <Widget>[
                                      CircleAvatar(
                                          radius: 45.0,
                                          backgroundColor: Settings.mainColor(),
                                          backgroundImage:
                                          SharedData
                                              .customerData[
                                          'image'] ==
                                              'Null' ||
                                              SharedData.customerData[
                                              'image'] ==
                                                  null
                                              ?
                                          NetworkImage( 'https://i.pinimg.com/originals/7c/c7/a6/7cc7a630624d20f7797cb4c8e93c09c1.png'
                                          ):
                                        NetworkImage('http://104.248.168.117${SharedData.customerData['image']}')
                                        ,
                                      ),
                                      Text(
                                        SharedData.customerData['userName'],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0),
                                      ),
                                      Text(
                                        "id:${SharedData.customerData['search_code']}",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(Icons.close, color: Colors.white),
                        )
                      ],
                    )
                  ],
                ),
              ),
              new Expanded(
                child: Container(
                  padding: const EdgeInsets.all(0.0),
                  child: ListView(
                    children: <Widget>[
//                      new Center(
//                        child: InkWell(
//                          onTap: () {
//                            Navigator.of(context).pushNamed('/offers');
//                          },
//                          child: Column(
//                            children: <Widget>[
//                              Image.asset(
//                                "assets/icons/ic_giftbox.png",
//                                width: 50,
//                                height: 50,
//                              ),
//                              Text(
//                                allTranslations.text("adsAndOffers"),
//                                style: TextStyle(color: Settings.mainColor()),
//                              ),
//                            ],
//                          ),
//                        ),
//                      ),
//                      ListTile(
//                        title: Text(
//                          allTranslations.text("choose main Circles"),
//                          style: TextStyle(color: Colors.grey),
//                        ),
//                        trailing: Icon(
//                          Icons.arrow_forward_ios,
//                          color: Colors.redAccent,
//                        ),
//                        onTap: () {
//                          Navigator.of(context)
//                              .push(MaterialPageRoute(builder: (context) {
//                            return ChooseMainWidgets();
//                          }));
//                        },
//                      ),
//                      Divider(
//                        height: 0,
//                      ),
//                      new ListTile(
//                        onTap: () {
//                          Navigator.push(
//                              context,
//                              MaterialPageRoute(
//                                  builder: (context) => NewUser()));
//                        },
//                        title: Text(
//                          allTranslations.text("editProfile"),
//                          style: TextStyle(color: Colors.grey),
//                        ),
//                        trailing: Icon(
//                          Icons.arrow_forward_ios,
//                          color: Colors.redAccent,
//                        ),
//                      ),
//                      Divider(
//                        height: 0,
//                      ),
                      ListTile(
                        title: Text(
                          allTranslations.text("editProfile"),
                          style: TextStyle(color: Colors.grey),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.redAccent,
                        ),
                        onTap: (){
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return EditProfileUser();
                          }));
                        },
                      ),
                      Divider(
                        height: 0,
                      ),
                      ListTile(
                        title: Text(
                          allTranslations.text("notifications"),
                          style: TextStyle(color: Colors.grey),
                        ),
                        trailing: Switch(
                          activeColor: Colors.green,
                          value: true,
                          onChanged: (val) {},
                        ),
                      ),
                      Divider(
                        height: 0,
                      ),
                      ListTile(
                        title: Text(
                          allTranslations.text("Weight and height"),
                          style: TextStyle(color: Colors.grey),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.redAccent,
                        ),
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return WeightAndHeight();
                          }));
                        },
                      ),
                      Divider(
                        height: 0,
                      ),
                      ListTile(
                        title: Row(
                          children: <Widget>[
                            Expanded(
                                child: Text(
                              allTranslations.text("language"),
                              style: TextStyle(color: Colors.grey),
                            )),
                            Text(
                              allTranslations.currentLanguage == "en"
                                  ? "English"
                                  : "عربي",
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                        onTap: () {   
                          showCupertinoModalPopup(
  context: context,
  builder: (BuildContext context) => CupertinoActionSheet(
      title:  Text( allTranslations.text("language")),
      message:Text(  allTranslations.text("chooseLanguage"),),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text( allTranslations.text("chooseLanguageOption1")),
          onPressed: () {
            allTranslations.setNewLanguage("en", true);
            setState(() {});
            Navigator.pop(context);
            
          },
        ),
        CupertinoActionSheetAction(
          child: Text( allTranslations.text("chooseLanguageOption2")),
          onPressed: () {
            allTranslations.setNewLanguage("ar", true);
            setState(() {});
            Navigator.pop(context);
          },
        )
      ],
      ),
); 
                           
                          // if (allTranslations.currentLanguage == "en") {
                          //   allTranslations.setNewLanguage("ar", true);
                          // } else {
                          //   allTranslations.setNewLanguage("en", true);
                          // }

                          setState(() {});
                        },
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.redAccent,
                        ),
                      ),
                      Divider(
                        height: 0,
                      ),
                      ListTile(
                        title: Text(
                          allTranslations.text("signout"),
                          style: TextStyle(color: Colors.grey),
                        ),
                        onTap: () async {
                          Navigator.of(context)
                              .pushNamedAndRemoveUntil('/landPage',
                                  (Route<dynamic> route) => false);
                          SharedPreferences sharedPreferences =
                              await SharedPreferences.getInstance();
                          sharedPreferences.remove('authUser');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
