import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fit_kit/fit_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:health/pages/Settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vector_math/vector_math.dart';
import 'dart:math';
import '../../languages/all_translations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'package:latlong/latlong.dart' as lm;


import '../home.dart';

///********************from here this is the stopwatch********************
///note: i was too lazy to make this in another class and use it here #panda
///

class ElapsedTime {
  final int hundreds;
  final int seconds;
  final int minutes;

  ElapsedTime({
    this.hundreds,
    this.seconds,
    this.minutes,
  });
}

class Dependencies {
  final List<ValueChanged<ElapsedTime>> timerListeners =
  <ValueChanged<ElapsedTime>>[];
  final TextStyle textStyle =
  const TextStyle(fontSize: 90.0, fontFamily: "Bebas Neue");
  final Stopwatch stopwatch = new Stopwatch();
  final int timerMillisecondsRefreshRate = 30;
}

class TimerText extends StatefulWidget {
  TimerText({this.dependencies});
  final Dependencies dependencies;

  TimerTextState createState() =>
      new TimerTextState(dependencies: dependencies);
}

class TimerTextState extends State<TimerText> {
  TimerTextState({this.dependencies});
  final Dependencies dependencies;
  Timer timer;
  int milliseconds;
  double updatelat;
  double updatelong;

  @override
  void initState() {
    timer = new Timer.periodic(
        new Duration(milliseconds: dependencies.timerMillisecondsRefreshRate),
        callback);
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  void callback(Timer timer) {
    if (milliseconds != dependencies.stopwatch.elapsedMilliseconds) {
      milliseconds = dependencies.stopwatch.elapsedMilliseconds;
      final int hundreds = (milliseconds / 10).truncate();
      final int seconds = (hundreds / 100).truncate();
      final int minutes = (seconds / 60).truncate();
      final ElapsedTime elapsedTime = new ElapsedTime(
        hundreds: hundreds,
        seconds: seconds,
        minutes: minutes,
      );
      for (final listener in dependencies.timerListeners) {
        listener(elapsedTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RepaintBoundary(
          child: MinutesAndSeconds(dependencies: dependencies),
        ),
        RepaintBoundary(
          child: Hundreds(dependencies: dependencies),
        ),
      ],
    );
  }
}

class MinutesAndSeconds extends StatefulWidget {
  MinutesAndSeconds({this.dependencies});
  final Dependencies dependencies;

  MinutesAndSecondsState createState() =>
      new MinutesAndSecondsState(dependencies: dependencies);
}

class MinutesAndSecondsState extends State<MinutesAndSeconds> {
  MinutesAndSecondsState({this.dependencies});
  final Dependencies dependencies;

  int minutes = 0;
  int seconds = 0;

  @override
  void initState() {
    dependencies.timerListeners.add(onTick);
    super.initState();
  }

  void onTick(ElapsedTime elapsed) {
    if (elapsed.minutes != minutes || elapsed.seconds != seconds) {
      setState(() {
        minutes = elapsed.minutes;
        seconds = elapsed.seconds;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    return new Text('$minutesStr:$secondsStr',
        style: dependencies.textStyle.copyWith(color: Color(0xFF45b6fe)));
  }
}

class Hundreds extends StatefulWidget {
  Hundreds({this.dependencies});
  final Dependencies dependencies;

  HundredsState createState() => new HundredsState(dependencies: dependencies);
}

class HundredsState extends State<Hundreds> {
  HundredsState({this.dependencies});
  final Dependencies dependencies;

  int hundreds = 0;

  @override
  void initState() {
    dependencies.timerListeners.add(onTick);
    super.initState();
  }

  void onTick(ElapsedTime elapsed) {
    if (elapsed.hundreds != hundreds) {
      setState(() {
        hundreds = elapsed.hundreds;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String hundredsStr = (hundreds % 100).toString().padLeft(2, '0');
    return new Text('',
        style: dependencies.textStyle.copyWith(
          color: Color(0xFF45b6fe),
        ));
  }
}

///*******************************END of stopwatch********************
///********************END of stopwatch*******************************
///
///
class MapPage extends StatefulWidget {
  _MapPageState createState() => _MapPageState();

}

class _MapPageState extends State<MapPage> {
  ///********************from here this is the stopwatch********************
  ///note: i was too lazy to make this in another class and use it here #panda

  final Dependencies dependencies = new Dependencies();

  void leftButtonPressed() {
    setState(() {
      if (dependencies.stopwatch.isRunning) {
        print("${dependencies.stopwatch.elapsedMilliseconds}");
      } else {
        dependencies.stopwatch.reset();
      }
    });
  }

  void rightButtonPressed() {
    setState(() {
      if (dependencies.stopwatch.isRunning) {
        dependencies.stopwatch.stop();
      } else {
        dependencies.stopwatch.start();
      }
    });
  }

  Widget buildFloatingButton(String text, VoidCallback callback) {
    TextStyle roundTextStyle =
    const TextStyle(fontSize: 16.0, color: Color(0xFFffffff));
    return new FloatingActionButton(
        child: new Text(text, style: roundTextStyle), onPressed: callback);
  }

  Widget buildButton(String text, VoidCallback callback) {
    TextStyle roundTextStyle =
    const TextStyle(fontSize: 16.0, color: Color(0xFFffffff));
    return new FloatingActionButton(
        child: new Text(text, style: roundTextStyle), onPressed: callback);
  }

  GoogleMapController mapController;
  Set<Polyline> _polyline = {};
  List<LatLng> latlngSegment = List();

  Position firstPosition;
  Position currentPosition;
  bool _isLoading = true;
  bool checkRun = false;
  Response response;
  Dio dio = new Dio();


  bool flag = true;
  int steps = 0;
  double distance = 0;

  void draw(){
    print('hiîàààààà1111111111111111111111111111111');
    setState(() {
      _polyline.add(Polyline(
        polylineId: PolylineId('line1'),
        visible: true,
        //latlng is List<LatLng>
        points: latlngSegment,
        width: 5,
        color: Color(0xFF45b6fe),
      ));
    });
  }

//  double getDistance({double long1, double long2, double lat1, double lat2}) {
//    long1 = -long1 * degrees2Radians;
//    long2 = -long2 * degrees2Radians;
//
//    lat1 = lat1 * degrees2Radians;
//    lat2 = lat2 * degrees2Radians;
//
//    double Mlat = (lat1 - lat2) * degrees2Radians;
//    double Mlong = (long1 - long2) * degrees2Radians;
//
//    double earthRadius = 6371e3;
//
//    var a = (sin(Mlat / 2) * sin(Mlat / 2)) +
//        (cos(lat1) * cos(lat2)) * sin(Mlong / 2) * sin(Mlong / 2);
//    var c = atan2(sqrt(a), sqrt(1 - a));
//
//    var distance = earthRadius * c;
//
//    return distance;
//  }


  List healthKitStepsData;
  List fitdata = new List();

  void healthKit() async {
    List<int> Steps = new List<int>();
    healthKitStepsData = await FitKit.read(
      DataType.STEP_COUNT,
      DateTime.now().subtract(Duration(minutes: 1)),
      DateTime.now(),
    );

    if (healthKitStepsData.isEmpty) {
      steps = 0;
    }
    else {
      for (int i = 0; i <= healthKitStepsData.length - 1; i++) {
        fitdata.add(healthKitStepsData[i]);
        Steps.add(fitdata[i].value.round());
      }
      for (int i = 0; i <= Steps.length - 1; i++) {
        print('huh eh tani -_- ->>>>> $steps');
        steps = Steps[i] + steps;
      }
    }
    setState(() {});
  }


  void updatePostion() async {

    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    //print(
      //  "current user position ---------------------------------------> $position  FROM UPDATE");
    setState(() {
      currentPosition = position;
      latlngSegment.add(
          LatLng(currentPosition.latitude, currentPosition.longitude));
      print(LatLng(currentPosition.latitude, currentPosition.longitude));
    });

    //int geoListLength = latlngSegment.length;


//    if (geoListLength <= 1) {
//      print(
//          'LAT1 ---------------------------> ${latlngSegment.first.latitude}');
//      print('LAT2 ---------------------------> ${latlngSegment.last.latitude}');
//      print('Long1 ---------------------------> ${latlngSegment.first
//          .longitude}');
//      print(
//          'Long2 ---------------------------> ${latlngSegment.last.longitude}');
//
//      distance = getDistance(
//        lat1: latlngSegment.first.latitude,
//        lat2: latlngSegment.last.latitude,
//        long1: latlngSegment.first.longitude,
//        long2: latlngSegment.last.longitude,
//      );
//      steps = (((distance * 100) * 0.65) + steps).toInt();
//    }
//    else {
//      print('LAT1 ---------------------------> ${latlngSegment
//          .elementAt(geoListLength - 2)
//          .latitude}');
//      print('LAT2 ---------------------------> ${latlngSegment.last.latitude}');
//      print('Long1 ---------------------------> ${latlngSegment
//          .elementAt(geoListLength - 2)
//          .longitude}');
//      print(
//          'Long2 ---------------------------> ${latlngSegment.last.longitude}');
//
//      distance = getDistance(
//        lat1: latlngSegment
//            .elementAt(geoListLength - 2)
//            .latitude,
//        lat2: latlngSegment.last.latitude,
//        long1: latlngSegment
//            .elementAt(geoListLength - 2)
//            .longitude,
//        long2: latlngSegment.last.longitude,
//      ) + distance;
//
//      if (latlngSegment
//          .elementAt(geoListLength - 2)
//          .longitude == latlngSegment.last.longitude) {
//        print('DISTANCE ---------------------------------> ${distance * 100}');
//        print('Before steps ---------------------------------> $steps');
//        steps = steps;
//        print('Before steps ---------------------------------> $steps');
//      }
//      else {
//        print('DISTANCE ---------------------------------> ${distance * 100}');
//        print('Before steps ---------------------------------> $steps');
//        steps = (((distance * 100) * 0.65) + steps).toInt();
//        print('After steps ---------------------------------> $steps');
//      }
//    }
    draw();
    setState(() {});

    print(
        'mine,mine,mine,mine,mine,mine,mine,mine,MIIIIIIIIIIIIIIIIIIIINE,mine,mine,mine,mine,');
    Timer.periodic(Duration(seconds: 10), (timer) {
      checkRun ? updatePostion() : null;
    });
    setState(() {});
  }

  Timer time;

  initState() {
    super.initState();
    time = Timer.periodic(Duration(minutes: 1), (Timer t) => healthKit());
    currentPosition = Position(latitude: 0, longitude: 0);
    _getCurrentUserPosition().then((position) {
      print(
          "current user position ---------------------------------------> $position");
      setState(() {
        print('myAss is true');
        firstPosition = position;
        currentPosition = position;
        print('myAss is ffalse');
      });
      _isLoading = false;
    }).catchError((err) {
      setState(() {});
    });
  }

  Future<Position> _getCurrentUserPosition() async {
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
      print(
          "current user position ---------------------------------------> $position");
      return position;
    } catch (e) {
      print('GEOOOOOOOOOO ->>>>>>>>>> $e');
    }
  }


  @override
  void dispose() {
    super.dispose();
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: allTranslations.currentLanguage == "ar"
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Scaffold(
              body: _isLoading
                  ? Center(
                child: CupertinoActivityIndicator(
                  animating: true,
                  radius: 15,
                ),
              )
                  : new Stack(
                fit: StackFit.expand,
                children: <Widget>[

                  new GoogleMap(
                    // onTap: (LatLng position) {
                    //   setState(() {
                    //     destinationPosition = position;
                    //   });
                    //   _addPolyline();
                    //   print(position);
                    // },
                    initialCameraPosition: CameraPosition(
                        target: LatLng(firstPosition.latitude,
                            firstPosition.longitude),
                        zoom: 15),
                    onMapCreated: _onMapCreated,
                    polylines: _polyline,


                    // polylines: Set.from(userPlylines),
                    // markers: markers[_markerIdCounter].flat,
                    // markers: Set.from(userMarkers),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    mapType: MapType.normal,
                    // tiltGesturesEnabled: true,
                    // gestureRecognizers: ,
                    gestureRecognizers: Set()
                      ..add(Factory<PanGestureRecognizer>(
                              () => PanGestureRecognizer()))..add(
                          Factory<ScaleGestureRecognizer>(
                                  () => ScaleGestureRecognizer()))..add(
                          Factory<TapGestureRecognizer>(
                                  () => TapGestureRecognizer()))..add(
                          Factory<VerticalDragGestureRecognizer>(
                                  () => VerticalDragGestureRecognizer())),
                    // gestureRecognizers: Set()
                    //   ..add(
                    //     Factory<PanGestureRecognizer>(
                    //       () => PanGestureRecognizer(),
                    //     ),
                    //   )
                    //   ..add(
                    //     Factory<VerticalDragGestureRecognizer>(
                    //       () => VerticalDragGestureRecognizer(),
                    //     ),
                    //   ),
                    compassEnabled: true,
                  ),
                  // Container(
                  //   width: double.infinity,
                  //   height: double.infinity,
                  //   child:Image.asset("assets/imgs/fakeMap.jpeg",fit: BoxFit.cover,),
                  // ),

                  Positioned(
                    top: 1,
                    right: 1,
                    child: Column(
                      children: <Widget>[
                        Text("$fitdata", style: TextStyle(
                            color: Color(0xFF0000ff), fontSize: 40),),
                      ],
                    ),
                  ),
                  new Positioned(
                    top: 50,
                    left: allTranslations.currentLanguage == "ar" ? 20 : null,
                    right:
                    allTranslations.currentLanguage == "ar" ? null : 20,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => MainHome()));
                      },
                      child: Container(
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xFF808080),
                        ),
                      ),
                    ),
                  ),
                  new Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.7,
                      margin: EdgeInsets.only(right: 30, left: 30, bottom: 60),
                      decoration: BoxDecoration(
                          color: Color(0xFFffffff),
                          border: Border.all(color: Color(0xFFe13026)),
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Column(children: [
                              Stack(children: [
                                Container(
                                  margin: EdgeInsets.all(10),
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      border:
                                      Border.all(color: Color(0xFFe13026)),
                                      borderRadius:
                                      BorderRadius.circular(30)),
                                  child: Center(
                                    child: SizedBox(
                                      width:
                                      MediaQuery
                                          .of(context)
                                          .size
                                          .width *
                                          0.1,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Directionality(
                                          textDirection: TextDirection.ltr,
                                          child: TimerText(
                                              dependencies: dependencies),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 5,
                                  left: 25,
                                  child: Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                        color: Color(0xFFffffff),
                                        border: Border.all(
                                            color: Color(0xFFffffff), width: 2),
                                        borderRadius:
                                        BorderRadius.circular(12.5)),
                                    child: Image.asset(
                                        "assets/icons/ic_time.png",
                                        width: 20,
                                        height: 20),
                                  ),
                                )
                              ]),
                              Text(
                                allTranslations.text("time"),
                                style: TextStyle(color: Color(0xFF808080)),
                              )
                            ]),
                          ),
                          MapItem(
                              title: "steps",
                              value: "$steps",
                              image: "ic_steps2",
                              isNotFloat: true),
                          MapItem(
                              title: "cals",
                              value: "${(steps * 0.0512).ceil()}",
                              image: "ic_cal",
                              isLeft: false)
                        ],
                      ),
                    ),
                  ),

                  ///**************************************************

                  ///**************************************************
                  new Positioned(
                    bottom: 15,
                    left: 0,
                    right: 0,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: checkRun
                                  ? Color(0xFFe13026)
                                  : Settings.mainColor(),
                            ),
                            padding: EdgeInsets.only(
                                top: 12, bottom: 12, right: 23, left: 23),
                            child: checkRun == false
                                ? Text(allTranslations.text("startNow"),
                              style: TextStyle(color: Color(0xFFffffff),
                                  fontSize: 14),)
                                : Text(allTranslations.text("endNow"),
                                style: TextStyle(color: Color(0xFFffffff),
                                    fontSize: 14)),
                          ),
                          onTap: () async {
                            rightButtonPressed();
                            checkRun = !checkRun;
                            setState(() {});
                            if (checkRun == true) {
                              updatePostion();
                            } else if (checkRun == false) {
                              if (_polyline.isNotEmpty) {
                                //draw();
                              }
                              setState(() {
                                checkRun = false;
                              });
                              try {
                                FormData formdata = new FormData();
                                // get user token
                                SharedPreferences sharedPreferences =
                                await SharedPreferences.getInstance();
                                Map<String, dynamic> authUser = jsonDecode(
                                    sharedPreferences
                                        .getString("authUser"));
                                dio.options.headers = {
                                  "Authorization":
                                  "Bearer ${authUser['authToken']}",
                                };
                                formdata.add("startLongitude",
                                    0.0);
                                formdata.add(
                                    "endLongitude", 0.0);
                                formdata.add(
                                    "startLatitude", 0.0);
                                formdata.add(
                                    "endLatitude", 0.0);
                                formdata.add("date", DateTime.now());
                                print(
                                    '******************************************************');
                                print(DateTime.now());
                                print(
                                    '******************************************************');
                                print(
                                    "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
                                formdata.add("distance",
                                    (0).toInt());
                                formdata.add("steps", 0);
                                formdata.add("calories",
                                    ((steps * 0.0512).ceil()).toInt());
                                print(
                                    '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
                                print(formdata);
                                print(
                                    '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
                                response = await dio.post(
                                    "http://api.sukar.co/api/mapInformation",
                                    data: formdata);
                                if (response.statusCode != 200 &&
                                    response.statusCode != 201) {
                                  return false;
                                } else {
                                  print('success -->');
                                  print('Response = ${response.data}');
                                  return true;
                                }
                              } on DioError catch (e) {
                                print(
                                    "errrrrrrrrrrrrrrrrrrroooooooorrrrrrrrr");
                                print(e.response.data);
                                return false;
                              }
                            }
                            return true;
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
//        new Center(
//          child: Column(
//            crossAxisAlignment: CrossAxisAlignment.center,
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              Container(
//                padding: EdgeInsets.all(20),
//                margin: EdgeInsets.only(bottom: 20),
//                decoration: BoxDecoration(
//                  borderRadius: BorderRadius.all(Radius.circular(100)),
//                  color: Colors.redAccent
//                ),
//                child: Icon(
//                  Icons.developer_mode,
//                  size: 60,
//                  color: Colors.white,
//                ),
//              ),
//              Text('Under Development',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),)
//            ],
//          ),
//        )
    );
  }
}

class MapItem extends StatelessWidget {
  final String title;
  final String value;
  final String image;
  final bool isLeft;
  final bool isNotFloat;

  MapItem(
      {Key key,
        this.title,
        this.value,
        this.image,
        this.isLeft = false,
        this.isNotFloat = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(children: [
        Stack(children: [
          Container(
            margin: EdgeInsets.all(10),
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFe13026)),
                borderRadius: BorderRadius.circular(30)),
            child: Center(
              child: Text("$value", style: TextStyle(color: Color(0xFF00a2ed))),
            ),
          ),
          Positioned(
            top: isNotFloat ? 0 : 5,
            left: isLeft && !isNotFloat ? 10 : (isNotFloat ? 25 : null),
            right: !isLeft && !isNotFloat ? 10 : (isNotFloat ? 25 : null),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                  color: Color(0xFFffffff),
                  border: Border.all(color: Color(0xFFffffff), width: 2),
                  borderRadius: BorderRadius.circular(12.5)),
              child:
              Image.asset("assets/icons/$image.png", width: 20, height: 20),
            ),
          )
        ]),
        Text(
          allTranslations.text(title),
          style: TextStyle(color: Color(0xFF808080)),
        )
      ]),
    );
  }
}
