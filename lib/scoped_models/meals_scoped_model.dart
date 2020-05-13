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
      print(response.data.toString());
      if (response.statusCode != 200 && response.statusCode != 201) {
        notifyListeners();
        return null;
      }

      notifyListeners();
      return MealModel.fromJson(response.data);
    } on DioError catch (e) {
      print("errrrrrrrrrrrrrrrrrrroooooooorrrrrrrrr"); print(e); print('*****************************************************************');
      print(e.response.data);
      print(e.response.headers);
      print(e.response.request);
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
      print("................foods.................. ${response.data.toString()}");
      if (response.statusCode != 200 && response.statusCode != 201) {
        notifyListeners();
        return null;
      }

      notifyListeners();
      return UserFoodsModel.fromJson(response.data);
    } on DioError catch (e) {
      print("errrrrrrrrrrrrrrrrrrroooooooorrrrrrrrr"); print(e); print('*****************************************************************');
      print(e.response.data);
      print(e.response.headers);
      print(e.response.request);
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
        // "token":"11215"
      };

      response = await dio.get(
        "${Settings.baseApilink}/userFoods",
      );
      print(".................................. ${response.data.toString()}");
      if (response.statusCode != 200 && response.statusCode != 201) {
        notifyListeners();
        return null;
      }

      notifyListeners();
      return AllMealsFoodsModel.fromJson(response.data);
    } on DioError catch (e) {
      print("errrrrrrrrrrrrrrrrrrroooooooorrrrrrrrr"); print(e); print('*****************************************************************');
      print(e.response.data);
      print(e.response.headers);
      print(e.response.request);
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
        // "token":"11215"
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

      print("+++++++++++++++++++++++++++++ fromdate $formdata");
      
      for(int i= 0 ; i<foods.length; i++){
      response = await dio.post("${Settings.baseApilink}/eat/${foods[i].id}");
      print(".................................. ${response.data.toString()}");
      }
      if (response.statusCode != 200 && response.statusCode != 201) {
        notifyListeners();
        return false;
      }

      notifyListeners();
      return true;
    } on DioError catch (e) {
      print("errrrrrrrrrrrrrrrrrrroooooooorrrrrrrrr");
      print(e);
      print('*****************************************************************');
      print(e.response.data);
      print(e.response.headers);
      print(e.response.request);
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

      print("authUser => $authUser");
      print("authUserToken => ${authUser['authToken']}");

      dio.options.headers = {
        "Authorization": "Bearer ${authUser['authToken']}",
        // "token":"11215"
      };

      response = await dio.post("${Settings.baseApilink}/Userfoodtaken", data: formdata);
      print(response.data.toString());
      if (response.statusCode != 200 && response.statusCode != 201) {
        notifyListeners();
        return false;
      }

      notifyListeners();
      return true;
    } on DioError catch (e) {
      print("errrrrrrrrrrrrrrrrrrroooooooorrrrrrrrr");
      print(e);
      print('*****************************************************************');
      print(e.response.data);
      print(e.response.headers);
      print(e.response.request);
      notifyListeners();
      return false;
    }
  }
}
