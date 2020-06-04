import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:health/Models/doctor_tab/doctor_chat.dart';
import 'package:health/Models/doctor_tab/doctor_specialists.dart';
import 'package:health/Models/doctor_tab/specialists.dart';
import 'package:health/pages/Settings.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin DoctorScopedModel on Model {
  Response response;
  Dio dio = new Dio();

  Future<Specialists> fetchSpecialists() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      Map<String, dynamic> authUser =
          jsonDecode(sharedPreferences.getString("authUser"));

      dio.options.headers = {
        "Authorization": "Bearer ${authUser['authToken']}",
        // "token":"11215"
      };

      response = await dio.get(
        "${Settings.baseApilink}/specialists",
      );
      print('data = > \n ${response.data}');
      if (response.statusCode != 200 && response.statusCode != 201) {
        notifyListeners();
        return null;
      }

      notifyListeners();
      return Specialists.fromJson(response.data);
    } on DioError catch (e) {
      print(e);
      notifyListeners();
      return null;
    }
  }

  Future<DoctorSpecialists> fetchDoctorSpecialists(id) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      Map<String, dynamic> authUser =
          jsonDecode(sharedPreferences.getString("authUser"));

      dio.options.headers = {
        "Authorization": "Bearer ${authUser['authToken']}",
        // "token":"11215"
      };

      response = await dio.get(
        "${Settings.baseApilink}/doctors?specialist_id=$id",
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        notifyListeners();
        return null;
      }

      notifyListeners();
      return DoctorSpecialists.fromJson(response.data);
    } on DioError catch (e) {
      print(e);
      notifyListeners();
      return null;
    }
  }

  Future<DoctorChat> fetchDoctorChat(userId) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      Map<String, dynamic> authUser =
          jsonDecode(sharedPreferences.getString("authUser"));

      dio.options.headers = {
        "Authorization": "Bearer ${authUser['authToken']}",
        // "token":"11215"
      };

      response = await dio.get(
        "${Settings.baseApilink}/chat/$userId",
      );
      print('${Settings.baseApilink}/chat/$userId');
      print('data = > \n ${response.data}');
      if (response.statusCode != 200 && response.statusCode != 201) {
        notifyListeners();
        return null;
      }

      notifyListeners();
      return DoctorChat.fromJson(response.data);
    } on DioError catch (e) {
      print(e);
      notifyListeners();
      return null;
    }
  }

  // send message
  Future<bool> sendMessage(String message, var userRecieve) async {
    try {
      FormData formData = new FormData();
      // get user token
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      Map<String, dynamic> authUser =
          jsonDecode(sharedPreferences.getString("authUser"));
      dio.options.headers = {
        "Authorization": "Bearer ${authUser['authToken']}",
      };
      formData = FormData.fromMap({
        "user_recieve": userRecieve,
        "body": message,
      });

      response =
          await dio.post("${Settings.baseApilink}/sendMessage", data: formData);
      print('Response = ${response.data}');

      if (response.statusCode != 200 && response.statusCode != 201) {
        notifyListeners();
        return false;
      } else {
        notifyListeners();
        return true;
      }
    } on DioError catch (e) {
      print(e);
      return false;
    }
  }
}
