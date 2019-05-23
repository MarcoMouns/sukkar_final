import 'dart:async';

import 'package:flutter/material.dart';
import 'package:health/MainCircle/Circles.dart';
import 'package:health/Models/day.dart';
import 'package:health/pages/home/articleDetails.dart';
import 'package:intl/intl.dart' as intl;
// import 'package:health/pages/measurement/addsugar.dart';
import 'package:pedometer/pedometer.dart';
import 'package:health/pages/others/barCharts.dart';
import '../../Settings.dart';
import '../../languages/all_translations.dart';
import 'package:health/Settings.dart' as settings;

class HomePage extends StatefulWidget {
  final PageController pageController;
  HomePage({@required this.pageController});
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  PageController _bottomChartsPageViewController = PageController();
  //width of the screen to init the siwiper postion
  int _stepCountValue;
  StreamSubscription _subscription;
  //to know where it's first time or not user to idnitfy swiper postion
  bool _firstPageLoad = true;
  //scrollController to init the swiper postion
  ScrollController _scrollController;

  init(BuildContext context) {
    _scrollController = ScrollController(
        initialScrollOffset: MediaQuery.of(context).size.width - 130);
  }

  initState() {
    super.initState();
    setUpPedometer();
  }

  //--------------------- STEP COUNTER ---------------//
  void setUpPedometer() {
    Pedometer pedometer = new Pedometer();
    _subscription = pedometer.stepCountStream.listen(_onData,
        onError: _onError, onDone: _onDone, cancelOnError: true);
  }

  void _onData(int stepCountValue) async {
    setState(() => _stepCountValue = stepCountValue);
  }

  void _onDone() => print("Finished pedometer tracking");

  void _onError(error) => print("Flutter Pedometer Error: $error");

  void _onCancel() => _subscription.cancel();

  //------------------ END STEP COUNTER -------------//

  dispose() {
    _onCancel();
    super.dispose();
  }

  Widget upperCircles(context, _chartRadius) {
    return CustomMultiChildLayout(
      delegate: CirclesDelegate(_chartRadius),
      children: <Widget>[
        LayoutId(
            id: 1,
            child: MainCircles.diabetes(
                context: context,
                raduis: _chartRadius,
                ontap: () {
//                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//                    return AddSugar();
                  //   }));
                },
                footer: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SizedBox(
                      width: _chartRadius / 5,
                    ),
                    Expanded(
                      child: ImageIcon(
                        AssetImage("assets/icons/ic_camera.png"),
                        color: Colors.grey[300],
                        size: 15,
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          widget.pageController.animateToPage(3,
                              duration: Duration(
                                milliseconds: 10,
                              ),
                              curve: Curves.bounceIn);
                        },
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
                ))),
        LayoutId(
            id: 2,
            child: MainCircles.cal(
                context: context,
                ontap: () {
                  _showBottomSheet(
                      context: context,
                      title: "cals",
                      subTitle: "enterTodayCals",
                      imageName: "ic_cal",
                      min: 0.0,
                      max: 7000.0);
                },
                raduis: _chartRadius,
                footerText: allTranslations.text("Goal is") + " 100Cal")),
        LayoutId(
          id: 3,
          child: MainCircles.steps(
              context: context,
              steps: _stepCountValue ?? 0,
              raduis: _chartRadius,
              onTap: () {
                _showBottomSheet(
                    context: context,
                    title: "steps",
                    subTitle: "enterTodaySteps",
                    imageName: "ic_steps",
                    min: 0.0,
                    max: 7000.0);
              },
              footerText: allTranslations.text("Goal is") + " 100Step"),
        ),
        LayoutId(
          id: 4,
          child: MainCircles.distance(
              context: context,
              raduis: _chartRadius,
              onTap: () {
                _showBottomSheet(
                    context: context,
                    title: "distance",
                    subTitle: "enterTodayWalk",
                    imageName: "ic_location",
                    min: 0.0,
                    max: 7000.0);
              },
              footerText: allTranslations.text("Goal is") + " 100Km"),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_firstPageLoad) {
      init(context);
      _firstPageLoad = false;
    }
    // get free pixels free to render widgets on it
    // 40 appbar heigth
    //56 bottom navigation bar heigth
    //   MediaQuery.of(context).padding.top is the height of status bar
    double _screenHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        40 -
        56;
    //check if the width or height ratio is bigger so no overlaying occur
    double _chartRadius =
        (_screenHeight * 3 / 5 - MediaQuery.of(context).padding.top - 40 - 56 <
                    MediaQuery.of(context).size.width - 30
                ? _screenHeight * 3 / 5
                : MediaQuery.of(context).size.width - 30) /
            2;
    return Scaffold(
      appBar: Settings.appBar(
        context: context,
        title: InkWell(
          onTap: () async {
            var res = await showDatePicker(
                locale: allTranslations.locale,
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2018),
                lastDate: DateTime(2020));
          },
          child: Row(
            children: <Widget>[
              Text(
                intl.DateFormat("dd MMM", allTranslations.locale.languageCode)
                    .format(DateTime.now()),
                style: TextStyle(color: Colors.grey),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: ImageIcon(
                  AssetImage("assets/icons/ic_calendar.png"),
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                height: _screenHeight * 3 / 5,
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
                        onTap: () {
                          widget.pageController.animateToPage(0,
                              duration: Duration(milliseconds: 10),
                              curve: Curves.bounceIn);
                        },
                      ),
                    ),
                    Expanded(
                      child: upperCircles(context, _chartRadius),
                    ),
                    InkWell(
                      onTap: () {
                        widget.pageController.animateToPage(2,
                            curve: Curves.bounceIn,
                            duration: Duration(milliseconds: 10));
                      },
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
              Expanded(
                flex: 2,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 9,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 11,
                        controller: _scrollController,
                        itemBuilder: (context, index) {
                          if (index == 10) {
                            return AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                decoration: ShapeDecoration(
                                    color: Colors.grey[200],
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.add,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                            );
                          }
                          return InkWell(
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ArticleDetails()));
                            },
                            child: Container(
                              decoration: ShapeDecoration(
                                  color: Colors.grey[200],
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              width: MediaQuery.of(context).size.width - 100,
                              child: Row(
                                children: <Widget>[
                                  ClipRRect(
                                    child: Image.asset(
                                      "assets/imgs/landpage_bk.jpg",
                                      fit: BoxFit.contain,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Text(
                                            "Title",
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    41, 172, 216, 1),
                                                fontSize: 20),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Text(
                                            intl.DateFormat(
                                                    "dd MMM yyyy",
                                                    allTranslations
                                                        .locale.languageCode)
                                                .format(DateTime.now()),
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                        child: Row(
                      children: <Widget>[
                        InkWell(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ImageIcon(
                                AssetImage("assets/icons/ic_arrow_small_r.png"),
                                size: MediaQuery.of(context).size.width *
                                    25 /
                                    720,
                                color: Colors.grey[400],
                              )
                            ],
                          ),
                          onTap: () {
                            _bottomChartsPageViewController.previousPage(
                                duration: Duration(milliseconds: 20),
                                curve: Curves.bounceIn);
                          },
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 5 / 720,
                        ),
                        Expanded(
                          child: PageView.builder(
                              itemCount: 10,
                              controller: _bottomChartsPageViewController,
                              itemBuilder: (context, index) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    BarCharts(
                                      height: (_screenHeight -
                                          MediaQuery.of(context).size.height /
                                              9 -
                                          _screenHeight * 3 / 5 -
                                          MediaQuery.of(context).size.width *
                                              15 /
                                              720 *
                                              2 -
                                          6 -
                                          MediaQuery.of(context).size.width *
                                              20 /
                                              720 -
                                          16 -
                                          2),
                                    ),
                                    Container(
                                      color: Colors.grey,
                                      height: 1,
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.width *
                                                  15 /
                                                  720 *
                                                  2 +
                                              6,
                                      child: _daysWidget(context),
                                    ),
                                  ],
                                );
                              }),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 5 / 720,
                        ),
                        InkWell(
                          onTap: () {
                            _bottomChartsPageViewController.nextPage(
                                duration: Duration(milliseconds: 20),
                                curve: Curves.bounceIn);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              RotatedBox(
                                quarterTurns: 2,
                                child: ImageIcon(
                                  AssetImage(
                                      "assets/icons/ic_arrow_small_r.png"),
                                  color: Colors.grey[400],
                                  size: MediaQuery.of(context).size.width *
                                      25 /
                                      720,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Day> days = List()
    ..add(Day(day: allTranslations.text("السبت"), date: "12/30"))
    ..add(Day(day: allTranslations.text("الأحد"), date: "1/1"))
    ..add(Day(day: allTranslations.text("الإثنين"), date: "1/2"))
    ..add(Day(day: allTranslations.text("الثلاثاء"), date: "1/3"))
    ..add(Day(day: allTranslations.text("الأربعاء"), date: "1/4"))
    ..add(Day(day: allTranslations.text("الخميس"), date: "1/5"))
    ..add(Day(day: allTranslations.text("الجمعة"), date: "1/6"));
  Widget _daysWidget(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: days.map((day) {
          return Expanded(
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width / 100,
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(
                        day.day,
                        style: TextStyle(
                            color: Colors.grey[400],
                            fontSize:
                                MediaQuery.of(context).size.width * 14 / 720),
                      ),
                      Text(
                        day.date,
                        style: TextStyle(
                            color: Colors.grey[400],
                            fontSize:
                                MediaQuery.of(context).size.width * 12 / 720),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 100,
                ),
              ],
            ),
          );
        }).toList());
  }

  _showBottomSheet(
      {BuildContext context,
      String title,
      String subTitle,
      String imageName,
      double min,
      double max}) async {
    await showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return settings.BottomSheet(
              title: title,
              subtitle: subTitle,
              image: imageName,
              min: min,
              max: max,
              addSlider: true,
              onSave: (String value) {});
        });
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
