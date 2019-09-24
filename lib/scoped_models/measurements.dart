import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scoped_model/scoped_model.dart';

final String baseUrl = 'http://104.248.168.117/api';

mixin MeasurementsScopedModel on Model {
  Response response;
  Dio dio = new Dio();

  // add Measurements application
  Future<bool> addMeasurements(String type, var value) async {
    try {
      FormData formdata = new FormData();
      // get user token
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      Map<String, dynamic> authUser =
          jsonDecode(sharedPreferences.getString("authUser"));
      dio.options.headers = {
        "Authorization": "Bearer ${authUser['authToken']}",
      };
      formdata.add(type.toString(), value);
      formdata.add("date", DateTime.now());
      formdata.forEach((e, r) {
        print('{${e} : ${r}}');
      });

      response = await dio.post("$baseUrl/measurements", data: formdata);
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
