import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../Settings.dart';
import '../../languages/all_translations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapPage extends StatefulWidget {
  _MapPageState createState() => _MapPageState();
  final PageController pageController;
  MapPage({this.pageController});
}

class _MapPageState extends State<MapPage> {
  GoogleMapController mapController;
  Position currentPosition;
  bool _isLoading = false;

  initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    _getCurrentUserPosition().then((position) {
      print(
          "current user position ---------------------------------------> $position");
      setState(() {
        currentPosition = position;
        _isLoading = false;
      });
    }).catchError((err) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  Future<Position> _getCurrentUserPosition() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(
        "current user position ---------------------------------------> $position");
    return position;
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
              : Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    GoogleMap(
                      // onTap: (LatLng position) {
                      //   setState(() {
                      //     destinationPosition = position;
                      //   });
                      //   _addPolyline();
                      //   print(position);
                      // },
                      initialCameraPosition: CameraPosition(
                          target: LatLng(currentPosition.latitude,
                              currentPosition.longitude),
                          zoom: 15),
                      onMapCreated: _onMapCreated,
                      // polylines: Set.from(userPlylines),
                      // markers: markers[_markerIdCounter].flat,
                      // markers: Set.from(userMarkers),
                      myLocationEnabled: true,
                      // tiltGesturesEnabled: true,
                      // gestureRecognizers: ,
                      gestureRecognizers: Set()
                        ..add(Factory<PanGestureRecognizer>(
                            () => PanGestureRecognizer()))
                        ..add(Factory<ScaleGestureRecognizer>(
                            () => ScaleGestureRecognizer()))
                        ..add(Factory<TapGestureRecognizer>(
                            () => TapGestureRecognizer()))
                        ..add(Factory<VerticalDragGestureRecognizer>(
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
                      mapType: MapType.hybrid,
                      compassEnabled: true,
                    ),
                    // Container(
                    //   width: double.infinity,
                    //   height: double.infinity,
                    //   child:Image.asset("assets/imgs/fakeMap.jpeg",fit: BoxFit.cover,),
                    // ),
                    Positioned(
                      top: 50,
                      left: allTranslations.currentLanguage == "ar" ? 20 : null,
                      right:
                          allTranslations.currentLanguage == "ar" ? null : 20,
                      child: InkWell(
                        onTap: () {
                          widget.pageController.animateToPage(1,
                              duration: Duration(milliseconds: 10),
                              curve: Curves.bounceIn);
                        },
                        child: Container(
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
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
                            MapItem(
                                title: "time",
                                value: "24min",
                                image: "ic_time",
                                isLeft: true),
                            MapItem(
                                title: "steps",
                                value: "345",
                                image: "ic_steps2",
                                isNotFloat: true),
                            MapItem(
                                title: "cals",
                                value: "528cal",
                                image: "ic_cal",
                                isLeft: false)
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 60,
                      left: 0,
                      right: 0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                              textColor: Colors.white,
                              color: Settings.mainColor(),
                              child: Container(
                                  padding: EdgeInsets.all(15),
                                  child:
                                      Text(allTranslations.text("startNow"))),
                              onPressed: () {},
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)))
                        ],
                      ),
                    )
                  ],
                ),
        ));
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
