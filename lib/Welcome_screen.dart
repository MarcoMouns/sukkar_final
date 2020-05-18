import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health/Models/home_model.dart';
import 'package:health/pages/home/MainCircle/Circles.dart';
import 'package:health/scoped_models/main.dart';
import 'languages/all_translations.dart';
import 'pages/Settings.dart';
import 'pages/landPage.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  var date =
      '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';

  double stGHieght = 0;
  double stRHieght = 0;
  double stYHieght = 0;

  double suGHieght = 0;
  double suRHieght = 0;
  double suYHieght = 0;

  double moGHieght = 0;
  double moRHieght = 0;
  double moYHieght = 0;

  double tuGHieght = 0;
  double tuRHieght = 0;
  double tuYHieght = 0;

  double weGHieght = 0;
  double weRHieght = 0;
  double weYHieght = 0;

  double thGHieght = 0;
  double thRHieght = 0;
  double thYHieght = 0;

  double frGHieght = 0;
  double frRHieght = 0;
  double frYHieght = 0;

  static Random rnd = new Random();
  static int gmin = 50;
  static int gmax = 100;
  static int rmin = 100;
  static int rmax = 120;
  static int ymin = 40;
  static int ymax = 80;
  bool istrue = false;

  @override
  void initState() {
    super.initState();
    changeHieghtAnimation();
  }

  MainModel model;
  MeasurementsBean dataHome;
  List<BannersListBean> banners = List<BannersListBean>();

  void changeHieghtAnimation() {
    istrue = true;
    int r1 = gmin + rnd.nextInt(gmax - gmin);
    int r2 = gmin + rnd.nextInt(gmax - gmin);
    int r3 = gmin + rnd.nextInt(gmax - gmin);
    int r4 = rmin + rnd.nextInt(rmax - rmin);
    int r5 = rmin + rnd.nextInt(rmax - rmin);
    int r6 = rmin + rnd.nextInt(rmax - rmin);
    int r7 = ymin + rnd.nextInt(ymax - ymin);
    int r8 = ymin + rnd.nextInt(ymax - ymin);
    int r9 = ymin + rnd.nextInt(ymax - ymin);

    stGHieght = 0;
    stRHieght = 0;
    stYHieght = 0;

    suGHieght = 0;
    suRHieght = 0;
    suYHieght = 0;

    moGHieght = 0;
    moRHieght = 0;
    moYHieght = 0;

    tuGHieght = 0;
    tuRHieght = 0;
    tuYHieght = 0;

    weGHieght = 0;
    weRHieght = 0;
    weYHieght = 0;

    thGHieght = 0;
    thRHieght = 0;
    thYHieght = 0;

    frGHieght = 0;
    frRHieght = 0;
    frYHieght = 0;

    setState(() {});

    Future.delayed(Duration(milliseconds: istrue ? 300 : 1000), () {
      istrue = false;
      stGHieght = r1.toDouble();
      stRHieght = r4.toDouble();
      stYHieght = r7.toDouble();

      suGHieght = r2.toDouble();
      suRHieght = r5.toDouble();
      suYHieght = r8.toDouble();

      moGHieght = r3.toDouble();
      moRHieght = r6.toDouble();
      moYHieght = r9.toDouble();

      tuGHieght = r2.toDouble();
      tuRHieght = r6.toDouble();
      tuYHieght = r9.toDouble();

      weGHieght = r2.toDouble();
      weRHieght = r4.toDouble();
      weYHieght = r7.toDouble();

      thGHieght = r3.toDouble();
      thRHieght = r5.toDouble();
      thYHieght = r9.toDouble();

      frGHieght = r1.toDouble();
      frRHieght = r6.toDouble();
      frYHieght = r8.toDouble();

      setState(() {
      });
    });
  }


  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LandPage()));
    });
  }

  Widget upperCircles(
    context,
    _chartRadius,
  ) {
    return InkWell(
      onTap: () =>
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => LandPage())),
      child: CustomMultiChildLayout(
        delegate: CirclesDelegate(_chartRadius),
        children: <Widget>[
          new LayoutId(
            id: 1,
            child: MainCircles.diabetes(
              percent: 0.2,
              context: context,
              sugar: '0',
              raduis: _chartRadius,
              status: '0',
              ontap: () =>
                  Navigator.of(context)
                      .push(
                      MaterialPageRoute(builder: (context) => LandPage())),
              footer: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(
                    width: _chartRadius / 5,
                  ),
                  Expanded(
                      child: InkWell(
                        child: ImageIcon(
                          AssetImage("assets/icons/ic_camera.png"),
                          color: Colors.grey[300],
                          size: 15,
                        ),
                        onTap: null
                      )),
                  Expanded(
                    child: InkWell(
                      onTap: () => null,
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        overflow: Overflow.visible,
                        children: <Widget>[
                          Positioned(
                            child: CircleAvatar(
                              radius: 7.5,
                              backgroundImage:
                              AssetImage("assets/imgs/profile.jpg"),
                            ),
                          ),
                          Positioned(
                            left: 8.5,
                            child: CircleAvatar(
                              radius: 7.5,
                              backgroundImage:
                              AssetImage("assets/imgs/profile.jpg"),
                            ),
                          ),
                          Positioned(
                            left: 17,
                            child: Icon(
                              Icons.add,
                              size: 15,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: _chartRadius / 5,
                  ),
                ],
              ),
            ),
          ),
          new LayoutId(
              id: 2,
              child: MainCircles.cal(
                  percent: 0.5,
                  context: context,
                  day_Calories: '100',
                  ontap: () =>
                      Navigator.of(context)
                          .push(
                          MaterialPageRoute(builder: (context) => LandPage())),
                  raduis: _chartRadius,
                  footerText:
                  "Cal " + " 100 :" + allTranslations.text("Goal is"))),
          new LayoutId(
            id: 3,
            child: MainCircles.steps(
                percent: 0.9,
                context: context,
                steps: 100,
                raduis: _chartRadius,
                onTap: () =>
                    Navigator.of(context)
                        .push(
                        MaterialPageRoute(builder: (context) => LandPage())),
                footerText: " Step " + "100 :" +
                    allTranslations.text("Goal is")),
          ),
          new LayoutId(
            id: 4,
            child: MainCircles.distance(
                percent: 0.3,
                context: context,
                raduis: _chartRadius,
                distance: '0',
                onTap: () =>
                    Navigator.of(context)
                        .push(
                        MaterialPageRoute(builder: (context) => LandPage())),
                footerText:
                " meter " + "200 :" + allTranslations.text("Goal is")),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double _screenHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        40 -
        56;

    double _chartRadius =
        (_screenHeight * 3 / 5 - MediaQuery.of(context).padding.top - 40 - 56 <
                    MediaQuery.of(context).size.width - 30
                ? _screenHeight * 3 / 5
                : MediaQuery.of(context).size.width - 30) /
            2;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                    child: Padding(
                      child: Icon(
                        Icons.account_circle,
                        color: Colors.grey,
                        size: 40,
                      ),
                      padding: EdgeInsets.only(left: 10),
                    ),
                    onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LandPage()))),
                InkWell(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: ImageIcon(
                              AssetImage("assets/icons/ic_calendar.png"),
                              color: Colors.grey,
                            ),
                          ),
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => LandPage())),
                        ),
                        Text(
                          '$date',
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                      ],
                    ),
                    onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LandPage()))),
                InkWell(
                    child: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(
                        Icons.notifications_active,
                        color: Colors.grey,
                      ),
                    ),
                    onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LandPage()))),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            Container(
              height: MediaQuery.of(context).size.height * 0.455,
              child: Row(
                children: <Widget>[
                  RotatedBox(
                    quarterTurns: 2,
                    child: InkWell(
                      child: Image.asset(
                        "assets/icons/ic_arrow_r.png",
                        matchTextDirection: true,
                        width: 15,
                        height: MediaQuery.of(context).size.height * 3 / 5,
                      ),
                      onTap: () => null,
                    ),
                  ),

                  Expanded(
                      child: InkWell(
                        onTap: () =>
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) =>
                                    LandPage())),
                        child: upperCircles(
                          context,
                          _chartRadius,
                        ),
                      )
                  ),
                  InkWell(
                    onTap: () => null,
                    child: Image.asset(
                      "assets/icons/ic_arrow_r.png",
                      width: 15,
                      height: MediaQuery.of(context).size.height * 3 / 5,
                      matchTextDirection: true,
                    ),
                  ),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            Directionality(
              textDirection: TextDirection.rtl,
              child: SizedBox(
                height: 60,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    InkWell(
                      onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => LandPage())),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        height: MediaQuery.of(context).size.height * 0.15,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Colors.grey[200]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              child: Image.asset('assets/icons/heart.png'),
                              padding: EdgeInsets.only(right: 20),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Title 1",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  Text(
                                    "August 2019 5",
                                    style: TextStyle(color: Colors.grey,fontSize: 12),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => LandPage())),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        height: MediaQuery.of(context).size.height * 0.15,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Colors.grey[200]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              child: Image.asset('assets/icons/heart.png'),
                              padding: EdgeInsets.only(right: 20),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Title 1",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  Text(
                                    "August 2019 5",
                                    style: TextStyle(color: Colors.grey,fontSize: 12),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => LandPage())),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        height: MediaQuery.of(context).size.height * 0.15,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Colors.grey[200]),
                        child: Image.network('${Settings.baseApilink}/articles/3'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.grey.shade50,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        InkWell(
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).padding.bottom + 60),
                            child: Image.asset(
                              'assets/icons/ic_arrow_small_l.png',
                              scale: 2,
                            ),
                          ),
                          onTap: () => changeHieghtAnimation(),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.height * 0.24,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            "${(frRHieght).toInt()}",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 10),
                                          ),
                                          AnimatedContainer(
                                            duration: Duration(
                                                milliseconds: istrue ? 0 : 300),
                                            height: frRHieght,
                                            width: 10,
                                            decoration: BoxDecoration(
                                                color: Color(0xFFd17356),
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(5),
                                                  topRight: Radius.circular(5),
                                                )),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            '${(frGHieght).toInt()}',
                                            style: TextStyle(
                                              color: Colors.green[300],
                                              fontSize: 10,
                                            ),
                                          ),
                                          AnimatedContainer(
                                            duration: Duration(
                                                seconds: istrue ? 0 : 1),
                                            height: frGHieght,
                                            width: 10,
                                            decoration: BoxDecoration(
                                                color: Colors.green[300],
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(5),
                                                  topRight: Radius.circular(5),
                                                )),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            '${(frYHieght).toInt()}',
                                            style: TextStyle(
                                                color: Colors.yellow[800],
                                                fontSize: 10),
                                          ),
                                          AnimatedContainer(
                                            duration: Duration(
                                                milliseconds: istrue ? 0 : 300),
                                            height: frYHieght,
                                            width: 10,
                                            decoration: BoxDecoration(
                                                color: Color(0xFFed982f),
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(5),
                                                  topRight: Radius.circular(5),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 1.2,
                                    height: MediaQuery.of(context).size.height *
                                        0.17,
                                    color: Colors.grey,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            "${(thRHieght).toInt()}",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 10),
                                          ),
                                          AnimatedContainer(
                                            duration: Duration(
                                                milliseconds: istrue ? 0 : 300),
                                            height: thRHieght,
                                            width: 10,
                                            decoration: BoxDecoration(
                                                color: Color(0xFFd17356),
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(5),
                                                  topRight: Radius.circular(5),
                                                )),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            '${(thGHieght).toInt()}',
                                            style: TextStyle(
                                                color: Colors.green[300],
                                                fontSize: 10),
                                          ),
                                          AnimatedContainer(
                                            duration: Duration(
                                                milliseconds: istrue ? 0 : 300),
                                            height: thGHieght,
                                            width: 10,
                                            decoration: BoxDecoration(
                                                color: Colors.green[300],
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(5),
                                                  topRight: Radius.circular(5),
                                                )),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            '${(thYHieght).toInt()}',
                                            style: TextStyle(
                                                color: Colors.yellow[800],
                                                fontSize: 10),
                                          ),
                                          AnimatedContainer(
                                            duration: Duration(
                                                milliseconds: istrue ? 0 : 300),
                                            height: thYHieght,
                                            width: 10,
                                            decoration: BoxDecoration(
                                                color: Color(0xFFed982f),
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(5),
                                                  topRight: Radius.circular(5),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 1.2,
                                    height: MediaQuery.of(context).size.height *
                                        0.17,
                                    color: Colors.grey,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            "${(weRHieght).toInt()}",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 10),
                                          ),
                                          AnimatedContainer(
                                            duration: Duration(
                                                milliseconds: istrue ? 0 : 300),
                                            height: weRHieght,
                                            width: 10,
                                            decoration: BoxDecoration(
                                                color: Color(0xFFd17356),
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(5),
                                                  topRight: Radius.circular(5),
                                                )),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            '${(weGHieght).toInt()}',
                                            style: TextStyle(
                                              color: Colors.green[300],
                                              fontSize: 10,
                                            ),
                                          ),
                                          AnimatedContainer(
                                            duration: Duration(
                                                milliseconds: istrue ? 0 : 300),
                                            height: weGHieght,
                                            width: 10,
                                            decoration: BoxDecoration(
                                                color: Colors.green[300],
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(5),
                                                  topRight: Radius.circular(5),
                                                )),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            '${(weYHieght).toInt()}',
                                            style: TextStyle(
                                                color: Colors.yellow[800],
                                                fontSize: 10),
                                          ),
                                          AnimatedContainer(
                                            duration: Duration(
                                                milliseconds: istrue ? 0 : 300),
                                            height: weYHieght,
                                            width: 10,
                                            decoration: BoxDecoration(
                                                color: Color(0xFFed982f),
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(5),
                                                  topRight: Radius.circular(5),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 1.2,
                                    height: MediaQuery.of(context).size.height *
                                        0.17,
                                    color: Colors.grey,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            "${(tuRHieght).toInt()}",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 10),
                                          ),
                                          AnimatedContainer(
                                            duration: Duration(
                                                milliseconds: istrue ? 0 : 300),
                                            height: tuRHieght,
                                            width: 10,
                                            decoration: BoxDecoration(
                                                color: Color(0xFFd17356),
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(5),
                                                  topRight: Radius.circular(5),
                                                )),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            '${(tuGHieght).toInt()}',
                                            style: TextStyle(
                                                color: Colors.green[300],
                                                fontSize: 10),
                                          ),
                                          AnimatedContainer(
                                            duration: Duration(
                                                milliseconds: istrue ? 0 : 300),
                                            height: tuGHieght,
                                            width: 10,
                                            decoration: BoxDecoration(
                                                color: Colors.green[300],
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(5),
                                                  topRight: Radius.circular(5),
                                                )),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            '${(tuYHieght).toInt()}',
                                            style: TextStyle(
                                                color: Colors.yellow[800],
                                                fontSize: 10),
                                          ),
                                          AnimatedContainer(
                                            duration: Duration(
                                                milliseconds: istrue ? 0 : 300),
                                            height: tuYHieght,
                                            width: 10,
                                            decoration: BoxDecoration(
                                                color: Color(0xFFed982f),
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(5),
                                                  topRight: Radius.circular(5),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 1.2,
                                    height: MediaQuery.of(context).size.height *
                                        0.17,
                                    color: Colors.grey,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            "${(moRHieght).toInt()}",
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 10,
                                            ),
                                          ),
                                          AnimatedContainer(
                                            duration: Duration(
                                                milliseconds: istrue ? 0 : 300),
                                            height: moRHieght,
                                            width: 10,
                                            decoration: BoxDecoration(
                                                color: Color(0xFFd17356),
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(5),
                                                  topRight: Radius.circular(5),
                                                )),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            '${(moGHieght).toInt()}',
                                            style: TextStyle(
                                              color: Colors.green[300],
                                              fontSize: 10,
                                            ),
                                          ),
                                          AnimatedContainer(
                                            duration: Duration(
                                                milliseconds: istrue ? 0 : 300),
                                            height: moGHieght,
                                            width: 10,
                                            decoration: BoxDecoration(
                                                color: Colors.green[300],
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(5),
                                                  topRight: Radius.circular(5),
                                                )),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            '${(moYHieght).toInt()}',
                                            style: TextStyle(
                                                color: Colors.yellow[800],
                                                fontSize: 10),
                                          ),
                                          AnimatedContainer(
                                            duration: Duration(
                                                milliseconds: istrue ? 0 : 300),
                                            height: moYHieght,
                                            width: 10,
                                            decoration: BoxDecoration(
                                                color: Color(0xFFed982f),
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(5),
                                                  topRight: Radius.circular(5),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 1.2,
                                    height: MediaQuery.of(context).size.height *
                                        0.17,
                                    color: Colors.grey,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            "${(suRHieght).toInt()}",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 10),
                                          ),
                                          AnimatedContainer(
                                            duration: Duration(
                                                milliseconds: istrue ? 0 : 300),
                                            height: suRHieght,
                                            width: 10,
                                            decoration: BoxDecoration(
                                                color: Color(0xFFd17356),
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(5),
                                                  topRight: Radius.circular(5),
                                                )),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            '${(suGHieght).toInt()}',
                                            style: TextStyle(
                                              color: Colors.green[300],
                                              fontSize: 10,
                                            ),
                                          ),
                                          AnimatedContainer(
                                            duration: Duration(
                                                seconds: istrue ? 0 : 1),
                                            height: suGHieght,
                                            width: 10,
                                            decoration: BoxDecoration(
                                                color: Colors.green[300],
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(5),
                                                  topRight: Radius.circular(5),
                                                )),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            '${(suYHieght).toInt()}',
                                            style: TextStyle(
                                                color: Colors.yellow[800],
                                                fontSize: 10),
                                          ),
                                          AnimatedContainer(
                                            duration: Duration(
                                                milliseconds: istrue ? 0 : 300),
                                            height: suYHieght,
                                            width: 10,
                                            decoration: BoxDecoration(
                                                color: Color(0xFFed982f),
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(5),
                                                  topRight: Radius.circular(5),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 1.2,
                                    height: MediaQuery.of(context).size.height *
                                        0.17,
                                    color: Colors.grey,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            "${(stRHieght).toInt()}",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 10),
                                          ),
                                          AnimatedContainer(
                                            duration: Duration(
                                                milliseconds: istrue ? 0 : 300),
                                            height: stRHieght,
                                            width: 10,
                                            decoration: BoxDecoration(
                                                color: Color(0xFFd17356),
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(5),
                                                  topRight: Radius.circular(5),
                                                )),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            '${(stGHieght).toInt()}',
                                            style: TextStyle(
                                              color: Colors.green[300],
                                              fontSize: 10,
                                            ),
                                          ),
                                          AnimatedContainer(
                                            duration: Duration(
                                                seconds: istrue ? 0 : 1),
                                            height: stGHieght,
                                            width: 10,
                                            decoration: BoxDecoration(
                                                color: Colors.green[300],
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(5),
                                                  topRight: Radius.circular(5),
                                                )),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            '${(stYHieght).toInt()}',
                                            style: TextStyle(
                                                color: Colors.yellow[800],
                                                fontSize: 10),
                                          ),
                                          AnimatedContainer(
                                            duration: Duration(
                                                milliseconds: istrue ? 0 : 300),
                                            height: stYHieght,
                                            width: 10,
                                            decoration: BoxDecoration(
                                                color: Color(0xFFed982f),
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(5),
                                                  topRight: Radius.circular(5),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  height: 1,
                                  color: Colors.grey[500]),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        "الجمعة",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                        textScaleFactor: 1.0,
                                      ),
                                      Text(
                                        '21/9',
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        "الخميس",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                        textScaleFactor: 1.0,
                                      ),
                                      Text('20/9',
                                          style: TextStyle(
                                              fontSize: 10, color: Colors.grey),
                                          textScaleFactor: 1.0),
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        "الاربعاء",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                        textScaleFactor: 1.0,
                                      ),
                                      Text(
                                        '19/9',
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        "الثلاثاء",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                        textScaleFactor: 1.0,
                                      ),
                                      Text(
                                        '18/9',
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        "الإثنين",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                        textScaleFactor: 1.0,
                                      ),
                                      Text(
                                        '17/9',
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        "الاحد",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                        textScaleFactor: 1.0,
                                      ),
                                      Text(
                                        '15/9',
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        "السبت",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                        textScaleFactor: 1.0,
                                      ),
                                      Text(
                                        '14/9',
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        InkWell(
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).padding.bottom + 60),
                            child: Image.asset(
                              'assets/icons/ic_arrow_small_r.png',
                              scale: 2,
                            ),
                          ),
                          onTap: () => changeHieghtAnimation(),
                        ),
                      ],
                    )),
                onTap: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => LandPage())))
          ],
        ),
        bottomNavigationBar: Directionality(
          textDirection: TextDirection.rtl,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/icons/ic_home${_selectedIndex == 0 ? '_active' : ''}.png",
                  scale: 4,
                ),
                title: Text(allTranslations.text("home")),
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/icons/ic_article${_selectedIndex == 1 ? '_active' : ''}.png",
                  scale: 4,
                ),
                title: Text(allTranslations.text("articles")),
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/icons/ic_friends${_selectedIndex == 2 ? '_active' : ''}.png",
                  scale: 4,
                ),
                title: Text(allTranslations.text("friends")),
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/icons/ic_doctor${_selectedIndex == 3 ? '' : ''}.png",
                  scale: 4,
                ),
                title: Text(allTranslations.text("doctors")),
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.blue,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}

class CirclesDelegate extends MultiChildLayoutDelegate {
  final double raduis;

  CirclesDelegate(this.raduis);

  @override
  void performLayout(Size size) {
    if (hasChild(1)) {
      layoutChild(
          1,
          BoxConstraints(
              maxWidth: size.width / 2, maxHeight: size.width / 2 + 30));
      positionChild(1, Offset(size.width / 4, 0));
    }
    if (hasChild(2)) {
      layoutChild(
          2, BoxConstraints(maxWidth: raduis, maxHeight: (raduis / 2 + 46)));
      positionChild(
          2,
          Offset(size.width - raduis / 2 - 20 / 560 * size.width,
              290 / 500 * size.height - raduis / 8));
    }
    if (hasChild(3)) {
      layoutChild(
          3, BoxConstraints(maxWidth: raduis, maxHeight: (raduis / 2 + 46)));
      positionChild(
          3,
          Offset(size.width / 2 - raduis / 4,
              size.height - (raduis / 2) - 20 - 20));
    }
    if (hasChild(4)) {
      layoutChild(
          4, BoxConstraints(maxWidth: raduis, maxHeight: (raduis / 2 + 46)));
      positionChild(4,
          Offset(20 / 560 * size.width, 290 / 500 * size.height - raduis / 8));
    }
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) {
    return false;
  }
}
