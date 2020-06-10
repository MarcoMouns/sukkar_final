import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:health/pages/Settings.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/all_meals_foods.dart';
import '../Models/foods_model.dart';
import '../Models/meals.dart';

mixin MealScopedModel on Model {
  Response response;
  Dio dio = new Dio();

  Future<MealModel> fetchMeals() async {
    try {
      response = await dio.get(
        "${Settings.baseApilink}/eatCategories",
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        notifyListeners();
        return null;
      }

      notifyListeners();
      return MealModel.fromJson(response.data);
    } on DioError catch (e) {
      print(e);
      notifyListeners();
      return null;
    }
  }

  Future<UserFoodsModel> fetchUserFoods() async {
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
        "${Settings.baseApilink}/foods",
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        notifyListeners();
        return null;
      }

      notifyListeners();
      return UserFoodsModel.fromJson(response.data);
    } on DioError catch (e) {
      print(e);
      notifyListeners();
      return null;
    }
  }

  Future<AllMealsFoodsModel> fetchAllMealsFoods() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      Map<String, dynamic> authUser =
          jsonDecode(sharedPreferences.getString("authUser"));
      dio.options.headers = {
        "Authorization": "Bearer ${authUser['authToken']}",
      };

      response = await dio.get(
        "${Settings.baseApilink}/userFoods",
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        notifyListeners();
        return null;
      }

      notifyListeners();
      return AllMealsFoodsModel.fromJson(response.data);
    } on DioError catch (e) {
      print(e);
      notifyListeners();
      return null;
    }
  }

  Future<bool> addSelectedFoods(List<Foods> foods, int mealId) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      Map<String, dynamic> authUser =
          jsonDecode(sharedPreferences.getString("authUser"));

      dio.options.headers = {
        "Authorization": "Bearer ${authUser['authToken']}",
      };

      FormData formdata = new FormData();

      int foodIndex = 0;
      foods.forEach((food) {
        if (food != null) {
          formdata = FormData.fromMap({
            "request[$foodIndex][title_ar]": food.titleAr,
            "request[$foodIndex][title_en]": food.titleEn,
            "request[$foodIndex][calories]": food.calories,
            "request[$foodIndex][eat_category_id]": mealId,
          });

          foodIndex++;
        }
      });

      for (int i = 0; i < foods.length; i++) {
        response = await dio.post("${Settings.baseApilink}/eat/${foods[i].id}");
      }
      if (response.statusCode != 200 && response.statusCode != 201) {
        notifyListeners();
        return false;
      }

      notifyListeners();
      return true;
    } on DioError catch (e) {
      print(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> addNewFood(Map<String, dynamic> mealData) async {
    try {
      // get user token
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      Map<String, dynamic> authUser =
          jsonDecode(sharedPreferences.getString("authUser"));

      FormData formdata = new FormData();

      formdata = FormData.fromMap({
        "user_id": authUser['id'],
        "calories": mealData['calories'],
        "eat_category_id": mealData['categoryId'],
        "title_ar": mealData['name'],
        "title_en": mealData['name'],
      });

      dio.options.headers = {
        "Authorization": "Bearer ${authUser['authToken']}",
      };

      response = await dio.post("${Settings.baseApilink}/Userfoodtaken",
          data: formdata);
      if (response.statusCode != 200 && response.statusCode != 201) {
        notifyListeners();
        return false;
      }

      notifyListeners();
      return true;
    } on DioError catch (e) {
      print(e);
      notifyListeners();
      return false;
    }
  }
}
