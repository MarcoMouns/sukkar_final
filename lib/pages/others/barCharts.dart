import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:health/pages/Social/friends.dart';
import 'package:health/pages/Social/profileMeasuresDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BarCharts extends StatefulWidget {
  final double height;

  BarCharts({this.height});

  @override
  _BarChartsState createState() => _BarChartsState();
}

class _BarChartsState extends State<BarCharts>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;
  Response response;
  Dio dio = new Dio();
  var dataCharts;
  bool loading;
  int num;
  FormData formdata = new FormData();

  @override
  void initState() {
    super.initState();
    getCharts();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation =
        Tween(begin: 0, end: widget.height).animate(_animationController);
    _animation.addListener(() {
      setState(() {});
    });
    _animationController.forward();
  }

  getCharts() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      Map<String, dynamic> authUser =
          jsonDecode(sharedPreferences.getString("authUser"));
      dio.options.headers = {
        "Authorization": "Bearer ${authUser['authToken']}",
      };
      formdata = FormData.fromMap({
        "date": DateTime.now(),
      });
      response = await dio.post("http://api.sukar.co/api/SugarReads",
          data: formdata);
      dataCharts = response.data;
      num = dataCharts.length;
      print("$dataCharts");
      setState(() {
        loading = false;
      });
      if (response.statusCode != 200 && response.statusCode != 201) {
      }
    } on DioError catch (e) {
      return false;
    }
  }

  Widget _virticalDivider(context) {
    return Container(
      width: 1,
      height: widget.height,
      color: Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.end,
      children:  listMyWidgets(),
    );
  }

  List<Widget> listMyWidgets() {
    List<Widget> list = new List();
    for( var i = 0 ; i <= num; i++ ) {
      list.add(new Expanded(
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfileMeasurementDetails( id
                      
                    )));
          },
          child: _dayCharts(100, context, [
            Color.fromRGBO(224, 112, 82, 1),
          ]),
        ),
      ));
      list.add(_virticalDivider(context));
    }
    return list;
  }

  Widget _barChart(BuildContext context, Color color, double height) {
    return Column(
      children: <Widget>[
        FittedBox(
          child: SizedBox(
              child: Text(
            (120 * _animationController.value).toInt().toString(),
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 5 * 3 / 720,
                color: color),
          )),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 40,
          height: height,
          decoration: ShapeDecoration(
              color: color,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)))),
        ),
      ],
    );
  }

  Widget _dayCharts(
      double acturalHeight, BuildContext context, List<Color> colors) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _barChart(context, colors[0], acturalHeight),

        ]);
  }
}

