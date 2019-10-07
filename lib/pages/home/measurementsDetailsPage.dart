import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:health/languages/all_translations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../measurementsPageCircles.dart';


class MeasurementDetails extends StatefulWidget {
  static DateTime date;
  FormData formData =  new FormData();
  MeasurementDetails([DateTime d]) {
    date = d;
  }

  @override
  _MeasurementDetailsState createState() => _MeasurementDetailsState();
}

class _MeasurementDetailsState extends State<MeasurementDetails> {
  DateTime date = MeasurementDetails.date;
  String dateString="2019-10-6";

  int sugerToday=100;
  int calories=1300;
  int steps=700;
  int distance=3000;
  int ncal=1;
  int cupOfWater= 10;
  int heartRate = 50;
  int bloodPresure=100;
  

  int goalCalories=1300;
  int goalSteps=700;
  int goalDistance=3000;
  int goalNcal=1;
  int goalCupOfWater= 10;
 






                               

  Color greenColor = Color.fromRGBO(229, 246, 211, 1);
  Color redColor= Color.fromRGBO(253, 238, 238, 1);
  Color yellowColor= Color.fromRGBO(254, 252, 232, 1);
  
    void getcal() async {
    print("waaw===========");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("waaw===========");

    ncal = prefs.getInt('calTarget');
    if (ncal == null || ncal == 0) {
      ncal = 1200;
    }
    print('YOYOYOYOYOYOYOYOYOYOYOYOYOYOYOYOYOYOYO');
    print(ncal);
    print('YOYOYOYOYOYOYOYOYOYOYOYOYOYOYOYOYOYOYO');
  }
  _MeasurementDetailsState();

  initState() {
    super.initState();
 
  }

 
 

  

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      
      appBar: AppBar(
        title: Text(allTranslations.text("reportsPage")),
      ),
      body: ListView(
       
     
        children: [
          SizedBox(
            height: 40,
          ),
          FittedBox(
            child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
             SizedBox(
               width: 120,
               height: 130,
               child: measurementsCircles(
                 "ic_cup",
                 cupOfWater.toString(),

                 allTranslations.text("cups"),

                 (cupOfWater/goalCupOfWater).toDouble(),

                 2 ,

                 (cupOfWater/goalCupOfWater) < 0.3 ? redColor 
                    : (cupOfWater/goalCupOfWater) > 0.3 && (cupOfWater/goalCupOfWater) < 0.6 ? yellowColor:
                       greenColor
               ),
             ),
              SizedBox(
               width: 120,
               height: 150,
               child: measurementsCircles(
                 "ic_blood_pressure",
                 bloodPresure.toString(),
                 allTranslations.text("bloodPressure"),
                 0.9,
                 2,
                 redColor
               ),
             )
             ,
              SizedBox(
               width: 120,
               height: 130,
               child: measurementsCircles(
                 "ic_heart_rate",
                 heartRate.toString(),
                 allTranslations.text("heartRate"),
                 0.9,
                 2,
                 redColor
               ),
             )
             ,
              
             
            ],
          ),
          ),

          FittedBox(
            
            fit: BoxFit.scaleDown,
            child:  Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 160,
                child: SizedBox(
               width: 150,
               height: 160,
               child: measurementsCircles("ic_logo_3",
                 sugerToday.toString(),
                 allTranslations.text("sugarDetails"),
                 sugerToday/600.0,
                 1.5,
                 sugerToday < 80? yellowColor :
                    sugerToday >= 80 && sugerToday <= 200 ? greenColor
                        : redColor
                 ),
             ),
              )
            ],
          ),
          ),
         
           FittedBox(
             
             child:   Row(
            mainAxisAlignment: MainAxisAlignment.center,
               
            children: <Widget>[
             SizedBox(
               width: 120,
               height: 130,
               child: measurementsCircles("ic_cal",
                 calories.toString(),
                 allTranslations.text("cals"),
                 calories/goalCalories,
                 2,
                 (calories/goalCalories) < 0.3 ? redColor 
                    : (calories/goalCalories) > 0.3 && (calories/goalCalories) < 0.6 ? yellowColor:
                       greenColor
                 ),
             ),
              SizedBox(
               width: 120,
               height: 120,
               child: measurementsCircles("ic_steps",
                 steps.toString(),
                 allTranslations.text("steps"),
                 steps/goalSteps,
                 2,
                 (steps/goalSteps) < 0.3 ? redColor 
                    : (steps/goalSteps) > 0.3 && ( steps/goalSteps) < 0.6 ? yellowColor:
                       greenColor),
             )
             ,
              SizedBox(
               width: 120,
               height: 150,
               child: measurementsCircles("ic_location",
                 distance.toString(),
                 allTranslations.text("distance"),
                 distance/goalDistance,
                 2,
                 (distance/goalDistance) < 0.3 ? redColor 
                    : (distance/goalDistance) > 0.3 && (distance/goalDistance) < 0.6 ? yellowColor:
                       greenColor),
                 ),
              
             
            ],
          ),
           )
        ],
      ), 
        
      
    );
       
 
    
  
}


}
