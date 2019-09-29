import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scoped_model/scoped_model.dart';
import '../Models/foods_model.dart';
import '../Models/meals.dart';
import '../Models/all_meals_foods.dart';

final String baseUrl = 'http://104.248.168.117/api';

mixin MealScopedModel on Model {
  Response response;
  Response response2;
  Dio dio = new Dio();
  // FoodsModel foodsModel = FoodsModel();

  Future<MealModel> fetchMeals() async {
    try {
      response = await dio.get(
        "$baseUrl/eatCategories",
      );
      print(response.data.toString());
      if (response.statusCode != 200 && response.statusCode != 201) {
        notifyListeners();
        return null;
      }

      notifyListeners();
      return MealModel.fromJson(response.data);
    } on DioError catch (e) {
      print("errrrrrrrrrrrrrrrrrrroooooooorrrrrrrrr");
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
        "$baseUrl/foods",
      );
      print("................foods.................. ${response.data.toString()}");
      if (response.statusCode != 200 && response.statusCode != 201) {
        notifyListeners();
        return null;
      }

      notifyListeners();
      return UserFoodsModel.fromJson(response.data);
    } on DioError catch (e) {
      print("errrrrrrrrrrrrrrrrrrroooooooorrrrrrrrr");
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
        "$baseUrl/userFoods",
      );
      print(".................................. ${response.data.toString()}");
      if (response.statusCode != 200 && response.statusCode != 201) {
        notifyListeners();
        return null;
      }

      notifyListeners();
      return AllMealsFoodsModel.fromJson(response.data);
    } on DioError catch (e) {
      print("errrrrrrrrrrrrrrrrrrroooooooorrrrrrrrr");
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

      FormData formdataOld = new FormData();
      FormData formdataNew = new FormData();

      int foodIndex = 0;
      foods.forEach((food) {
        if (food != null) {
          formdataNew.add(
            'calories',
            food.calories
          );
          formdataNew.add("date", DateTime.now());


          formdataOld.add(
            "request[$foodIndex][title_ar]",
            food.titleAr,
          );
          formdataOld.add(
            "request[$foodIndex][title_en]",
            food.titleEn,
          );
          formdataOld.add(
            "request[$foodIndex][calories]",
            food.calories,
          );
          formdataOld.add(
            "request[$foodIndex][eat_category_id]",
            mealId,
          );

          foodIndex++;
        }
      });

      print("+++++++++++++++++++++++++++++ fromdate $formdataOld");

      response = await dio.post("$baseUrl/Userfoodtaken", data: formdataOld);
      print(".................................. ${response.data.toString()}");
      print('*******************************************');
      response2 = await dio.post(
          "http://104.248.168.117/api/mapInformation",
          data: formdataNew);
      print(".................................. ${response2.data.toString()}");
      print('*******************************************');
      if (response.statusCode != 200 && response.statusCode != 201) {
        notifyListeners();
        return false;
      }

      notifyListeners();
      return true;
    } on DioError catch (e) {
      print("errrrrrrrrrrrrrrrrrrroooooooorrrrrrrrr");
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

      formdata.add("user_id", authUser['id']);
      formdata.add("calories", mealData['calories']);
      formdata.add("eat_category_id", mealData['categoryId']);
      formdata.add("title_ar", mealData['name']);
      formdata.add("title_en", mealData['name']);

      print("authUser => $authUser");
      print("authUserToken => ${authUser['authToken']}");

      dio.options.headers = {
        "Authorization": "Bearer ${authUser['authToken']}",
        // "token":"11215"
      };

      response = await dio.post("$baseUrl/Userfoodtaken", data: formdata);
      print(response.data.toString());
      if (response.statusCode != 200 && response.statusCode != 201) {
        notifyListeners();
        return false;
      }

      notifyListeners();
      return true;
    } on DioError catch (e) {
      print("errrrrrrrrrrrrrrrrrrroooooooorrrrrrrrr");
      print(e.response.data);
      print(e.response.headers);
      print(e.response.request);
      notifyListeners();
      return false;
    }
  }
}
