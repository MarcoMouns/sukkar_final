import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'doctor_chat_model.dart';

class ApiProvider{
  static const String apiBase = "104.248.168.117/api";
  final String baseUrl = 'http://104.248.168.117/api';
  //
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

      response = await dio.get("$baseUrl/specialists",
          options: Options(headers: headers));
      print(response);

      Map<String , dynamic> json = response.data;

      print('**************HERE WE START THE BTICH****************');

      List<SpecialityDoc>_specoalists = List<SpecialityDoc>();

      _specoalists = ( json["specialists"] as List ).map((i)=>
      SpecialityDoc.fromJson(i)).toList();

      print('HERE WE END THE BTICH');

      print('55555555555555555555555555555555=====>${_specoalists[1].titleAr}');
      return _specoalists;
    } catch (e) {
      print(e);
    }

    //print('++++++++++++++++++++++++++++++++++from here we end the GETCAL');

  }
}