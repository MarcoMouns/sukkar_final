import 'package:flutter/material.dart';
import 'package:health/pages/Social/ProfieChart.dart';

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

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation =
        Tween(begin: 0, end: widget.height).animate(_animationController);
    _animation.addListener(() {
      setState(() {});
    });
    _animationController.forward();
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
      children: <Widget>[
        Expanded(
                  child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileChart(
                            isMyProfile: true,
                            date: "1/1 Sunday",
                          )));
            },
            child: _dayCharts(widget.height, context, [
              Color.fromRGBO(224, 112, 82, 1),
              Color.fromRGBO(144, 199, 104, 1),
              Color.fromRGBO(245, 176, 98, 1)
            ]),
          ),
        ),
        _virticalDivider(context),
        Expanded(
                  child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileChart(
                            isMyProfile: true,
                            date: "1/1 Sunday",
                          )));
            },
            child: _dayCharts(widget.height, context, [
              Color.fromRGBO(224, 112, 82, 1),
              Color.fromRGBO(144, 199, 104, 1),
              Color.fromRGBO(245, 176, 98, 1)
            ]),
          ),
        ),
        _virticalDivider(context),
        Expanded(
                  child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileChart(
                            isMyProfile: true,
                            date: "1/1 Sunday",
                          )));
            },
            child: _dayCharts(widget.height, context, [
              Color.fromRGBO(224, 112, 82, 1),
              Color.fromRGBO(144, 199, 104, 1),
              Color.fromRGBO(245, 176, 98, 1)
            ]),
          ),
        ),
        _virticalDivider(context),
        Expanded(
                  child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileChart(
                            isMyProfile: true,
                            date: "1/1 Sunday",
                          )));
            },
            child: _dayCharts(widget.height, context, [
              Color.fromRGBO(224, 112, 82, 1),
              Color.fromRGBO(144, 199, 104, 1),
              Color.fromRGBO(245, 176, 98, 1)
            ]),
          ),
        ),
        _virticalDivider(context),
        Expanded(
                  child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileChart(
                            isMyProfile: true,
                            date: "1/1 Sunday",
                          )));
            },
            child: _dayCharts(widget.height, context, [
              Color.fromRGBO(224, 112, 82, 1),
              Color.fromRGBO(144, 199, 104, 1),
              Color.fromRGBO(245, 176, 98, 1)
            ]),
          ),
        ),
        _virticalDivider(context),
        Expanded(
                  child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileChart(
                            isMyProfile: true,
                            date: "1/1 Sunday",
                          )));
            },
            child: _dayCharts(widget.height, context, [
              Color.fromRGBO(224, 112, 82, 1),
              Color.fromRGBO(144, 199, 104, 1),
              Color.fromRGBO(245, 176, 98, 1)
            ]),
          ),
        ),
        _virticalDivider(context),
        Expanded(
                  child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileChart(
                            isMyProfile: true,
                            date: "1/1 Sunday",
                          )));
            },
            child: _dayCharts(widget.height, context, [
              Color.fromRGBO(224, 112, 82, 1),
              Color.fromRGBO(144, 199, 104, 1),
              Color.fromRGBO(245, 176, 98, 1)
            ]),
          ),
        ),
      ],
    );
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
          width: MediaQuery.of(context).size.width/40,
          height: _animation.value * 1.0,
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
    return 
     Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _barChart(context, colors[0], 1),
          _barChart(context, colors[1], 2),
          _barChart(context, colors[2], 3),
        ]);
  }
}

// class BetterCharts extends CustomPainter {
//   Color color;
//   BetterCharts({this.color});
//   @override
//   void paint(Canvas canvas, Size size) {
//     //   Rect r=c.fromCircle(radius: 50,center: Offset(0, 0));
//     Paint paint = Paint();
//     paint.style = PaintingStyle.fill;
//     paint.color = color;
//     //paint.strokeCap = StrokeCap.round;

//     paint.strokeWidth = size.width;
// //canvas.draw
//     canvas.drawLine(Offset(size.width / 2, size.height ),
//         Offset(size.width / 2,size.height> size.width/2?size.width/2:0), paint);
//         canvas.drawCircle(Offset(size.width / 2, size.width / 2,),size.height>size.width?size.width/2:0, paint);
//     //  canvas.drawLine(
//     //      Offset(size.width / 2, size.height - size.width / 2),
//     //      Offset(size.width / 2, size.height - size.width / 2),
//     //      paint..strokeCap = StrokeCap.round);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }
