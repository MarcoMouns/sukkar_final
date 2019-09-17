import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scoped_model/scoped_model.dart';
import '../Models/medicine_model.dart';

final String baseUrl = 'http://104.248.168.117/api';

mixin MedicineScopedModel on Model {
  Response response;
  Dio dio = new Dio();
  // FoodsModel foodsModel = FoodsModel();

  // Future<MealModel> fetchMeals() async {
  //   try {
  //     response = await dio.get(
  //       "$baseUrl/eatCategories",
  //     );
  //     print(response.data.toString());
  //     if (response.statusCode != 200 && response.statusCode != 201) {
  //       notifyListeners();
  //       return null;
  //     }

  //     notifyListeners();
  //     return MealModel.fromJson(response.data);
  //   } on DioError catch (e) {
  //     print("errrrrrrrrrrrrrrrrrrroooooooorrrrrrrrr");
  //     print(e.response.data);
  //     print(e.response.headers);
  //     print(e.response.request);
  //     notifyListeners();
  //     return null;
  //   }
  // }

  Future<MedicineModel> fetchUserMedicines() async {
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
        "$baseUrl/userMedicin",
      );
      print(".................................. ${response.data.toString()}");
      if (response.statusCode != 200 && response.statusCode != 201) {
        notifyListeners();
        return null;
      }

      notifyListeners();
      return MedicineModel.fromJson(response.data);
    } on DioError catch (e) {
      print("errrrrrrrrrrrrrrrrrrroooooooorrrrrrrrr");
      print(e.response.data);
      print(e.response.headers);
      print(e.response.request);
      notifyListeners();
      return null;
    }
  }

  // Future<bool> addSelectedFoods(List<UserFoods> foods) async {
  //   try {
  //     SharedPreferences sharedPreferences =
  //         await SharedPreferences.getInstance();
  //     Map<String, dynamic> authUser =
  //         jsonDecode(sharedPreferences.getString("authUser"));

  //     dio.options.headers = {
  //       "Authorization": "Bearer ${authUser['authToken']}",
  //       // "token":"11215"
  //     };

  //     List<Map<String, dynamic>> request = foods.map((food) {
  //       return {
  //         "title_ar": food.titleAr,
  //         "title_en": food.titleEn,
  //         "calories": food.calories,
  //         "eat_category_id": food.eatCategoryId,
  //       };
  //     }).toList();

  //     response = await dio.post("$baseUrl/Userfoodtaken", data: request);
  //     print(".................................. ${response.data.toString()}");
  //     if (response.statusCode != 200 && response.statusCode != 201) {
  //       notifyListeners();
  //       return false;
  //     }

  //     notifyListeners();
  //     return true;
  //   } on DioError catch (e) {
  //     print("errrrrrrrrrrrrrrrrrrroooooooorrrrrrrrr");
  //     print(e.response.data);
  //     print(e.response.headers);
  //     print(e.response.request);
  //     notifyListeners();
  //     return false;
  //   }
  // }

  Future<bool> addNewMedicine(Map<String, dynamic> medicineData) async {
    try {
      // get user token
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      Map<String, dynamic> authUser =
          jsonDecode(sharedPreferences.getString("authUser"));

      FormData formdata = new FormData();

      formdata.add("user_id", authUser['id']);
      formdata.add("name", medicineData['name']);
      

      print("authUser => $authUser");
      print("authUserToken => ${authUser['authToken']}");

      dio.options.headers = {
        "Authorization": "Bearer ${authUser['authToken']}",
        // "token":"11215"
      };

      response = await dio.post("$baseUrl/medicine", data: formdata);
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
