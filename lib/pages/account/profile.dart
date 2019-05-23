import 'package:flutter/material.dart';
import 'package:health/pages/account/new.dart';
import 'package:health/pages/measurement/weightAndHeight.dart';
import 'package:health/pages/others/chooseHomeWidgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/cupertino.dart';
import '../../Settings.dart';
import '../../languages/all_translations.dart';

class EditProfile extends StatefulWidget {
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                     
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            allTranslations.text("edit"),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 45.0,
                                  backgroundImage:
                                      AssetImage("assets/imgs/profile.jpg"),
                                ),
                                Text(
                                  "Yahia agwa",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20.0),
                                ),
                                Text(
                                  "id:19890625",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14.0),
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
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(0.0),
                  child: ListView(
                    children: <Widget>[
                      Center(
                        child: InkWell(
                 
                          onTap: () {
                            Navigator.of(context).pushNamed('/offers');
                          },
                          child: Column(
                            children: <Widget>[
                              Image.asset(
                                "assets/icons/ic_giftbox.png",
                                width: 50,
                                height: 50,
                              ),
                              Text(
                                allTranslations.text("adsAndOffers"),
                                style: TextStyle(color: Settings.mainColor()),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NewUser()));
                        },
                        title: Text(
                          allTranslations.text("editProfile"),
                          style: TextStyle(color: Colors.grey),
                        ),
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
                          allTranslations.text("editPassword"),
                          style: TextStyle(color: Colors.grey),
                        ),
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
                          if (allTranslations.currentLanguage == "en") {
                            allTranslations.setNewLanguage("ar", true);
                          } else {
                            allTranslations.setNewLanguage("en", true);
                          }

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
                      ),
                      Divider(
                        height: 0,
                      ),
                      ListTile(
                        title: Text(
                          allTranslations.text("choose main Circles"),
                          style: TextStyle(color: Colors.grey),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.redAccent,
                        ),
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return ChooseMainWidgets();
                          }));
                        },
                      ),
                      Divider(
                        height: 0,
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
