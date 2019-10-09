import 'package:flutter/material.dart';
import 'package:health/pages/home/MainCircle/mainCircle.dart';

class ProfileChart extends StatefulWidget {
  int userId;
  ProfileChart ( int id){
  userId = id;
  }

   

  @override
  ProfileChartState createState() => ProfileChartState();
}

class ProfileChartState extends State<ProfileChart> {
    
   initState(){

     
   }
   
   String iconName;
   String cirTitle;
   String cirFooter;
   double cirPercent;
   double cirSize;
   Color  cirColor;



  @override
  Widget build(BuildContext context) {

    double raduis = MediaQuery.of(context).size.width / cirSize <
        MediaQuery.of(context).size.height - (120 + 23 + 14 + 10)
        ? MediaQuery.of(context).size.width / cirSize
        : MediaQuery.of(context).size.height - (120 + 23 + 14 + 10);
    

    Widget cir(){
      return ChartWidget(
        isOnSide: false,
        isUpper: true,
        radius: raduis,
        title: cirTitle == null ? 0 :cirTitle,
        image: iconName,
        footer: Text(cirFooter),
        time: "",
        percent: cirPercent == null ? 0 :cirPercent ,
        color: cirColor,
      );
    }

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 199,
          height: 199,
          child: cir(),
        ),
    ),
    );
  }
  }
