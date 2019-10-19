import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:health/Models/home_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scoped_model/scoped_model.dart';

final String baseUrl = 'http://api.sukar.co/api';

mixin HomeScopedModel on Model {
  Response response;
  Dio dio = new Dio();

  Future<HomeModel> fetchHome(String date) async {
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
        "$baseUrl/measurements/date?date=$date",
      );
//      print('data = > \n ${response.data}');
      if (response.statusCode != 200 && response.statusCode != 201) {
        notifyListeners();
        return null;
      }

      notifyListeners();
      return HomeModel.fromJson(response.data);
    } on DioError catch (e) {
      print("errrrrrrrrrrrrrrrrrrroooooooorrrrrrrrr");
      print(e);
      print('*****************************************************************');
      print(e.response.data);
      print(e.response.headers);
      print(e.response.request);
      notifyListeners();
      return null;
    }
  }

}
