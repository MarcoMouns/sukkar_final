import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:health/Models/articles.dart';
import 'package:health/pages/Settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scoped_model/scoped_model.dart';

mixin ArticlesScopedModel on Model {
  Response response;
  Dio dio = new Dio();
  fetchUserArticles() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      Map<String, dynamic> authUser =
          jsonDecode(sharedPreferences.getString("authUser"));

      dio.options.headers = {
        "Authorization": "Bearer ${authUser['authToken']}",
      };

      response = await dio.get(
        "${Settings.baseApilink}/articles",
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        notifyListeners();
        return null;
      }

      notifyListeners();
      return Articles.fromJson(response.data);
    } on DioError catch (e) {
      print(e);
      notifyListeners();
      return null;
    }
  }
}
