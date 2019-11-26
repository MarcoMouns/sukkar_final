import 'dart:async';
import 'dart:async' as prefix0;
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:fit_kit/fit_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:health/Models/home_model.dart';
import 'package:health/helpers/loading.dart';
import 'package:health/pages/Social/friends.dart';
import 'package:health/pages/measurement/addsugar.dart';
import 'package:health/pages/others/adDetails.dart';
import 'package:health/pages/others/map.dart';
import 'package:health/pages/others/notification.dart';
import 'package:health/scoped_models/main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipedetector/swipedetector.dart';
import '../../shared-data.dart';
import 'MainCircle/Circles.dart';
import 'package:health/pages/home/articleDetails.dart';
import 'package:flutter/foundation.dart';
import 'package:health/pages/Settings.dart';
import '../../languages/all_translations.dart';
import 'package:health/pages/Settings.dart' as settings;
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:screenshot_share_image/screenshot_share_image.dart';
import 'articlesCategory.dart';
import 'measurementsDetailsPage.dart';

class HomePage extends StatefulWidget {
  final MainModel model;

  HomePage({this.model});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
//width of the screen to init the siwiper postion
  var dateSplit;
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

//to know where it's first time or not user to idnitfy swiper postion
  bool _firstPageLoad = true;
//scrollController to init the swiper postion
  ScrollController _scrollController;
  Response response;
  MeasurementsBean dataHome;
  int sugerToday;
  String timeOfLastMeasure = "";
  List<BannersListBean> banners = List<BannersListBean>();

  bool loading;
  bool loading1;
  bool loading2;
  bool initOpen = true;

  List<dynamic> datesOfMeasures = [" ", " ", " ", " ", " ", " ", " "];
  List<dynamic> measuresData = [
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0]
  ];

  bool istrue = false;
  List newList = [];
  List<int> _calories = [];
  int Rcalories;
  DateTime selectedDate = DateTime.now();
  DateTime dummySelectedDate = DateTime.now();

  var date =
      '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';

  int distance = 0;
  int steps;
  int calories;
  int cupOfWater;
  int heartRate;
  int bloodPresure1;
  int bloodPresure2;
  int calGoals;
  int goalOfWater;
  int stepsGoal;
  int distanceGoal;

  init(BuildContext context) {
    _scrollController = ScrollController(
        initialScrollOffset: MediaQuery.of(context).size.width - 130);
  }

  List healthKitStepsData;
  List healthKitDistanceData;
  List fitStepsData = new List();
  List fitDistanceData = new List();
static TimeOfDay t = TimeOfDay(hour: 1, minute: 0);
  static DateTime now = new DateTime.now();
  DateTime night12 =  DateTime(now.year, now.month, now.day, t.hour, t.minute);



  Future<List<int>> healthKit() async {
    List<int> Steps = new List<int>();
    List<int> disctance = new List<int>();

    healthKitStepsData = await FitKit.read(
      DataType.STEP_COUNT,
      night12,
      DateTime.now(),
    );

    healthKitDistanceData = await FitKit.read(
      DataType.DISTANCE,
      night12,
      DateTime.now(),
    );

    for (int i = 0; i <= healthKitDistanceData.length - 1; i++) {
      fitDistanceData.add(healthKitDistanceData[i]);
      disctance.add(fitDistanceData[i].value.round());
    }

    if (disctance.isEmpty) {
      distance = 0;
    } else {
      for (int i = 0; i <= disctance.length - 1; i++) {
        print('huh eh tani -_- ->>>>> $distance');
        distance = disctance[i] + distance;
      }
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      Map<String, dynamic> authUser =
          jsonDecode(sharedPreferences.getString("authUser"));

      print('-----------------------omgggggggg----------->');
      Map userHeader = {
        "Content-type": "application/json",
        "Acce0pt": "application/json",
        "Authorization": "Bearer ${authUser['authToken']}"
      };

      var response = await http.post("$baseUrl/update-distance", body: {
        "distance": "$distance",
      }, headers: {
        "Authorization": "Bearer ${authUser['authToken']}"
      });

      print('-----------------------omgggggggg-----------> ${response.body}');
      setState(() {});
    }

    print('------OOOOOMMMMMMGGGGGGG-----------------> $disctance');

    if (healthKitStepsData.isEmpty) {
      return Steps;
    } else {
      for (int i = 0; i <= healthKitStepsData.length - 1; i++) {
        fitStepsData.add(healthKitStepsData[i]);
        print("Fit data ===> ${healthKitStepsData[i]}");
        Steps.add(fitStepsData[i].value.round());
        print(fitStepsData[i].value.round());
      }
      return Steps;
    }
  }

  int totalSteps = 0;
  bool flag = true;
  int step = 0;

  void calculateSteps() async {
    int steps = 0;
    List<int> StepsList = new List<int>();
    StepsList = await healthKit();
    print("=====================================================");
    print("=====================================================");
    print("=====================================================");
    print(healthKitStepsData);
    print("=====================================================");
    print("=====================================================");
    print("=====================================================");

    if (StepsList.isEmpty) {
      totalSteps = 0;
      print('a7na hna men al zerooooooooooooooooo');
    } else {
      for (int i = 0; i <= StepsList.length - 1; i++) {
        
        print('huh eh tani -_- ->>>>> $steps');
        steps = StepsList[i] + steps;
      }
      if (flag == true) {
        totalSteps = steps;
        print(totalSteps);
      }
      flag = false;
      step = steps;
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      Map<String, dynamic> authUser =
          jsonDecode(sharedPreferences.getString("authUser"));

      print('-----------------------omgggggggg----------->');
      Map userHeader = {
        "Content-type": "application/json",
        "Acce0pt": "application/json",
        "Authorization": "Bearer ${authUser['authToken']}"
      };
      var response =
          await http.post("http://api.sukar.co/api/update-steps", body: {
        "steps": "$step",
      }, headers: {
        "Authorization": "Bearer ${authUser['authToken']}"
      });
      print('-----------------------omgggggggg-----------> ${response.body}');
      setState(() {});
    }
  }

  initState() {
    setState(() {
      Settings.currentIndex = 0;
    });
    calculateSteps();
    getMeasurementsForDay(date);
    super.initState();
    Timer.periodic(Duration(minutes: 15), (Timer t) => sendWorkingHours());

    dummySelectedDate = DateTime.now();
    selectedDate = DateTime.now();
    emptylists();
    fetchMeals();
    print(sugerToday);
    getCustomerData();
    getMeasurements(date);
    getHomeFetch();
    getcal();
    setFirebaseImage();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_logo');
    var iOS = new IOSInitializationSettings();
    var initSettings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    showDialog(
      context: context,
      builder: (_) {
        return new AlertDialog(
          title: Text("PayLoad"),
          content: Text("Payload : $payload"),
        );
      },
    );
  }

  static showNotification(String title, body) async {
    var andriod = new AndroidNotificationDetails(
        "channelId", "channelName", "channelDescription",
        priority: Priority.High, importance: Importance.Max);
    var iOS = new IOSNotificationDetails();

    var platform = new NotificationDetails(andriod, iOS);
    await flutterLocalNotificationsPlugin.show(0, title, body, platform,
        payload: "");
  }

  Future<void> fetchMeals() async {
    await widget.model.fetchAllMealsFoods().then((result) {
      print('Result fetch => $result');
      if (result != null) {
        setState(() {
          _calories = result.userFoods.map((meal) => meal.calories).toList();
          print('******************************_calories = > $_calories');
          addIntToSF();
          getValuesSF();
        });
      } else {}
    }).catchError((err) {
      print(err);
    });
  }

  addIntToSF() async {
    print(_calories);
    if (_calories.length == 0) {
      Rcalories = 0;
    } else {
      Rcalories = _calories.reduce((a, b) => a + b).toInt();
    }
    print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');

    // print(a);
  }

  int calTarget = 0;
  bool circleCalorie = true;
  bool circleSteps = true;
  bool circleDistance = true;
  bool circleWater = false;
  bool circleHeart = false;
  bool circleBlood = false;

  getValuesSF() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, dynamic> authUser =
        jsonDecode(sharedPreferences.getString("authUser"));
    var headers = {
      "Authorization": "Bearer ${authUser['authToken']}",
    };
    response =
        await dio.get("$baseUrl/auth/me", options: Options(headers: headers));

    print('hna al respnese bta3 me ea baaaaaaaaaaaaaaaaah');
    print('=>>>>>>>>>>>$response');

    circleBlood = response.data['user']['circles']['blood'];
    circleHeart = response.data['user']['circles']['heart'];
    circleSteps = response.data['user']['circles']['steps'];
    circleWater = response.data['user']['circles']['water'];
    circleCalorie = response.data['user']['circles']['calorie'];
    circleDistance = response.data['user']['circles']['distance'];

    print('BLood => $circleBlood');
    print('heart => $circleHeart');
    print('water => $circleWater');
    print('cal => $circleCalorie');
    print('distance => $circleDistance');

    ncal = response.data['user']['average_calorie'];
    if (ncal == null) {
      ncal = 0;
    }

    print(ncal);

    print(Rcalories);

    if (Rcalories > ncal && ncal != 0) {
      calTarget = Rcalories - ncal;
    }

    print('HEEEEEEEEEEEEEEEEERRRRRREEEEEEEEEEEE');

    print('BLood => $circleBlood');
    print('heart => $circleHeart');
    print('water => $circleWater');
    print('cal => $circleCalorie');
    print('distance => $circleDistance');

    initialCircles(169.0285);
    initListOfCircles();
    setState(() {});
    loading = false;
    loading1 = false;
    loading2 = false;
    print('5araaaaaa a7ba tete latete ketere grrrrrrrrrrrrrrrrrrrrrrrrrrr');
    print(SharedData.customerData['fuid']);
    setState(() {});
  }

  static Future setFirebaseImage() async {
    //print(SharedData.customerData['fuid']);
    //print(SharedData.customerData['image']);
    Firestore.instance
        .collection('users')
        .document(SharedData.customerData['fuid'])
        .updateData({
      'photoUrl': SharedData.customerData['image'],
    });
    print('EEEEEEEEEEEEEEEEEEEEEEEEEEEEENNNNNNNNND');
  }

  int ncal = 1;
  void getcal() async {
    ncal = calTarget;

    if (ncal == null || ncal == 0) {
      ncal = 0;
    }
    print('YOYOYOYOYOYOYOYOYOYOYOYOYOYOYOYOYOYOYO');
    print(ncal);
    print('YOYOYOYOYOYOYOYOYOYOYOYOYOYOYOYOYOYOYO');
    setState(() {});
  }

  Dio dio = new Dio();

  final String baseUrl = 'http://api.sukar.co/api';

  Future sendWorkingHours() async {
    Response response;

    // try {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, dynamic> authUser =
        jsonDecode(sharedPreferences.getString("authUser"));
    var headers = {
      "Authorization": "Bearer ${authUser['authToken']}",
    };
    response =
        await dio.get("$baseUrl/auth/me", options: Options(headers: headers));

    int isDoctor = response.data["user"]["state"];
    if (isDoctor == 2) {
      Response response2;

      response2 = await dio.put("$baseUrl/doctors/update-work-hours?minutes=15",
          options: Options(headers: headers));
      print('Response2 ---------------> ${response2.data}');
    }
  }

  Future<int> getMeasurementsForDay(String date) async {
    Response response;

    // try {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, dynamic> authUser =
        jsonDecode(sharedPreferences.getString("authUser"));
    var headers = {
      "Authorization": "Bearer ${authUser['authToken']}",
    };
    response = await dio.get("$baseUrl/measurements?date=$date",
        options: Options(headers: headers));
    sugerToday = response.data["Measurements"]["sugar"][0]["sugar"];
    print("=================================================fffffffffff");
    timeOfLastMeasure = response.data["Measurements"]["sugar"][0]["time"];

    sugerToday = response.data["Measurements"]["sugar"][0]["sugar"] == null
        ? 0
        : response.data["Measurements"]["sugar"][0]["sugar"];
    distance = response.data["Measurements"]["distance"] == null
        ? 0
        : response.data["Measurements"]["distance"];
    calories = response.data["Measurements"]["day_Calories"] == null
        ? 0
        : response.data["Measurements"]["day_Calories"];
    cupOfWater = response.data["Measurements"]["water_cups"] == null
        ? 0
        : response.data["Measurements"]["water_cups"];
    bloodPresure1 = response.data["Measurements"]["DiastolicPressure"] == null
        ? 0
        : response.data["Measurements"]["DiastolicPressure"];
    bloodPresure2 = response.data["Measurements"]["SystolicPressure"] == null
        ? 0
        : response.data["Measurements"]["SystolicPressure"];
    heartRate = response.data["Measurements"]["Heartbeat"] == null
        ? 0
        : response.data["Measurements"]["Heartbeat"];

    calGoals = response.data["Measurements"]["calorie_goal"] == null
        ? 0
        : response.data["Measurements"]["calorie_goal"];
    goalOfWater = response.data["Measurements"]["water_cups_goal"] == null
        ? 0
        : response.data["Measurements"]["water_cups_goal"];
    stepsGoal = response.data["Measurements"]["steps_goal"] == null
        ? 0
        : response.data["Measurements"]["steps_goal"];
    distanceGoal = response.data["Measurements"]["distance_goal"] == null
        ? 0
        : response.data["Measurements"]["distance_goal"];

    if (cupOfWater >= goalOfWater && goalOfWater != 0) {
      showNotification(allTranslations.text("dailyGoal_Completed"),
          allTranslations.text("waterGoal_Completed"));
    }

    if (calories >= calGoals && calories != 0) {
      showNotification(allTranslations.text("dailyGoal_Completed"),
          allTranslations.text("caloriesGoal_Completed"));
    }

    print('@rami HNA KOBAIET 2om AL MAYA');
    print(calGoals);
    print(calories);

    setState(() {});

    return response.data["Measurements"]["sugar"][0]["sugar"];
  }

  Future<Response> getMeasurements(String date1) async {
    Response response;

    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      Map<String, dynamic> authUser =
          jsonDecode(sharedPreferences.getString("authUser"));
      var headers = {
        "Authorization": "Bearer ${authUser['authToken']}",
      };

      response = await dio.get("$baseUrl/measurements/sugarReads?date=$date1",
          options: Options(headers: headers));

      List<dynamic> date = new List();
      List<dynamic> suger = new List();

      for (int i = 0; i <= 6; i++) {
        date.add(response.data['week'][i]['date']);

        var holder = [0, 0, 0];
        for (var j = 0; j < 3; j++) {
          holder[j] = response.data['week'][i]['sugar'][j]['sugar'];
        }
        suger.add(holder);
      }

      datesOfMeasures = date;
      print(datesOfMeasures);
      measuresData = suger;
      print(measuresData);
      setState(() {});
    } catch (e) {
      print("error =====================");
    }

    print('++++++++++++++++++++++++++++++++++from here we end the GETCAL');
    return response;
  }

  void emptylists() {
    for (var i = 0; i <= 6; i++) {
      datesOfMeasures[i] = " ";
      for (var j = 0; j < 3; j++) {
        measuresData[i][j] = 0;
      }
    }
  }

  void incrementWeek() {
    String dummyDate;
    istrue = true;
    dummySelectedDate = dummySelectedDate.subtract(new Duration(days: 7));
    emptylists();
    setState(() {});
    print(
        "waaaaaaa&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
    Future.delayed(Duration(milliseconds: initOpen ? 300 : 300), () {
      initOpen = false;
      istrue = false;
      print(
          "waaaaaaa++++++++++++++++++++++++++___________________________________________________________");

      setState(() {
        dummyDate =
            '${dummySelectedDate.year}-${dummySelectedDate.month}-${dummySelectedDate.day}';
        print(date);
        getMeasurements(dummyDate);

        selectedDate = selectedDate;
      });
    });
  }

  void decrementWeek() {
    String dummyDate;
    istrue = true;
    dummySelectedDate = dummySelectedDate.subtract(new Duration(days: 7));
    emptylists();
    setState(() {});
    print(
        "waaaaaaa&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
    Future.delayed(Duration(milliseconds: initOpen ? 100 : 100), () {
      initOpen = false;
      istrue = false;
      print(
          "waaaaaaa++++++++++++++++++++++++++___________________________________________________________");
      setState(() {
        dummyDate =
            '${dummySelectedDate.year}-${dummySelectedDate.month}-${dummySelectedDate.day}';
        print(date);
        getMeasurements(dummyDate);
        selectedDate = selectedDate;
      });
    });
  }

  getHomeFetch() {
    setState(() {
      loading = true;
      loading1 = true;
    });
    widget.model.fetchHome(date).then(
      (result) {
        print('*****************************************************');
        print('HERE is the start of Result');
        print(result == null ? 'fffff' : 'yyyy');
        print('*****************************************************');
        if (result != null) {
          setState(() {
            // Measurements

            dataHome = result.measurements;
            print(sugerToday);

            print(dataHome.sugar);
            getMeasurementsForDay(date);
            print(dataHome.sugar);
            // Sugar Charts
            Future.delayed(Duration(milliseconds: initOpen ? 100 : 100), () {
              setState(() {
                // Articles banner

                banners = result.banners;
                loading1 = false;
                getMeasurementsForDay(date);
              });
            });
          });
        }
      },
    );

    setState(() {});
  }

  //------------------ END STEP COUNTER -------------//

  void _handleSubmitted(
      BuildContext context, MainModel model, var value, String type) {
    model.addMeasurements(type, value).then((result) async {
//      print(result);
    });
  }

  List<Widget> coCircles = new List<Widget>();
  Widget widgetCircleCalorie;
  Widget widgetCircleSteps;
  Widget widgetCircleDistance;
  Widget widgetCircleWater;
  Widget widgetCircleHeart;
  Widget widgetCircleBlood;
  Color greenColor = Color.fromRGBO(229, 246, 211, 1);
  Color redColor = Color.fromRGBO(253, 238, 238, 1);
  Color yellowColor = Color.fromRGBO(254, 252, 232, 1);

  void initListOfCircles() {
    coCircles.clear();
    if (circleCalorie == true) {
      coCircles.add(widgetCircleCalorie);
    }
    if (circleDistance == true) {
      coCircles.add(widgetCircleDistance);
    }
    if (circleBlood == true) {
      coCircles.add(widgetCircleBlood);
    }
    if (circleHeart == true) {
      coCircles.add(widgetCircleHeart);
    }
    if (circleWater == true) {
      coCircles.add(widgetCircleWater);
    }
    if (circleSteps == true) {
      coCircles.add(widgetCircleSteps);
    }

    setState(() {});
  }

  void initialCircles(_chartRadius) {
    widgetCircleCalorie = MainCircles.cal(
        percent: dataHome == null
            ? 0
            : dataHome.calories == null
                ? 0
                : ncal == 0
                    ? 0
                    : (dataHome.calories / calGoals) > 1
                        ? 1
                        : (((dataHome.calories / calGoals))),
        context: context,
        day_Calories: dataHome == null
            ? 0
            : dataHome.calories == null ? 0 : dataHome.calories.toString(),
        ontap: () => null,
        raduis: _chartRadius,
        footerText: "Cal " + " $calGoals :" + allTranslations.text("Goal is"));
    widgetCircleSteps = MainCircles.steps(
        percent:dataHome.steps == null
                ? 0
                : (dataHome.steps / stepsGoal) > 1
                    ? 1
                    : ncal == 0 ? 0 : ((dataHome.steps / stepsGoal)),
        context: context,
        steps: dataHome.steps == null ? 0 : dataHome.steps == null ? 0 : dataHome.steps,
        raduis: _chartRadius,
        onTap: () => null,
        footerText: allTranslations.text("Goal is") +
            ": $stepsGoal " +
            allTranslations.text("steps"));
    widgetCircleDistance = MainCircles.distance(
        percent: dataHome.distance == null
                ? 0
                : ncal == 0 ? 0 : ((dataHome.distance/ distanceGoal)),
        context: context,
        raduis: _chartRadius,
        distance: dataHome == null
            ? '0'
            : dataHome.distance == null ? '0' : dataHome.distance.toString(),
        onTap: () => null,
        footerText:
            " m " + "${distanceGoal} :" + allTranslations.text("Goal is"));

    widgetCircleWater = MainCircles.water(
        percent: cupOfWater == null
            ? 0
            : (cupOfWater / goalOfWater) > 1 ? 1 : ((cupOfWater / goalOfWater)),
        context: context,
        raduis: _chartRadius,
        numberOfCups: dataHome == null
            ? '0'
            : cupOfWater == null ? '0' : cupOfWater.toString(),
        onTap: () => null,
        footerText: allTranslations.text("Goal is") +
            ": " +
            "${(goalOfWater).toString()}");

    widgetCircleHeart = MainCircles.heart(
        percent: heartRate == null
            ? 0
            : (heartRate / 160) > 1 ? 1 : (heartRate / 160),
        context: context,
        raduis: _chartRadius,
        heart: heartRate == null ? '0' : heartRate.toString(),
        onTap: () => null,
        footerText: "");

    widgetCircleBlood = MainCircles.blood(
        percent: bloodPresure2 == null
            ? 0
            : (((bloodPresure2 / 180) > 1 ? 1 : (bloodPresure2 / 180))),
        context: context,
        raduis: _chartRadius,
        blood: bloodPresure1 == null
            ? '0'
            : bloodPresure2.toString() + "/" + bloodPresure1.toString(),
        onTap: () => null,
        footerText: "");
    setState(() {});
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
                  percent: sugerToday == 0 || sugerToday == null
                      ? 1 / 600
                      : ((sugerToday / 600)),
                  context: context,
                  time: timeOfLastMeasure,
                  sugar: sugerToday == 0
                      ? '0'
                      : sugerToday == null ? '0' : sugerToday.toString(),
                  raduis: _chartRadius,
                  status: sugerToday == 0 || sugerToday == null
                      ? allTranslations.text("sugarNull")
                      : (sugerToday < 69)
                          ? allTranslations.text("low")
                          : (sugerToday >= 70 && sugerToday <= 89)
                              ? allTranslations.text("LowNormal")
                              : (sugerToday >= 90 && sugerToday <= 200)
                                  ? allTranslations.text("normal")
                                  : allTranslations.text("high"),
                  ontap: () {
                    Navigator.of(context).push(
                      new MaterialPageRoute(
                          builder: (_) => new AddSugar(selectedDate)),
                    );
                  },
                  footer: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      SizedBox(
                        height: _chartRadius / 11,
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
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    FriendsPage(model, true)));
//                            widget.pageController.animateToPage(3,
//                                duration: Duration(
//                                  milliseconds: 10,
//                                ),
//                                curve: Curves.bounceIn);
                          },
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            overflow: Overflow.visible,
                            children: <Widget>[
                              Positioned(
                                child: CircleAvatar(
                                  radius: 6,
                                  backgroundImage:
                                      AssetImage("assets/imgs/profile.jpg"),
                                ),
                              ),
                              Positioned(
                                left: 8.5,
                                child: CircleAvatar(
                                  radius: 6,
                                  backgroundImage:
                                      AssetImage("assets/imgs/profile.jpg"),
                                ),
                              ),
                              Positioned(
                                left: 16,
                                child: Icon(
                                  Icons.add,
                                  size: 13,
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
              new LayoutId(id: 2, child: coCircles[0]),
              new LayoutId(
                id: 3,
                child: coCircles[1],
              ),
              new LayoutId(
                id: 4,
                child: coCircles[2],
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
    return loading == true
        ? Loading()
        : Scaffold(
            appBar: Settings.appBar(
              context: context,
              title: InkWell(
                onTap: () {
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: DateTime(DateTime.now().year - 1),
                      maxTime: DateTime(DateTime.now().year + 1),
                      onConfirm: (e) {
                    print('confirm $e');
                    setState(() {
                      date = '${e.year}-${e.month}-${e.day}';
                      print(date);

                      getHomeFetch();
                      getMeasurementsForDay(date);
                      getMeasurements(date);
                      getValuesSF();

                      selectedDate = e;
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
            body: WillPopScope(
              child: ScopedModelDescendant<MainModel>(builder:
                  (BuildContext context, Widget child, MainModel model) {
                return Directionality(
                  textDirection: TextDirection.ltr,
                  child: new ListView(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top + 15)),
                      SizedBox(
                        child: Column(
                          children: <Widget>[
                            Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.455,
                              child: Row(
                                children: <Widget>[
                                  Container(),
                                  InkWell(
                                    onTap: () {
                                      //cIndex = 1;
                                    },
                                    child: Image.asset(
                                      "assets/icons/ic_arrow_l.png",
                                      width: 15,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              3,
                                      matchTextDirection: true,
                                    ),
                                  ),
                                  Expanded(
                                    child: upperCircles(
                                        context, _chartRadius, model),
                                  ),
                                  InkWell(
                                    onTap: () {
//                                          widget.pageController.animateToPage(0,
//                                              curve: Curves.bounceIn,
//                                              duration: Duration(milliseconds: 10));
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => MapPage()));
                                    },
                                    child: Image.asset(
                                      "assets/icons/ic_arrow_r.png",
                                      width: 15,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              3,
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
                                      padding: EdgeInsets.all(10),
                                      child: Loading(),
                                    )
                                  : Column(
                                      children: <Widget>[
                                        new SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              11,
                                          child: Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: banners.length,
                                              controller: _scrollController,
                                              itemBuilder: (context, index) {
                                                return banners[index].type ==
                                                        'advertise'
                                                    ? GestureDetector(
                                                        onTap: () {
                                                          Navigator.of(context).push(MaterialPageRoute(
                                                              builder: (context) =>
                                                                  AdDetailsScreen(
                                                                      banners[index]
                                                                          .image,
                                                                      banners[index]
                                                                          .text)));
                                                        },
                                                        child: new Container(
                                                          decoration: ShapeDecoration(
                                                              image: DecorationImage(
                                                                  image: NetworkImage(
                                                                      'http://api.sukar.co/${banners[index].image}'),
                                                                  fit: BoxFit
                                                                      .cover),
                                                              color: Colors
                                                                  .grey[200],
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10))),
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      10),
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              100,
                                                        ))
                                                    : new InkWell(
                                                        onTap: () async {
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
                                                              color: Colors
                                                                  .grey[200],
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10))),
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      10),
                                                          width: 230,
                                                          child: new Row(
                                                            children: <Widget>[
                                                              SizedBox(
                                                                width: 80,
                                                                height: 100,
                                                                child:
                                                                    ClipRRect(
                                                                  child: Image
                                                                      .network(
                                                                    "http://api.sukar.co/${banners[index].image}",
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                child: Column(
                                                                  children: <
                                                                      Widget>[
                                                                    Padding(
                                                                      padding: EdgeInsets.only(
                                                                          top:
                                                                              10,
                                                                          right:
                                                                              10),
                                                                      child:
                                                                          Text(
                                                                        banners[index]
                                                                            .name,
                                                                        style: TextStyle(
                                                                            color: Color.fromRGBO(
                                                                                41,
                                                                                172,
                                                                                216,
                                                                                1),
                                                                            fontSize:
                                                                                15),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets
                                                                          .only(
                                                                              top: 5),
                                                                      child:
                                                                          Text(
                                                                        banners[index]
                                                                            .created,
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.grey,
                                                                          fontSize:
                                                                              10,
                                                                        ),
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
                                                    .width,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.24,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  color: Colors.grey.shade50,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
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
                                                                60,
                                                            top: MediaQuery.of(
                                                                        context)
                                                                    .padding
                                                                    .top +
                                                                60,
                                                            right: MediaQuery.of(
                                                                        context)
                                                                    .padding
                                                                    .right +
                                                                10),
                                                        child: Image.asset(
                                                          'assets/icons/ic_arrow_small_l.png',
                                                          scale: 2,
                                                        ),
                                                      ),
                                                      onTap: () =>
                                                          decrementWeek(),
                                                    ),
                                                    Directionality(
                                                      textDirection:
                                                          TextDirection.rtl,
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.88,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.24,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: <Widget>[
                                                            SwipeDetector(
                                                              onSwipeRight: () {
                                                                incrementWeek();
                                                              },
                                                              onSwipeLeft: () {
                                                                decrementWeek();
                                                              },
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                children:
                                                                    charts(),
                                                              ),
                                                            ),
                                                            Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.9,
                                                                height: 1,
                                                                color: Colors
                                                                    .grey[500]),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: <
                                                                  Widget>[
                                                                Column(
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      allTranslations
                                                                          .text(
                                                                              "saturday"),
                                                                      style: TextStyle(
                                                                          fontSize: MediaQuery.of(context).size.width *
                                                                              21 /
                                                                              720,
                                                                          color:
                                                                              Colors.grey),
                                                                      textScaleFactor:
                                                                          1.0,
                                                                    ),
                                                                    Text(
                                                                      datesOfMeasures[0][0] ==
                                                                              " "
                                                                          ? " "
                                                                          : '${datesOfMeasures[0].split("-")[1]}/${datesOfMeasures[0].split("-")[2]}',
                                                                      style: TextStyle(
                                                                          fontSize: MediaQuery.of(context).size.width *
                                                                              16 /
                                                                              720,
                                                                          color:
                                                                              Colors.grey),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Column(
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      allTranslations
                                                                          .text(
                                                                              "sunday"),
                                                                      style: TextStyle(
                                                                          fontSize: MediaQuery.of(context).size.width *
                                                                              21 /
                                                                              720,
                                                                          color:
                                                                              Colors.grey),
                                                                      textScaleFactor:
                                                                          1.0,
                                                                    ),
                                                                    Text(
                                                                        datesOfMeasures[0][0] ==
                                                                                " "
                                                                            ? " "
                                                                            : '${datesOfMeasures[1].split("-")[1]}/${datesOfMeasures[1].split("-")[2]}',
                                                                        style: TextStyle(
                                                                            fontSize: MediaQuery.of(context).size.width *
                                                                                16 /
                                                                                720,
                                                                            color: Colors
                                                                                .grey),
                                                                        textScaleFactor:
                                                                            1.0),
                                                                  ],
                                                                ),
                                                                Column(
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      allTranslations
                                                                          .text(
                                                                              "monday"),
                                                                      style: TextStyle(
                                                                          fontSize: MediaQuery.of(context).size.width *
                                                                              21 /
                                                                              720,
                                                                          color:
                                                                              Colors.grey),
                                                                      textScaleFactor:
                                                                          1.0,
                                                                    ),
                                                                    Text(
                                                                      datesOfMeasures[0][0] ==
                                                                              " "
                                                                          ? " "
                                                                          : '${datesOfMeasures[2].split("-")[1]}/${datesOfMeasures[2].split("-")[2]}',
                                                                      style: TextStyle(
                                                                          fontSize: MediaQuery.of(context).size.width *
                                                                              16 /
                                                                              720,
                                                                          color:
                                                                              Colors.grey),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Column(
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      allTranslations
                                                                          .text(
                                                                              "tuesday"),
                                                                      style: TextStyle(
                                                                          fontSize: MediaQuery.of(context).size.width *
                                                                              21 /
                                                                              720,
                                                                          color:
                                                                              Colors.grey),
                                                                      textScaleFactor:
                                                                          1.0,
                                                                    ),
                                                                    Text(
                                                                      datesOfMeasures[0][0] ==
                                                                              " "
                                                                          ? " "
                                                                          : '${datesOfMeasures[3].split("-")[1]}/${datesOfMeasures[3].split("-")[2]}',
                                                                      style: TextStyle(
                                                                          fontSize: MediaQuery.of(context).size.width *
                                                                              16 /
                                                                              720,
                                                                          color:
                                                                              Colors.grey),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Column(
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      allTranslations
                                                                          .text(
                                                                              "wednesday"),
                                                                      style: TextStyle(
                                                                          fontSize: MediaQuery.of(context).size.width *
                                                                              21 /
                                                                              720,
                                                                          color:
                                                                              Colors.grey),
                                                                      textScaleFactor:
                                                                          1.0,
                                                                    ),
                                                                    Text(
                                                                      datesOfMeasures[0][0] ==
                                                                              " "
                                                                          ? " "
                                                                          : '${datesOfMeasures[4].split("-")[1]}/${datesOfMeasures[4].split("-")[2]}',
                                                                      style: TextStyle(
                                                                          fontSize: MediaQuery.of(context).size.width *
                                                                              16 /
                                                                              720,
                                                                          color:
                                                                              Colors.grey),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Column(
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      allTranslations
                                                                          .text(
                                                                              "thursday"),
                                                                      style: TextStyle(
                                                                          fontSize: MediaQuery.of(context).size.width *
                                                                              21 /
                                                                              720,
                                                                          color:
                                                                              Colors.grey),
                                                                      textScaleFactor:
                                                                          1.0,
                                                                    ),
                                                                    Text(
                                                                      datesOfMeasures[0][0] ==
                                                                              " "
                                                                          ? " "
                                                                          : '${datesOfMeasures[5].split("-")[1]}/${datesOfMeasures[5].split("-")[2]}',
                                                                      style: TextStyle(
                                                                          fontSize: MediaQuery.of(context).size.width *
                                                                              16 /
                                                                              720,
                                                                          color:
                                                                              Colors.grey),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Column(
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      allTranslations
                                                                          .text(
                                                                              "friday"),
                                                                      style: TextStyle(
                                                                          fontSize: MediaQuery.of(context).size.width *
                                                                              21 /
                                                                              720,
                                                                          color:
                                                                              Colors.grey),
                                                                      textScaleFactor:
                                                                          1.0,
                                                                    ),
                                                                    Text(
                                                                      datesOfMeasures[0][0] ==
                                                                              " "
                                                                          ? " "
                                                                          : '${datesOfMeasures[6].split("-")[1]}/${datesOfMeasures[6].split("-")[2]}',
                                                                      style: TextStyle(
                                                                          fontSize: MediaQuery.of(context).size.width *
                                                                              16 /
                                                                              720,
                                                                          color:
                                                                              Colors.grey),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      child: Padding(
                                                        padding: EdgeInsets.only(
                                                            bottom: MediaQuery.of(
                                                                        context)
                                                                    .padding
                                                                    .bottom +
                                                                50,
                                                            top: MediaQuery.of(
                                                                        context)
                                                                    .padding
                                                                    .top +
                                                                60,
                                                            left: MediaQuery.of(
                                                                        context)
                                                                    .padding
                                                                    .left +
                                                                5),
                                                        child: Image.asset(
                                                          'assets/icons/ic_arrow_small_r.png',
                                                          scale: 2,
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        if (selectedDate
                                                            .isAfter(DateTime
                                                                .now())) {
                                                        } else {
                                                          incrementWeek();
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              )
                                      ],
                                    ),
                            )
                          ],
                        ),
                        height: MediaQuery.of(context).size.height * 0.83,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: InkWell(
                          highlightColor: Colors.white,
                          splashColor: Colors.white,
                          focusColor: Colors.white,
                          hoverColor: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.more_horiz,
                                color: Colors.grey,
                                size: 16,
                              ),
                              Text(allTranslations.text("measurementsDetails"),
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal)),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MeasurementDetails(
                                      selectedDate,
                                      sugerToday,
                                      calories,
                                      steps,
                                      distance,
                                      cupOfWater)),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }),
              onWillPop: () => exitt(),
            ));
  }

  Future<void> exitt() {
    exit(0);
  }

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

  List<Widget> charts() {
    List<Widget> list = new List();
    for (int i = 0; i <= 6; i++) {
      list.add(Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: inChart(i),
      ));
      if (i < 6) {
        list.add(
          Container(
            width: 1.2,
            height: MediaQuery.of(context).size.height * 0.17,
            color: Colors.grey,
          ),
        );
      }
    }
    return list;
  }

  List<Widget> inChart(int i) {
    List<Widget> list2 = new List();
    for (int j = 0; j < 3; j++) {
      int val = 0;
      val = measuresData[i][j];

      Color barColor;

      if (val <= 200 && val >= 70) {
        barColor = Colors.green[300];
      } else if (val > 200) {
        barColor = Color(0xFFd17356);
      } else {
        barColor = Colors.yellow[800];
      }

      list2.add(Column(
        children: <Widget>[
          Text(
            val == 0 ? "" : "${val}",
            style: TextStyle(
                color: barColor,
                fontSize: MediaQuery.of(context).size.width * 15 / 720),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: istrue ? 300 : 300),
            height: val <= 0
                ? 0.1
                : val.toDouble() > 300 ? 100 : (val.toDouble() / 600) * 200,
            width: MediaQuery.of(context).size.width * 16 / 720,
            decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                )),
          ),
        ],
      ));
    }
    return list2;
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
