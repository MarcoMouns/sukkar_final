import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:health/pages/Settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../languages/all_translations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fit_kit/fit_kit.dart';
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
        style: dependencies.textStyle.copyWith(color: Colors.blue));
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
          color: Colors.blue,
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
    const TextStyle(fontSize: 16.0, color: Colors.white);
    return new FloatingActionButton(
        child: new Text(text, style: roundTextStyle), onPressed: callback);
  }

  Widget buildButton(String text, VoidCallback callback) {
    TextStyle roundTextStyle =
    const TextStyle(fontSize: 16.0, color: Colors.white);
    return new FloatingActionButton(
        child: new Text(text, style: roundTextStyle), onPressed: callback);
  }

  GoogleMapController mapController;
  Set<Polyline> _polyline = {};
  Set<Marker> _markers = {};
  List<LatLng> latlngSegment = List();
  int _polylineIdCounter = 1;

  ///this x is for debugging
  int x = 0;
  double meter = 0;
  static lm.Distance distance = new lm.Distance();
  PolylineId selectedPolyline;
  Position firstPosition;
  Position currentPosition;
  bool _isLoading = true;
  bool checkRun = false;
  final List<LatLng> points = <LatLng>[];
  Response response;
  Dio dio = new Dio();
  bool ismaping = false;
  bool troll = false;
  int totalSteps = 0;

  void draw(){
    print('hiîàààààà1111111111111111111111111111111');
    setState(() {
      _polyline.add(Polyline(
        polylineId: PolylineId('line1'),
        visible: true,
        //latlng is List<LatLng>
        points: latlngSegment,
        width: 2,
        color: Colors.blue,
      ));
    });
  }

  var healthKitData;
  List<FitData> fitdata = new List<FitData>();

  Future<List<int>> healthKit() async {
    List<int> Steps = new List<int>();
    healthKitData = await FitKit.read(
      DataType.STEP_COUNT,
      DateTime.now().subtract(Duration(days: 5)),
      DateTime.now(),
    );

    if (healthKitData == null || healthKitData == 0) {
      return Steps;
    }
    else {
      for (int i = 0; i <= healthKitData.length; i++) {
        fitdata[i] = healthKitData[i];
        Steps[i] = fitdata[i].value;
      }
    }
    return Steps;
  }

  void getSteps() {
    int steps;
    calculateSteps().then((v) => steps = v);
    totalSteps = steps - totalSteps;
    setState(() {});
  }


  Future<int> calculateSteps() async {
    int steps = 0;
    List<int> StepsList = new List<int>();
    StepsList = await healthKit();
    if (StepsList.isEmpty) {
      return 0;
    }
    else {
      for (int i = 0; i <= StepsList.length; i++) {
        steps = StepsList[i] + steps;
      }
      return steps;
    }
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

    getSteps();


    setState(() {});

    print(
        'mine,mine,mine,mine,mine,mine,mine,mine,MIIIIIIIIIIIIIIIIIIIINE,mine,mine,mine,mine,');
    Timer.periodic(Duration(seconds: 30), (timer) {
      checkRun ? updatePostion() : print('Finished (Y)');
    });
    setState(() {});
  }

  initState() {
    Future<int> steps;
    super.initState();
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
    }).catchError((err) {
      setState(() {});
    });
    steps = calculateSteps();
    if (steps == 0) {
      totalSteps = 0;
      print('a7na hna men al zerooooooooooooooooo');
      _isLoading = false;
    }
    else {
      steps.then((v) => totalSteps = v);
      print('TOOTAAAAAAAAAl -------> $totalSteps');
    }

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

//  void _add() {
//    print('***************************************');
//    print('add');
//    x = x + 1;
//    print(x);
//    print('***************************************');
//
//    ///mathmatian scam as the human move 100 step per 1 min and 20 step
//    ///per 0.1 kilo and the function fires every 4 sec as an average so
//    ///3*4= 12 steps per 4 sec so in a min 15*12= 180 all of that is an
//    ///average and pridction
//    _polylineIdCounter = _polylineIdCounter + 3;
//    final int polylineCount = polylines.length;
//
//    if (polylineCount == 12) {
//      return;
//    }
//
//    final String polylineIdVal = 'polyline_id_$_polylineIdCounter';
//
//    final PolylineId polylineId = PolylineId(polylineIdVal);
//
//    final Polyline polyline = Polyline(
//      polylineId: polylineId,
//      consumeTapEvents: true,
//      color: Colors.orange,
//      width: 5,
//      points: _createPoints(),
//      onTap: () {
//        _onPolylineTapped(polylineId);
//      },
//    );
//
//    setState(() {
//      polylines[polylineId] = polyline;
//    });
//  }


//  List<LatLng> _createPoints() {
//    final double offset = _polylineIdCounter.ceilToDouble();
//    _polylineIdCounter = _polylineIdCounter + 3;
//    print('##############################################################');
//    print(_polylineIdCounter);
//    print('##############################################################');
////    points.add(_createLatLng(currentPosition.latitude,
////        currentPosition.longitude));
////    points.add(_createLatLng(31.266222, 29.993530));
//    return points;
//  }

//  LatLng _createLatLng(double lat, double lng) {
//    return LatLng(lat, lng);
//  }

//  void _onPolylineTapped(PolylineId polylineId) {
//    setState(() {
//      selectedPolyline = polylineId;
//    });
//  }

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
                    markers: _markers,
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

//                   Positioned(
//                     top: 1,
//                     right: 1,
//                     child: Column(
//                       children: <Widget>[
//                           Text("$mov",style: TextStyle(color: Colors.blue,fontSize: 40),),
//                       ],
//                     ),
//                   ),
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
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  new Positioned(
                    bottom: 50,
                    left: 0,
                    right: 0,
                    child: Container(
                      margin: EdgeInsets.all(30),
                      padding: EdgeInsets.all(30),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.redAccent),
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
                                      Border.all(color: Colors.redAccent),
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
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.white, width: 2),
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
                                style: TextStyle(color: Colors.grey),
                              )
                            ]),
                          ),
                          MapItem(
                              title: "steps",
                              value: "$totalSteps",
                              image: "ic_steps2",
                              isNotFloat: true),
                          MapItem(
                              title: "cals",
                              value: "${(totalSteps * 0.0512).ceil()}",
                              image: "ic_cal",
                              isLeft: false)
                        ],
                      ),
                    ),
                  ),

                  ///**************************************************

                  ///**************************************************
                  new Positioned(
                    bottom: 60,
                    left: 0,
                    right: 0,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                            textColor: Colors.white,
                            color: checkRun
                                ? Settings.mainColor()
                                : Colors.red,
                            child: Container(
                                padding: EdgeInsets.all(15),
                                child: checkRun == false
                                    ? Text(allTranslations.text("startNow"))
                                    : Text(allTranslations.text("endNow"))),
                            onPressed: () async {
                              rightButtonPressed();
                              checkRun = !checkRun;
                              setState(() {});
                              if (checkRun == true) {
                                updatePostion();
                              } else if (checkRun == false) {
                                if (_polyline.isNotEmpty) {
                                  draw();
                                }
                                setState(() {
                                  ismaping = false;
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
                                  formdata.add("distance", 10);
                                  formdata.add("steps", totalSteps);
                                  formdata.add("calories", 10);
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
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)))
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
                border: Border.all(color: Colors.redAccent),
                borderRadius: BorderRadius.circular(30)),
            child: Center(
              child: Text("$value", style: TextStyle(color: Colors.blueAccent)),
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
                  color: Colors.white,
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(12.5)),
              child:
              Image.asset("assets/icons/$image.png", width: 20, height: 20),
            ),
          )
        ]),
        Text(
          allTranslations.text(title),
          style: TextStyle(color: Colors.grey),
        )
      ]),
    );
  }
}
