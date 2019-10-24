import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:health/helpers/loading.dart';
import 'package:health/languages/all_translations.dart';

class TermsAndConditions extends StatefulWidget {
  @override
  TermsAndConditionsState createState() => TermsAndConditionsState();
}

class TermsAndConditionsState extends State<TermsAndConditions> {
  String terms;
  bool isloading = true;
  Response response;
  Dio dio = new Dio();
  void getTerms() async {
 
      response = await dio.get(
        "http://api.sukar.co/api/terms",
      );

      terms = response.data['terms'];
      print("=======================================================");
      print(terms);
      isloading = false;


    setState(() {});
  }

  initState() {
    getTerms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(allTranslations.text("Terms")),
          centerTitle: true,
        ),
        body: isloading == true ? Loading():Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: <Widget>[
              
               Text(terms,style:TextStyle(fontSize: 20)),
              
          

              
              InkWell(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Text(
                    "موافق",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                onTap: () => Navigator.of(context).pop(),
              )
            ],
          ),
        ));
  }
}
