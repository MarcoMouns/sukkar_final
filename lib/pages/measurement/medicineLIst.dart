import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:health/Models/medicine_model.dart';
import 'package:health/helpers/loading.dart';
import 'package:health/languages/all_translations.dart';
import 'package:health/scoped_models/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home.dart';
import 'itemList.dart';

class MedList extends StatefulWidget {
  MainModel model;
  MedList(MainModel model){
    this.model = model;
  }
  @override
  _MedListState createState() => _MedListState();
}

class _MedListState extends State<MedList> {
  bool loading = true;
  String now = "";
  List<Medicine> medi = new List();
  List<String> mealsTakenAr = new List();
  List<String> mealsTakenEn = new List();

  Dio dio = new Dio();
  Response response;

  final String baseUrl = 'http://api.sukar.co/api';

  Future<Void> getMedi() async {
    medi.clear();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, dynamic> authUser =
        jsonDecode(sharedPreferences.getString("authUser"));
    var headers = {
      "Authorization": "Bearer ${authUser['authToken']}",
    };
    response = await dio.get("$baseUrl/medicine-today",
        options: Options(headers: headers));

     mealsTakenAr.clear();
    for (int i = 0; i < response.data['medicines'].length; i++) {
      Medicine med = new Medicine();
      String mealAr;
      String mealEn;
      
      med.id = response.data['medicines'][i]['id'];
      med.name = response.data['medicines'][i]['name'];
      med.createdAt = response.data['medicines'][i]['created_at'];
      mealAr = response.data['medicines'][i]['category_ar'];
      mealEn = response.data['medicines'][i]['category_en'];
      medi.add(med);
      mealsTakenAr.add(mealAr);
      mealsTakenEn.add(mealEn);
    }
    
    loading = false;
    setState(() {});
  }


    Future<Void> deleteMedi(int id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, dynamic> authUser =
        jsonDecode(sharedPreferences.getString("authUser"));
    var headers = {
      "Authorization": "Bearer ${authUser['authToken']}",
    };
    response = await dio.delete("$baseUrl/medicine-today/$id",
        options: Options(headers: headers));

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getMedi();
  }

  List<Widget> listBuilder() {
    List<Widget> result = new List();
    for (int i = 0; i < medi.length; i++) {
      Widget added;
      added = ListTile(
        title: Text(
          mealsTakenAr[i],
          style: TextStyle(color: Colors.blue[300], fontSize: 20),
        ),
        subtitle: Text(
          medi[i].name,
          style: TextStyle(fontSize: 13, color: Colors.blueGrey),
        ),
        trailing: InkWell(
          child: ImageIcon(
            AssetImage("assets/icons/ic_trash.png"),
            color: Colors.red,
          ),
          onTap: () {
            deleteMedi(medi[i].id);
            medi.clear();
            getMedi();
          },
        ),
      );
      
      result.add(added);
      result.add(Divider(
        height: 16,
        color: Colors.blueGrey,
      ));
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(allTranslations.text("AddMedicine")),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () =>
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => MainHome())),
          ),
        ),
        body: loading == true
            ? Loading()
            : Directionality(
                textDirection: allTranslations.currentLanguage == "ar"
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: ListView(
                  padding: EdgeInsets.all(16),
                  children: <Widget>[
                    InkWell(
                      child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          height: 60,
                          child: Center(
                            child: Text(
                              allTranslations.text("addMedicine"),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Colors.grey[300], width: 1.5),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ItemList(
                                      model: widget.model,
                                      isfood: false,
                                    ))).then((val)=>val?getMedi():null);
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      allTranslations.text(
                        "mediMenu",
                      ),
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    Column(
                      children: listBuilder(),
                    ),
                  ],
                ),
              ));
  }
}
