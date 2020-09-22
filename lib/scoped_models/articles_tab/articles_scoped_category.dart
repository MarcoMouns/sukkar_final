import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:health/Models/article_tab/article_category.dart';
import 'package:health/Models/article_tab/article_detail_category.dart';
import 'package:health/Models/article_tab/article_details.dart';
import 'package:health/pages/Settings.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin ArticlesCategoriesScopedModel on Model {
  Response response;
  Dio dio = new Dio();

  Future<ArticleCategory> fetchArticlesCategories() async {
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
        "${Settings.baseApilink}/articles-category",
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        notifyListeners();
        return null;
      }

      notifyListeners();
      return ArticleCategory.fromJson(response.data);
    } on DioError catch (e) {
      notifyListeners();
      return null;
    }
  }

  Future<ArticleDetailCategory> fetchArticlesCategoriesDetails(id) async {
    try {
      SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
      Map<String, dynamic> authUser =
      jsonDecode(sharedPreferences.getString("authUser"));

      dio.options.headers = {
        "Authorization": "Bearer ${authUser['authToken']}",
      };

      response = await dio.get(
        "${Settings.baseApilink}/get_articles?category_id=$id",
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        notifyListeners();
        return null;
      }

      notifyListeners();
      return ArticleDetailCategory.fromJson(response.data);
    } on DioError catch (e) {
      print(e);
      notifyListeners();
      return null;
    }
  }

  Future<ArticleDetails> fetchSingleArticle(id) async {
    try {
      SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
      Map<String, dynamic> authUser =
      jsonDecode(sharedPreferences.getString("authUser"));

      dio.options.headers = {
        "Authorization": "Bearer ${authUser['authToken']}",
      };
      response = await dio.get(
        "${Settings.baseApilink}/articles/$id",
      );
      print('**************************************');
      print(id);
      print('**************************************');
      if (response.statusCode != 200 && response.statusCode != 201) {
        notifyListeners();
        return null;
      }

      notifyListeners();
      return ArticleDetails.fromJson(response.data);
    } on DioError catch (e) {
      print(e);
      notifyListeners();
      return null;
    }
  }
}
