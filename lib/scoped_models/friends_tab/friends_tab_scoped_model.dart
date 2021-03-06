import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:health/Models/friends_tab/getFollowers.dart';
import 'package:health/Models/friends_tab/getFollowing.dart';
import 'package:health/Models/friends_tab/getMeasureFriends.dart';
import 'package:health/Models/friends_tab/searchFriends.dart';
import 'package:health/pages/Settings.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';




mixin FriendsScopedModel on Model {
  Response response;
  Dio dio = new Dio();

  Future<SearchFriends> getSearchFriends(value) async {
    try {
      SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
      Map<String, dynamic> authUser =
      jsonDecode(sharedPreferences.getString("authUser"));

      dio.options.headers = {
        "Authorization": "Bearer ${authUser['authToken']}",
      };

      response = await dio.get(
          "${Settings.baseApilink}/auth/searchCode/$value");

      if (response.statusCode != 200 && response.statusCode != 201) {
        notifyListeners();
        return null;
      }

      notifyListeners();
      return SearchFriends.fromJson(response.data);
    } on DioError catch (e) {
      print(e);
      notifyListeners();
      return null;
    }
  }

  Future<GetFollowers> getFollowers() async {
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
        "${Settings.baseApilink}/followers",
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        notifyListeners();
        return null;
      }

      notifyListeners();
      return GetFollowers.fromJson(response.data);
    } on DioError catch (e) {
      print(e);
      notifyListeners();
      return null;
    }
  }

  Future<GetFollowing> getFollowing() async {
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
        "${Settings.baseApilink}/following",
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        notifyListeners();
        return null;
      }

      notifyListeners();
      return GetFollowing.fromJson(response.data);
    } on DioError catch (e) {
      print(e);
      notifyListeners();
      return null;
    }
  }

  Future<GetMeasureFriends> getMeasureFriends(user_id) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      Map<String, dynamic> authUser =
          jsonDecode(sharedPreferences.getString("authUser"));

      dio.options.headers = {
        "Authorization": "Bearer ${authUser['authToken']}",
      };

      response = await dio
          .post("${Settings.baseApilink}/get_friend_information", data: {'user_id': user_id});
      if (response.statusCode != 200 && response.statusCode != 201) {
        notifyListeners();
        return null;
      }

      notifyListeners();
      return GetMeasureFriends.fromJson(response.data);
    } on DioError catch (e) {
      print(e);
      notifyListeners();
      return null;
    }
  }
}
