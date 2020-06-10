import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:health/pages/Settings.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin MeasurementsScopedModel on Model {
  Response response;
  Dio dio = new Dio();

  // add Measurements application
  Future<bool> addMeasurements(String type, var value) async {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(now);
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
      formdata = FormData.fromMap({
        type.toString(): value,
        "date": formatted,
      });

      response = await dio.post("${Settings.baseApilink}/measurements",
          data: formdata);
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
