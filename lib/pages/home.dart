// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:health/pages/Social/friends.dart';
import 'package:health/pages/Settings.dart' as settings;
import 'package:health/pages/home/articlesCategory.dart';
import 'package:health/pages/measurement/BloodPreasure.dart';
import 'package:health/pages/measurement/addFood.dart';
import 'package:health/pages/measurement/addSleep.dart';
import 'package:health/pages/measurement/heartBeats.dart';
import 'package:health/pages/measurement/itemList.dart';
import 'package:health/pages/others/map.dart';
import 'dart:math' as math;
import '../doctor_chat_screen.dart';
import './home/home.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped_models/main.dart';

import 'package:health/pages/Settings.dart';
import '../languages/all_translations.dart';

/*
 * Modifications
 */
class MainHome extends StatefulWidget {

  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Color _plusColor = Settings.mainColor();

//your stuff

  /*
   *
   * Modifications
   */

  AnimationController animationController;
  AnimationController animationController2;

  void _handleSubmitted(BuildContext context, MainModel model, var value,String type) {
    model.addMeasurements(type, value).then((result) async {
      print(result);
    });
  }
  _onMenuTap(item, MainModel model) {
    if (item == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ItemList(
                  model: model,
                  isfood: false,
                )),
      );
    }
    if (item == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context ) => BloodPressure(model)),
      );
    }
    if (item == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HeartBeats(model)),
      );
    }
    if (item == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddFood(model)),
      );
    }
    if (item == 5) {
      // Navigator.of(context).pop();

      showDialog(
          barrierDismissible: true,
          context: context,
          builder: (BuildContext context) {
            return settings.BottomSheet(
                title: "cups",
                type:'water_cups',
                subtitle: "enterWaterCups",
                image: "ic_cup",
                min: 0.0,
                max: 15.0,
                addSlider: true,
                onSave: (String value) {
                  setState(() {
                    _handleSubmitted(context, model, value,"water_cups");
                  });
                });
          });
    }
    if (item == 6) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddSleep()),
      );
    }
  }

  static PageController _pageController;

  PageController _getPageController() {
    if (_pageController == null) {
      _pageController = PageController(
        initialPage: 1,
        keepPage: true,
      );
      _pageController.addListener(() {
        if (_pageController.page <= 1 && _pageController.page >= 0.6) {
          CustomBottomNavigationBarState.c.reload();
        }
      });
    }

    return _pageController;
  }

  AnimationController _controller;
  Animation _animation;
  AnimationController _rotateCopntroller;
  Animation<double> _rotateAmimation;
  @override
  void initState() {
    super.initState();
    _pageController= _getPageController();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 175),
    );
    _animation = Tween(begin: 180 * 0.05, end: 180 * 0.4).animate(_controller);
    _rotateCopntroller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 175),
    );
    _rotateAmimation =
        Tween(begin: 0.0, end: math.pi / 4).animate(_rotateCopntroller);
    _rotateAmimation.addListener(() {
      _rotateAmimation.value;
    });
    
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: allTranslations.currentLanguage == "ar"
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          return new Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            body: PageView(
              controller: _getPageController(),
              onPageChanged: (i) {
                Settings.currentIndex = i - 1;
                setState(() {});
              },
              children: <Widget>[
                MapPage(
                  pageController: _getPageController(),
                ),
                HomePage(
                  pageController: _getPageController(),
                  model: model,
                ),
                ArticleCategory(model),
                FriendsPage(model),
                DoctorChatScreen(),
              ],
            ),
            bottomNavigationBar: Settings.currentIndex >= 0
                ? CustomBottomNavigationBar(
                    plusColor: _plusColor,
                    pageController: _getPageController(),
                    navigationTapped: (i) async {
                      if (i == 4) {
                        _plusColor = Colors.white;
                        setState(() {});
                        showOverlay(context, model);

                        animationController = AnimationController(
                            vsync: this, duration: Duration(milliseconds: 175));
                        animationController2 = AnimationController(
                            vsync: this, duration: Duration(milliseconds: 175));
                        animationController.forward();
                        animationController2.forward();
                      } else if (i < 4)
                        _getPageController().animateToPage(i + 1,
                            curve: Curves.bounceIn,
                            duration: Duration(milliseconds: 10));

                      setState(() {
                        if (i != 4) {
                          Settings.currentIndex = i;
                        }
                      });
                    })
                : null,
          );
        },
      ),
    );
  }

  OverlayEntry addMedicine;
  OverlayEntry blood;
  OverlayEntry heartRate;
  OverlayEntry eatFood;
  OverlayEntry drinkWater;
  OverlayEntry sleepHours;
  OverlayEntry close;
  OverlayEntry backGround;
  void showOverlay(BuildContext context, MainModel model) async {
    OverlayState state = Overlay.of(context);

    double startBottom = 65 / 2;
    double sidePadding = (MediaQuery.of(context).size.width / 10 - 12.5);

//circle equation :r^2 a^2+b^2
    addMedicine = OverlayEntry(builder: (context) {
      return Positioned(
          left: (40) * _controller.value + sidePadding,
          bottom: 360 * _controller.value + startBottom,
          child: Material(
            color: Colors.transparent,
            child: MenuListRow(
              title: "addMedicine",
              image: "ic_list_pill",
              animationController: animationController,
              animationController2: animationController2,
              onTap: () {
                _removeOverlay();
                _onMenuTap(1, model);
              },
            ),
          ));
    });
    blood = OverlayEntry(builder: (context) {
      return Positioned(
          left: (60) * _controller.value + sidePadding,
          bottom: 300 * _controller.value + startBottom,
          child: Material(
            color: Colors.transparent,
            child: MenuListRow(
              title: "bloodPressure",
              image: "ic_list_blood_pressure",
              animationController: animationController,
              animationController2: animationController2,
              onTap: () {
                _removeOverlay();
                _onMenuTap(2, model);
              },
            ),
          ));
    });
    heartRate = OverlayEntry(builder: (context) {
      return Positioned(
          left: (80) * _controller.value + sidePadding,
          bottom: 240 * _controller.value + startBottom,
          child: Material(
            color: Colors.transparent,
            child: MenuListRow(
              title: "heartRate",
              image: "ic_list_hear_rate",
              animationController: animationController,
              animationController2: animationController2,
              onTap: () {
                _removeOverlay();
                _onMenuTap(3, model);
              },
            ),
          ));
    });
    eatFood = OverlayEntry(builder: (context) {
      return Positioned(
          left: (60) * _controller.value + sidePadding,
          bottom: 180 * _controller.value + startBottom,
          child: Material(
            color: Colors.transparent,
            child: MenuListRow(
              title: "eatFood",
              image: "ic_list_food",
              animationController: animationController,
              animationController2: animationController2,
              onTap: () {
                _removeOverlay();
                _onMenuTap(4, model);
              },
            ),
          ));
    });
    drinkWater = OverlayEntry(builder: (context) {
      return Positioned(
          left: (40) * _controller.value + sidePadding,
          bottom: 120 * _controller.value + startBottom,
          child: Material(
            color: Colors.transparent,
            child: MenuListRow(
              title: "drinkWater",
              image: "ic_list_cup",
              animationController: animationController,
              animationController2: animationController2,
              onTap: () {
                _removeOverlay();
                _onMenuTap(5, model);
              },
            ),
          ));
    });
    sleepHours = OverlayEntry(builder: (context) {
      return Positioned(
          left: 20 * _controller.value + sidePadding,
          bottom: 60 * _controller.value + startBottom,
          child: Material(
            color: Colors.transparent,
            child: MenuListRow(
              title: "sleepHours",
              image: "ic_list_sleep",
              animationController: animationController,
              animationController2: animationController2,
              onTap: () {
                _removeOverlay();
                _onMenuTap(6, model);
              },
            ),
          ));
    });
    close = OverlayEntry(builder: (context) {
      return Positioned(
          left: allTranslations.currentLanguage == "ar"
              ? (MediaQuery.of(context).size.width / 10 - 12.5)
              : null,
          right: allTranslations.currentLanguage == "en"
              ? (MediaQuery.of(context).size.width / 10 - 12.5)
              : null,
          bottom: startBottom,
          child: Transform.rotate(
              angle: _rotateAmimation.value,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    _removeOverlay();
                  },
                  child: ImageIcon(
                    AssetImage("assets/icons/ic_add.png"),
                    size: 25,
                    color: Settings.mainColor(),
                  ),
                ),
              )));
    });

    backGround = OverlayEntry(builder: (context) {
      return Positioned(
          left: 0,
          bottom: 0,
          child: Material(
            color: Colors.transparent,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Color.fromRGBO(0, 0, 0, 0.8),
              child: InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  _removeOverlay();
                },
              ),
            ),
          ));
    });

    state.insert(backGround);
    state.insert(addMedicine);
    state.insert(blood);
    state.insert(heartRate);
    state.insert(eatFood);
    state.insert(drinkWater);
    state.insert(sleepHours);
    state.insert(close);
    _rotateCopntroller.forward();

    _controller.forward();
    _rotateCopntroller.addListener(() {
      state.setState(() {});
    });
  }

  _removeOverlay() async {
    _controller.reverse();
    animationController.reverse();
    animationController2.reverse();
    _rotateCopntroller.reverse().whenComplete(() {
      addMedicine.remove();
      blood.remove();
      heartRate.remove();
      eatFood.remove();
      drinkWater.remove();
      sleepHours.remove();
      backGround.remove();
      close.remove();
      _plusColor = Settings.mainColor();
      setState(() {});
    });
  }
}
