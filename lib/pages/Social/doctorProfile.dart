import 'package:flutter/material.dart';
import 'package:health/Settings.dart';
import 'package:health/languages/all_translations.dart';
import 'package:health/pages/Social/chat.dart';

class DoctorProfile extends StatefulWidget {
  @override
  _DoctorProfileState createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: allTranslations.currentLanguage == "ar"
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Scaffold(
            body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
               
               UpperBarProfile(title: "Dr Same",subTitle:allTranslations.text( "heart"),image: Image.asset("assets/imgs/profile.jpg"),),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset("assets/icons/star_on.png",width: 20,),
                        SizedBox(
                          width: 2,
                        ),
                        Image.asset("assets/icons/star_on.png",width: 20,),
                        SizedBox(
                          width: 2,
                        ),
                        Image.asset("assets/icons/star_on.png",width: 20,),
                        SizedBox(
                          width: 2,
                        ),
                        Image.asset("assets/icons/star_off.png",width: 20,),
                        SizedBox(
                          width: 2,
                        ),
                        Image.asset("assets/icons/star_off.png",width: 20,)
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "title",
                                  style: TextStyle(
                                      color: Color.fromRGBO(57, 178, 221, 1),
                                      fontSize: 20,fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "his data",
                                  style: TextStyle(
                                      color: Color.fromRGBO(127, 132, 149, 1)),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ))
              ],
            ),
            Positioned(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  return Chat(isDoctor: true,);
                }));},
                child: Image.asset("assets/icons/ic_message.png",height: 60,width: 60,),
              ),
              top: 230,
      right: allTranslations.currentLanguage == "ar"?30:null,
       left: allTranslations.currentLanguage == "ar"?null:30,
            )
          ],
        )));
  }
}
