import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:health/Models/notifications.dart';
import 'package:health/pages/Settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scoped_model/scoped_model.dart';


mixin NotificationsScopedModel on Model {
  Response response;
  Dio dio = new Dio();

  Future<Notifications> fetchNotifications() async {
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
        "${Settings.baseApilink}/notifications",
      );
      print('data = > \n ${response.data}');
      if (response.statusCode != 200 && response.statusCode != 201) {
        notifyListeners();
        return null;
      }

      notifyListeners();
      return Notifications.fromJson(response.data);
    } on DioError catch (e) {
      print("errrrrrrrrrrrrrrrrrrroooooooorrrrrrrrr");
      print(e.response.data);
      print(e.response.headers);
      print(e.response.request);
      notifyListeners();
      return null;
    }
  }
}
