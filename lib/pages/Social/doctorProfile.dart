import 'package:flutter/material.dart';
import 'package:health/Models/article_tab/article_category.dart';
import 'package:health/pages/Settings.dart';
import 'package:health/languages/all_translations.dart';
import 'package:health/pages/Social/chat.dart';
import 'package:health/scoped_models/main.dart';

class DoctorProfile extends StatefulWidget {
  final doctorSpecialists;
  final doctorCv;
  int rate;
  MainModel model;
  final userId;

  DoctorProfile({this.doctorSpecialists, this.doctorCv, this.rate,this.model,this.userId});

  @override
  _DoctorProfileState createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('get userId => ${widget.doctorSpecialists}');
  }

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
                UpperBarProfile(
                  title: widget.doctorSpecialists.name.toString(),
                  subTitle:
                      widget.doctorSpecialists.specialist.titleAr.toString(),
                  image: widget.doctorSpecialists.image == 'Null'
                      ? Image.network(
                          "https://images.vexels.com/media/users/3/151709/isolated/preview/098c4aad185294e67a3f695b3e64a2ec-doctor-avatar-icon-by-vexels.png")
                      : Image.network(
                          'http://104.248.168.117/ ${widget.doctorSpecialists.image}',
                        ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(5, (index) {
                        return Icon(
                          index < widget.rate ? Icons.star : Icons.star_border,
                          color: Colors.blue,
                        );
                      }),
                    ),
                    Expanded(
                      child: ListView(
                        children: <Widget>[
                          new Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'عن الدكتور',
                                  style: TextStyle(
                                      color: Color.fromRGBO(57, 178, 221, 1),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  widget.doctorCv[0].brief.toString(),
                                  style: TextStyle(
                                      color: Color.fromRGBO(127, 132, 149, 1)),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'التخصص',
                                  style: TextStyle(
                                      color: Color.fromRGBO(57, 178, 221, 1),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  widget.doctorSpecialists.specialist.titleAr
                                      .toString(),
                                  style: TextStyle(
                                      color: Color.fromRGBO(127, 132, 149, 1)),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'الاماكن التي شغلها',
                                  style: TextStyle(
                                      color: Color.fromRGBO(57, 178, 221, 1),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  widget.doctorSpecialists.places[0].title
                                      .toString(),
                                  style: TextStyle(
                                      color: Color.fromRGBO(127, 132, 149, 1)),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ))
              ],
            ),
            Positioned(
              child: InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return Chat(
                      isDoctor: true,
                        userId:widget.userId,
                        model:widget.model,
                        name:widget.doctorSpecialists.name.toString(),
                        image:'${widget.doctorSpecialists.image}'
                    );
                  }));
                },
                child: Image.asset(
                  "assets/icons/ic_message.png",
                  height: 60,
                  width: 60,
                ),
              ),
              top: 230,
              right: allTranslations.currentLanguage == "ar" ? 30 : null,
              left: allTranslations.currentLanguage == "ar" ? null : 30,
            )
          ],
        )));
  }
}
