import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:health/pages/Settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'doctor_chat_model.dart';

class ApiProvider{


  static const String specialistsEndPoint = "specialists";

  Response response;
  Dio dio = new Dio();

  Future<List<SpecialityDoc>> getSpecialists() async {
    Response response;

    try {
      SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
      Map<String, dynamic> authUser =
      jsonDecode(sharedPreferences.getString("authUser"));
      var headers = {
        "Authorization": "Bearer ${authUser['authToken']}",
      };

      response = await dio.get("${Settings.baseApilink}/specialists",
          options: Options(headers: headers));
      Map<String , dynamic> json = response.data;
      List<SpecialityDoc>_specoalists = List<SpecialityDoc>();
      _specoalists = ( json["specialists"] as List ).map((i)=>
      SpecialityDoc.fromJson(i)).toList();


      return _specoalists;
    } catch (e) {
      print(e);
    }

  }
}