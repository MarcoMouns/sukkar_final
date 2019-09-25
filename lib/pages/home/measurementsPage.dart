// import 'dart:convert';

// import 'package:dio/dio.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:health/scoped_models/main.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class MeasurementsPage extends StatefulWidget {
  
//   final MainModel model;

//   MeasurementsPage({this.model});

//   @override
//   State<StatefulWidget> createState() {
//     return _MeasurementsPageState();
//   }
// }

// class _MeasurementsPageState extends State<MeasurementsPage> {
//   @override
//   Widget build(BuildContext context) {
    
//     return Scaffold(
//       appBar: AppBar(),
//       body: ListView(
//         children: <Widget>[
//           Center(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 40.0 ,vertical: 20.0),
//               child: Row(
//                 children: <Widget>[
//                   // RaisedButton(
//                   //   onPressed: (){
//                   //     getMeasurements();
//                   //   },
//                   // ),
//                    GestureDetector(
//                      onTap: (){

//                      },
//                      child: CircleAvatar(
//                       radius: MediaQuery.of(context).size.width/6,
//                        child: Icon( Icons.add ,size: 50,),
//                      ),
//                    ),
//                    Container(
//                      width: MediaQuery.of(context).size.width/10,
//                    ),
//                     CircleAvatar(
//                       radius: MediaQuery.of(context).size.width/6,
//                      child: Icon( Icons.add , color: Colors.black, size: 50),
//                    )
//                 ],
//               ),
//             ),
//           ),
//           Container(
//             height: 1,
//             color: Colors.grey,
//           ),
//           Column(
//             children: <Widget>[
//               ListTile(
//                       leading: CircleAvatar(
//                         backgroundColor: Colors.red,
//                         child: Icon(Icons.notifications, color: Colors.white,),
//                       ),
//                       title: Row(
//                         mainAxisSize: MainAxisSize.max,
//                         children: <Widget>[
//                           Text('title',
//                               style: TextStyle(
//                                   color: Colors.black,)),
//                         ],
//                       ),
//                       subtitle: Text(
//                         'body',
//                         style: TextStyle(
//                             color: Colors.black,),
//                       ),
//                     )
//             ],
//           ),
//         ],
//       ) ,
     
//     );
//   }

// ///////////////////////////////////////////////////////////////////////

//   void _handleSubmitted(
//       BuildContext context, MainModel model, var value, String type) {
//     model.addMeasurements(type, value).then((result) async {
// //      print(result);
//     });
//   }



//     _showBottomSheet(
//       {BuildContext context,
//       MainModel model,
//       String title,
//       String type,
//       String subTitle,
//       String imageName,
//       double min,
//       double max}) async {
//     await showDialog(
//         barrierDismissible: true,
//         context: context,
//         builder: (BuildContext context) {
//           return settings.BottomSheet(
//               title: title,
//               subtitle: subTitle,
//               image: imageName,
//               min: min,
//               max: max,
//               addSlider: true,
//               onSave: (String value) {
//                 _handleSubmitted(context, model, value, type);
//               });
//         });
//   }


// Dio dio = new Dio();
// final String baseUrl = 'http://104.248.168.117/api';
//   Future<void> getMeasurements() async {
//     //String currentDate = DateTime.now() as String ;
//       SharedPreferences sharedPreferences =
//           await SharedPreferences.getInstance();
//       Map<String, dynamic> authUser =
//           jsonDecode(sharedPreferences.getString("authUser"));
//              var headers = {
//         "Authorization": "Bearer ${authUser['authToken']}",
//       };
//       var response = await dio.get("$baseUrl/measurements/sugarReads?date=2019-09-01",options:  Options(headers: authUser));
//       print("response=$response");
   
      
//       //print("http://104.248.168.117/api/measurements/sugarReads?date=2019-09-01");
//       print("==================================================================");
//       // var data = response.data['week'];
//       // //var data = jsonDecode(response.data);
//       print("response=$response");
//       //print(currentDate);
//       //print(data);
  
//   }


  
// }