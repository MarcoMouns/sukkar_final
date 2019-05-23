import 'package:flutter/material.dart';
import 'package:health/MainCircle/Circles.dart';
import 'package:health/Settings.dart';
import 'package:health/languages/all_translations.dart';



class ProfileChart extends StatelessWidget {
  final bool isMyProfile;
  final String date;
  ProfileChart({this.isMyProfile = false, this.date});
  @override
  Widget build(BuildContext context) {
    double raduis = MediaQuery.of(context).size.width / 2 <
            MediaQuery.of(context).size.height - (120 + 23 + 14 + 10)
        ? MediaQuery.of(context).size.width / 2
        : MediaQuery.of(context).size.height - (120 + 23 + 14 + 10);
    return Directionality(
        textDirection: allTranslations.currentLanguage == "ar"
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Scaffold(
            backgroundColor: Color.fromRGBO(250, 251, 255, 1),
            body: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    UpperBarProfile(
                      height: 120,
                      title: "Sam",
                      subTitle: date == "" ? "" : "1/1 "+allTranslations.text("الأحد"),
                      image: Image.asset(
                        "assets/imgs/profile.jpg",
                        width: 100 / 2,
                        height: 100 / 2,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Align(alignment: Alignment.bottomCenter,
                                    child: MainCircles.cups(
                                        context: context, raduis: raduis),
                                  ),
                                  Align(alignment: Alignment.topCenter,
                                    child: MainCircles.bloodPreassure(
                                        context: context, raduis: raduis),
                                  ),
                                  Align(alignment: Alignment.bottomCenter,
                                    child: MainCircles.heartRate(
                                        context: context, raduis: raduis),
                                  )
                                ],
                              ),
                            ),
                            MainCircles.diabetes(
                                context: context, raduis: raduis,ontap: (){}),
                            Expanded(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Align(
                                  child: MainCircles.cal(
                                      context: context, raduis: raduis),alignment: Alignment.topCenter,
                                ),
                                Align(alignment: Alignment.bottomCenter,
                                  child: MainCircles.steps(
                                      context: context, raduis: raduis),
                                ),
                                Align(alignment: Alignment.topCenter,
                                  child: MainCircles.distance(
                                      context: context, raduis: raduis),
                                )
                              ],
                            ))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Positioned(
                    top: 135,
                    right: allTranslations.currentLanguage != "ar" ? 30 : null,
                    left: allTranslations.currentLanguage != "ar" ? null : 30,
                    child: InkWell(
                     highlightColor: Colors.transparent,
                     splashColor: Colors.transparent,
                      child: Image.asset(
                        "assets/icons/ic_remove_friend.png",
                        width: 60,
                      ),
                      onTap: () {},
                    ))
              ],
            )));
  }
}
