import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:health/Models/article_tab/article_category.dart';
import 'package:health/Models/article_tab/article_detail_category.dart';
import 'package:health/Models/article_tab/article_details.dart';
import 'package:health/Models/doctor_tab/doctor_chat.dart';
import 'package:health/Models/doctor_tab/doctor_specialists.dart';
import 'package:health/Models/doctor_tab/specialists.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scoped_model/scoped_model.dart';

final String baseUrl = 'http://104.248.168.117/api';

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
        "$baseUrl/specialists",
      );
      print('data = > \n ${response.data}');
      if (response.statusCode != 200 && response.statusCode != 201) {
        notifyListeners();
        return null;
      }

      notifyListeners();
      return Specialists.fromJson(response.data);
    } on DioError catch (e) {
      print("errrrrrrrrrrrrrrrrrrroooooooorrrrrrrrr");
      print(e.response.data);
      print(e.response.headers);
      print(e.response.request);
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
        "$baseUrl/doctors?specialist_id=$id",
      );
      print('${baseUrl}');
      print('/doctors?specialist_id=${id}');
      print('data = > \n ${response.data}');
      if (response.statusCode != 200 && response.statusCode != 201) {
        notifyListeners();
        return null;
      }

      notifyListeners();
      return DoctorSpecialists.fromJson(response.data);
    } on DioError catch (e) {
      print("errrrrrrrrrrrrrrrrrrroooooooorrrrrrrrr");
      print(e.response.data);
      print(e.response.headers);
      print(e.response.request);
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
        "$baseUrl/chat/$userId",
      );
      print('$baseUrl/chat/$userId');
      print('data = > \n ${response.data}');
      if (response.statusCode != 200 && response.statusCode != 201) {
        notifyListeners();
        return null;
      }

      notifyListeners();
      return DoctorChat.fromJson(response.data);
    } on DioError catch (e) {
      print("errrrrrrrrrrrrrrrrrrroooooooorrrrrrrrr");
      print(e.response.data);
      print(e.response.headers);
      print(e.response.request);
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
      formData.add("user_recieve", userRecieve);
      formData.add("body", message);
      formData.forEach((e, r) {
        print('{${e} : ${r}}');
      });

      response = await dio.post("$baseUrl/sendMessage", data: formData);
      print('Response = ${response.data}');

      if (response.statusCode != 200 && response.statusCode != 201) {
        notifyListeners();
        return false;
      } else {
        notifyListeners();
        return true;
      }
    } on DioError catch (e) {
      print("errrrrrrrrrrrrrrrrrrroooooooorrrrrrrrr");
      print(e.response.data);
      return false;
    }
  }
}
