import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health/Models/home_model.dart';
import 'package:health/helpers/loading.dart';
import 'package:health/pages/measurement/addsugar.dart';
import 'package:health/scoped_models/main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared-data.dart';
import 'MainCircle/Circles.dart';
import 'package:health/Models/day.dart';
import 'package:health/pages/home/articleDetails.dart';
import 'package:intl/intl.dart' as intl;
import 'dart:math';
import 'dart:developer';
import 'package:flutter/foundation.dart';

// import 'package:health/pages/measurement/addsugar.dart';
//import 'package:pedometer/pedometer.dart';
import 'package:health/pages/others/barCharts.dart';
import 'package:health/pages/Settings.dart';
import '../../languages/all_translations.dart';
import 'package:health/pages/Settings.dart' as settings;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:screenshot_share_image/screenshot_share_image.dart';

class HomePage extends StatefulWidget {
  final PageController pageController;
  final MainModel model;

  HomePage({@required this.pageController, this.model});

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

  Response response;
  Dio dio = new Dio();

//  Map dataHome;
  MeasurementsBean dataHome;

  List<BannersListBean> banners = List<BannersListBean>();

  ///hight and colors for the bar charts 3 colors and hieght for each bar per day
  ///in order to change them with containerAnimation
  Color saGColor = Colors.green[300];
  Color saRColor = Colors.red;
  Color saYColor = Colors.yellow;

  Color suGColor = Colors.green[300];
  Color suRColor = Colors.red;
  Color suYColor = Colors.yellow;

  Color moGColor = Colors.green[300];
  Color moRColor = Colors.red;
  Color moYColor = Colors.yellow;

  Color tuGColor = Colors.green[300];
  Color tuRColor = Colors.red;
  Color tuYColor = Colors.yellow;

  Color weGColor = Colors.green[300];
  Color weRColor = Colors.red;
  Color weYColor = Colors.yellow;

  Color thGColor = Colors.green[300];
  Color thRColor = Colors.red;
  Color thYColor = Colors.yellow;

  Color frGColor = Colors.green[300];
  Color frRColor = Colors.red;
  Color frYColor = Colors.yellow;

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

  ///you wonder why i did this cuz simply the code is shitty
  ///so i will not go further than that
  ///
  /// the same thing for the value of the suger pressure

  int stGText = 100;
  int stRText = 176;
  int stYText = 140;

  int suGText = 100;
  int suRText = 176;
  int suYText = 140;

  int moGText = 100;
  int moRText = 176;
  int moYText = 140;

  int tuGText = 100;
  int tuRText = 176;
  int tuYText = 140;

  int weGText = 100;
  int weRText = 176;
  int weYText = 140;

  int thGText = 100;
  int thRText = 176;
  int thYText = 140;

  int frGText = 100;
  int frRText = 176;
  int frYText = 140;

  ///this variables GET sugar per day but not using them
  ///note: thats not my code
  double dataCharts0 = 0.0;
  double dataCharts1 = 0.0;
  double dataCharts2 = 0.0;
  double dataCharts3 = 0.0;
  double dataCharts4 = 0.0;
  double dataCharts5 = 0.0;
  double dataCharts6 = 0.0;
  bool loading;
  bool loading1;
  bool loading2;
  bool initOpen = true;

//  List list;
  List newList = [];
  List<int> _calories = [];
  DateTime selectedDate = DateTime.now();
  var date =
      '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';

  init(BuildContext context) {
    _scrollController = ScrollController(
        initialScrollOffset: MediaQuery.of(context).size.width - 130);
  }

  initState() {
    super.initState();
    getHomeFetch();
    getCustomerData();
    ChangeHieghtAnimation();
  }

  static Random rnd = new Random();
  static int gmin = 50;
  static int gmax = 100;
  static int rmin = 100;
  static int rmax = 120;
  static int ymin = 40;
  static int ymax = 80;
  bool istrue = false;

  bool ta8ier1;
  bool ta8ier2;
  bool ta8ier3;
  bool ta8ier4;
  bool ta8ier5;
  bool ta8ier6;
  bool ta8ier7;
  bool ta8ier8;
  bool ta8ier9;
  bool ta8ier10;
  bool ta8ier11;
  bool ta8ier12;
  bool ta8ier13;
  bool ta8ier14;
  bool ta8ier15;
  bool ta8ier16;

  void ChangeHieghtAnimation() {
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
    ta8ier1 = rnd.nextBool();
    ta8ier2 = rnd.nextBool();
    ta8ier3 = rnd.nextBool();
    ta8ier4 = rnd.nextBool();
    ta8ier5 = rnd.nextBool();
    ta8ier6 = rnd.nextBool();
    ta8ier7 = rnd.nextBool();
    ta8ier8 = rnd.nextBool();
    ta8ier9 = rnd.nextBool();
    ta8ier10 = rnd.nextBool();
    ta8ier11 = rnd.nextBool();
    ta8ier12 = rnd.nextBool();
    ta8ier13 = rnd.nextBool();
    ta8ier14 = rnd.nextBool();
    ta8ier15 = rnd.nextBool();
    ta8ier16 = rnd.nextBool();

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

    Future.delayed(Duration(milliseconds: initOpen ? 450 : 100), () {
      initOpen = false;
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
        // Here you can write your code for open new view
      });
    });
  }

  getHomeFetch() {
    setState(() {
      loading = true;
      loading1 = true;
    });
    widget.model.fetchHome(date).then((result) {
      print('*****************************************************');
      print('HERE is the start of Result');
      print(result == null ? 'fffff' : 'yyyy');
      print('*****************************************************');
      if (result != null) {
        print('ERORR HEEEEEEEEEEEEEEREEEEEEEEEEEEEEEe');
        setState(() {
          // Measurements
          dataHome = result.measurements;
          // Sugar Charts
          setState(() {
            // Articles banner
            banners = result.banners;
            loading1 = false;
            loading = false;
          });
        });
      } else {}
    });
  }

  void _onData(int stepCountValue) async {
    setState(() => _stepCountValue = stepCountValue);
  }

  void _onDone() => print("Finished pedometer tracking");

  void _onError(error) => print("Flutter Pedometer Error: $error");

  void _onCancel() => _subscription.cancel();

  //------------------ END STEP COUNTER -------------//

  void _handleSubmitted(
      BuildContext context, MainModel model, var value, String type) {
    model.addMeasurements(type, value).then((result) async {
//      print(result);
    });
  }

  dispose() {
    _onCancel();
    super.dispose();
  }

  Widget upperCircles(context, _chartRadius, model) {
    return loading == true
        ? Loading()
        : CustomMultiChildLayout(
            delegate: CirclesDelegate(_chartRadius),
            children: <Widget>[
              new LayoutId(
                id: 1,
                child: MainCircles.diabetes(
                  percent: 0.2,
                  context: context,
//                sugar: dataHome['sugar'].toString(),
                  sugar: dataHome == null
                      ? '0'
                      : dataHome.sugar == null
                          ? '0'
                          : dataHome.sugar.toString(),
                  raduis: _chartRadius,
                  status: dataHome == null
                      ? '0'
                      : dataHome.sugar == null
                          ? '0'
                          : (dataHome.sugar <= 100
                              ? allTranslations.text("good")
                              : dataHome.sugar <= 125
                                  ? allTranslations.text("normal")
                                  : dataHome.sugar > 126
                                      ? allTranslations.text("high")
                                      : ''),
                  ontap: () {
                    _showBottomSheet(
                        context: context,
                        model: model,
                        type: 'sugar',
                        title: "measure sugar",
                        subTitle: "enterTodaySugar",
                        imageName: "ic_blood_pressure",
                        min: 0.0,
                        max: 600.0);
                  },
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
                        onTap: () =>
                            ScreenshotShareImage.takeScreenshotShareImage(),
                      )),
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
                  ),
                ),
              ),
              new LayoutId(
                  id: 2,
                  child: MainCircles.cal(
                      percent: 0.5,
                      context: context,
//                day_Calories: dataHome['day_Calories'],
                      day_Calories: dataHome == null
                          ? '0'
                          : dataHome.calories == null
                              ? '0'
                              : dataHome.calories.toString(),
                      ontap: () => null,
                      raduis: _chartRadius,
                      footerText:
                          "Cal " + " 100 :" + allTranslations.text("Goal is"))),
              new LayoutId(
                id: 3,
                child: MainCircles.steps(
                    percent: 0.9,
                    context: context,
//              steps: dataHome['NumberOfSteps'] ?? 0,
                    steps: dataHome == null
                        ? 0
                        : dataHome.steps == null ? 0 : dataHome.steps,
                    raduis: _chartRadius,
                    onTap: () => null,
                    footerText:
                        " Step " + "100 :" + allTranslations.text("Goal is")),
              ),
              new LayoutId(
                id: 4,
                child: MainCircles.distance(
                    percent: 0.3,
                    context: context,
                    raduis: _chartRadius,
//              distance: dataHome['distance'].toString(),
                    distance: dataHome == null
                        ? '0'
                        : dataHome.distance == null
                            ? '0'
                            : dataHome.distance.toString(),
                    onTap: () => null,
                    footerText:
                        " meter " + "200 :" + allTranslations.text("Goal is")),
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
            onTap: () {
              DatePicker.showDatePicker(context,
                  showTitleActions: true,
                  minTime: DateTime(DateTime.now().year - 1),
                  maxTime: DateTime(DateTime.now().year + 1), onConfirm: (e) {
                print('confirm $e');
                setState(() {
                  date = '${e.year}-${e.month}-${e.day}';
                  print(date);
                  getHomeFetch();
                });
              }, currentTime: DateTime.now(), locale: LocaleType.ar);
            },
            child: Row(
              children: <Widget>[
                Text(
                  '$date',
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
        body: ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model) {
          return new Center(
            child: Container(
                color: Colors.white,
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child:
//                    ListView(
//                      children: <Widget>[
//                        Text('${newList}')
//                      ],
//                    )

                      new Column(
                    children: <Widget>[
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
                                  height: MediaQuery.of(context).size.height *
                                      3 /
                                      5,
                                ),
                                onTap: () {
                                  widget.pageController.animateToPage(0,
                                      duration: Duration(milliseconds: 10),
                                      curve: Curves.bounceIn);
                                },
                              ),
                            ),
                            Expanded(
                              child: upperCircles(context, _chartRadius, model),
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
                                height:
                                    MediaQuery.of(context).size.height * 3 / 5,
                                matchTextDirection: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                      ),
                      new Expanded(
                        flex: 2,
                        child: loading2 == true
                            ? Padding(
                                padding: EdgeInsets.all(20),
                                child: Loading(),
                              )
                            : Column(
                                children: <Widget>[
                                  new SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 11,
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: banners.length,
                                        controller: _scrollController,
                                        itemBuilder: (context, index) {
                                          return banners[index].type ==
                                                  'advertise'
                                              ? new Container(
                                                  decoration: ShapeDecoration(
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              'http://104.248.168.117/${banners[index].image}'),
                                                          fit: BoxFit.cover),
                                                      color: Colors.grey[200],
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10))),
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 5),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      100,
                                                )
                                              : new InkWell(
                                                  onTap:
//                                    newList[index]['name'] == null
//                                        ? null:
                                                      () async {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ArticleDetails(
                                                                model,
                                                                banners[index]
                                                                    .name,
                                                                banners[index]
                                                                    .id),
                                                      ),
                                                    );
                                                  },
                                                  child: new Container(
                                                    decoration: ShapeDecoration(
                                                        color: Colors.grey[200],
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10))),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            100,
                                                    child:
//                                      newList[index]['name'] == null
//                                          ? Image.network(
//                                              "http://104.248.168.117/${newList[index]['image']}",
//                                              fit: BoxFit.cover,
//                                            )
//                                          :
                                                        new Row(
                                                      children: <Widget>[
                                                        new Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .only(
                                                                  top: 10,
                                                                ),
                                                                child: Text(
                                                                  banners[index]
                                                                      .name,
                                                                  style: TextStyle(
                                                                      color: Color.fromRGBO(
                                                                          41,
                                                                          172,
                                                                          216,
                                                                          1),
                                                                      fontSize:
                                                                          20),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            10),
                                                                child: Text(
                                                                  banners[index]
                                                                      .created,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        10,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 130,
                                                          height: 100,
                                                          child: ClipRRect(
                                                            child:
                                                                Image.network(
                                                              "http://104.248.168.117/${banners[index].image}",
                                                              fit: BoxFit.fill,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                  ),
                                  //new chart
                                  loading1 == true
                                      ? Padding(
                                          padding: EdgeInsets.all(20),
                                          child: Loading(),
                                        )
                                      : new Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width
                                              ,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.24,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            color: Colors.grey.shade50,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                            children: <Widget>[
                                              InkWell(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: MediaQuery.of(
                                                          context)
                                                          .padding
                                                          .bottom +
                                                          60),
                                                  child: Image.asset(
                                                    'assets/icons/ic_arrow_small_l.png',
                                                    scale: 2,
                                                  ),
                                                ),
                                                onTap: () =>
                                                    ChangeHieghtAnimation(),
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
                                                            ta8ier1?
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
                                                            ):Container(
                                                              width: 10,
                                                              height: 1,
                                                            ),
                                                            ta8ier2?
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
                                                            ):
                                                            Container(
                                                              width: 10,
                                                              height: 1,
                                                            ),
                                                            ta8ier3?
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
                                                            ):Container(
                                                              width: 10,
                                                              height: 1,
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
                                                            ta8ier4?
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
                                                            ):Container(
                                                              width: 10,
                                                              height: 1,
                                                            ),
                                                            ta8ier5?
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
                                                            ):Container(
                                                              width: 10,
                                                              height: 1,
                                                            ),
                                                            ta8ier6?
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
                                                            ):Container(
                                                              width: 10,
                                                              height: 1,
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
                                                            ta8ier7?
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
                                                            ):Container(
                                                              width: 10,
                                                              height: 1,
                                                            ),
                                                            ta8ier8?
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
                                                            ):Container(
                                                              width: 10,
                                                              height: 1,
                                                            ),
                                                            ta8ier9?
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
                                                            ):Container(
                                                              width: 10,
                                                              height: 1,
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
                                                            ta8ier10?
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
                                                            ):Container(
                                                              width: 10,
                                                              height: 1,
                                                            ),
                                                            ta8ier11?
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
                                                            ):Container(
                                                              width: 10,
                                                              height: 1,
                                                            ),
                                                            ta8ier12?
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
                                                            ):Container(
                                                              width: 10,
                                                              height: 1,
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
                                                            ta8ier13?
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
                                                            ):Container(
                                                              width: 10,
                                                              height: 1,
                                                            ),
                                                            ta8ier14?
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
                                                            ):Container(
                                                              width: 10,
                                                              height: 1,
                                                            ),
                                                            ta8ier15?
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
                                                            ):Container(
                                                              width: 10,
                                                              height: 1,
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
                                                            ta8ier16?Column(
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
                                                            ):
                                                            Container(
                                                              width: 10,
                                                              height: 1,
                                                            ),
                                                            ta8ier7?Column(
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
                                                            ):
                                                            Container(
                                                              width: 10,
                                                              height: 1,
                                                            ),
                                                            ta8ier3?
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
                                                            ):
                                                            Container(
                                                              width: 10,
                                                              height: 1,
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
                                                            ta8ier9?
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
                                                            ):
                                                            Container(
                                                              width: 10,
                                                              height: 1,
                                                            ),
                                                            ta8ier13?
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
                                                            ):
                                                            Container(
                                                              width: 10,
                                                              height: 1,
                                                            ),
                                                            ta8ier5?
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
                                                            ):
                                                            Container(
                                                              width: 10,
                                                              height: 1,
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
                                                      bottom: MediaQuery.of(
                                                          context)
                                                          .padding
                                                          .bottom +
                                                          60),
                                                  child: Image.asset(
                                                    'assets/icons/ic_arrow_small_r.png',
                                                    scale: 2,
                                                  ),
                                                ),
                                                onTap: () =>
                                                    ChangeHieghtAnimation(),
                                              ),
                                            ],
                                          ),
                                        )
                                ],
                              ),
                      )
                    ],
                  ),
                )),
          );
        }));
  }

//  final Color leftBarColor = Color(0xff53fdd7);
  final Color rightBarColor = Colors.redAccent;
  final double width = 7;
  final Color barBackgroundColor = Colors.grey.shade200;

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
      BarChartRodData(
        y: y2,
        color: rightBarColor,
        width: width,
        isRound: true,
        backDrawRodData: BackgroundBarChartRodData(
          show: true,
          y: 20,
          color: barBackgroundColor,
        ),
      ),
    ]);
  }

  Widget makeTransactionsIcon() {
    double width = 4.5;
    double space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
        SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withOpacity(1),
        ),
        SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
      ],
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
                                MediaQuery.of(context).size.width * 14 / 720),
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
      MainModel model,
      String title,
      String type,
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
              onSave: (String value) {
                _handleSubmitted(context, model, value, type);
              });
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
