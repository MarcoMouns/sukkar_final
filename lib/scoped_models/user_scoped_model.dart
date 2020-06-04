import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:health/pages/Settings.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin UserScopedModel on Model {
  Response response;
  Dio dio = new Dio();

  // add phone number
  Future<bool> addPhoneNumber(String phone , String name , String password) async {
    try {
      FormData formdata = new FormData();
      formdata = FormData.fromMap({
        "phone": phone,
        "name": name,
        "password": password,
      });

      response = await dio.post(
          "${Settings.baseApilink}/auth/sendGeneratedCode",
          data: formdata);
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

  // phone number verification
  Future<bool> verifyCode(Map<String, dynamic> data) async {
    try {
      FormData formdata = new FormData();
      formdata = FormData.fromMap({
        "phone": data['phone'],
        "rand": data['code'],
      });

      response =
      await dio.post("${Settings.baseApilink}/auth/check_code", data: formdata);
      print(response.data.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        notifyListeners();
        return true;
      }

      notifyListeners();
      return false;
    } on DioError catch (e) {
      print("errrrrrrrrrrrrrrrrrrroooooooorrrrrrrrr");
      print(e);
      print('*****************************************************************');
      print(e.response.data);
      print(e.response.headers);
      print(e.response.request);
//      notifyListeners();
//      return false;
    }
  }

  // phone number verification
  Future<bool> verifyCodeResetPass(Map<String, dynamic> data) async {
    try {
      FormData formdata = new FormData();

      formdata = FormData.fromMap({
        "phone": data['phone'],
        "rand": data['code'],
      });

      response =
      await dio.post("${Settings.baseApilink}/auth/check_code_reset_password",
          data: formdata);
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

  // Resend verification code
  Future<bool> resendVerifyCode(String phone) async {
    try {
      FormData formdata = new FormData();
      formdata = FormData.fromMap({
        "phone": phone
      });

      response =
      await dio.post(
          "${Settings.baseApilink}/auth/resendGeneratedCode", data: formdata);
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

  // user register
  Future<bool> userRegister(Map<String, dynamic> userData) async {
    try {
      FormData formdata = new FormData();

      formdata = FormData.fromMap({
        "name": userData['userName'],
        "email": userData['email'],
        "birth_date": userData['birthDate'],
        "injuredDate": userData['injuredDate'],
        "token_id": "0000000000",
        "gender": userData['gender'],
        "phone": userData['phone'],
        "password": userData['password'],
        "fuid": userData['fuid'],
      });


      if (userData['image'] != null) {
        formdata = FormData.fromMap({
          "name": userData['userName'],
          "email": userData['email'],
          "birth_date": userData['birthDate'],
          "injuredDate": userData['injuredDate'],
          "token_id": "0000000000",
          "gender": userData['gender'],
          "phone": userData['phone'],
          "password": userData['password'],
          "fuid": userData['fuid'],
          "image": await MultipartFile.fromFile("${userData['image'].path}"),
        });
      }

      response =
      await dio.post("${Settings.baseApilink}/auth/register", data: formdata);
      print(response.data.toString());
      if (response.statusCode != 200 && response.statusCode != 201) {
        notifyListeners();
        return false;
      }

      // save user data to local storege
      SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
      String authUser = jsonEncode({
        "authToken": response.data['access_token'],
        "id": response.data['user']['id'],
        "search_code": response.data['user']['search_code'],
        "userName": response.data['user']['name'],
        "phone": response.data['user']['phone'],
        "email": response.data['user']['email'],
        "birthDate": response.data['user']['birth_date'],
        "injuredDate": response.data['user']['injuredDate'],
        "state": response.data['user']['state'],
        "image": response.data['user']['image'],
        "gender": response.data['user']['gender'],
        "height": response.data['user']['hight'],
        "weight": response.data['user']['weight'],
        "fuid": response.data['user']['fuid'],
        "average_calorie": response.data['user']['average_calorie'],
        "verified": response.data['user']['type'],
        "fcmToken": response.data['user']['token_id'],
      });

      sharedPreferences.setString("authUser", authUser);

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

  // user login
  Future<bool> userLogin(Map<String, dynamic> userData, String type) async {
    try {
      FormData formdata = new FormData();

      formdata = FormData.fromMap({
        "email": userData['email'],
        "phone": userData['phone'],
        "password": userData['password'],
        "token_id": '12345',
      });

      print('formdata = $formdata');

      if (type == "email") {
        response = await dio.post(
            "${Settings.baseApilink}/auth/email-login", data: formdata);
      } else {
        response =
        await dio.post("${Settings.baseApilink}/auth/login", data: formdata);
      }
      print('Response = ${response.data}');

      if (response.statusCode != 200 && response.statusCode != 201) {
        notifyListeners();
        return false;
      }

      // save user data to local storage
      SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
      String authUser = jsonEncode({
        "authToken": response.data['access_token'],
        "id": response.data['user']['id'],
        "search_code": response.data['user']['search_code'],
        "userName": response.data['user']['name'],
        "phone": response.data['user']['phone'],
        "email": response.data['user']['email'],
        "injuredDate": response.data['user']['birth_date'],
        "state": response.data['user']['state'],
        "image": response.data['user']['image'],
        "gender": response.data['user']['gender'],
        "height": response.data['user']['hight'],
        "weight": response.data['user']['weight'],
        "fuid": response.data['user']['fuid'],
        "average_calorie": response.data['user']['average_calorie'],
        "verified": response.data['user']['type'],
        "fcmToken": response.data['user']['token_id'],
      });

      sharedPreferences.setString("authUser", authUser);

      notifyListeners();
      return true;
    } on DioError catch (e) {
      print("errrrrrrrrrrrrrrrrrrroooooooorrrrrrrrr");
      print(e);
      print('*****************************************************************');
      print(e.response.data);
      print(e.response.headers);
      print(e.response.request);
      return false;
    }
  }

  // reset password
  Future<bool> requestResetPasswordCode(String phone) async {
    try {
      FormData formdata = new FormData();
      formdata = FormData.fromMap({"phone": phone});

      response =
      await dio.post("${Settings.baseApilink}/auth/send_code_reset_password",
          data: formdata);
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
      return false;
    }
  }

  // Change Password
  Future<bool> changePassword(Map<String, dynamic> data) async {
    try {
      FormData formdata = new FormData();

      formdata = FormData.fromMap({
        "phone": data['phone'],
        "password": data['password'],
        "token_id": '1234',
      });

      response = await dio.post(
          "${Settings.baseApilink}/auth/reset_password", data: formdata);
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
      return false;
    }
  }

  // socialMedia Login
  Future<Map<String, dynamic>> socialMediaLogin(Map<String, dynamic> userData) async {
    print("userData ===> $userData");
    try {
      FormData formdata = new FormData();
      formdata = FormData.fromMap({
        "email": userData['email'],
        "name": userData['name'],
        "gender": userData['gender'],
        "provider": userData['provider'],
        "provider_id": 1545,
        "token_id": "12345",
      });

      // formdata.add("provider_id", userData['provider_id'].toString());

      response =
      await dio.post("${Settings.baseApilink}/auth/provider", data: formdata);
      print(response.data.toString());
      // if (response.data['status'] == 0) {
      //   notifyListeners();
      //   return {"success": false, "error": response.data['errors']['email'][0]};
      // }

      if (response.statusCode != 200 && response.statusCode != 201) {
        notifyListeners();
        return {"success": false, "error": "Facebook login error"};
      }

      // save user data to local storege
      SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
      String authUser = jsonEncode({
        "authToken": response.data['access_token'],
        "id": response.data['user']['id'],
        "search_code": response.data['user']['search_code'],
        "userName": response.data['user']['name'],
        "phone": response.data['user']['phone'],
        "email": response.data['user']['email'],
        "injuredDate": response.data['user']['birth_date'],
        "state": response.data['user']['state'],
        "image": response.data['user']['image'],
        "gender": response.data['user']['gender'],
        "height": response.data['user']['hight'],
        "weight": response.data['user']['weight'],
        "fuid": response.data['user']['fuid'],
        "average_calorie": response.data['user']['average_calorie'],
        "verified": response.data['user']['type'],
        "fcmToken": response.data['user']['token_id'],
      });

      sharedPreferences.setString("authUser", authUser);

      notifyListeners();
      if (response.data['user']['phone'] == null) {
        return {"success": true, "error": null, "new": true};
      } else {
        return {"success": true, "error": null, "new": false};
      }
    } on DioError catch (e) {
      print("errrrrrrrrrrrrrrrrrrroooooooorrrrrrrrr");
      print(e);
      print('*****************************************************************');
      print(e.response.data);
      print(e.response.headers);
      print(e.response.request);
      return {"success": false, "error": "Facebook login error"};
    }
  }

  // socialMedia Login
  Future<bool> completeSocialLoginData(Map<String, dynamic> userData) async {
    print("userData ===> $userData");
    try {
      FormData formdata = new FormData();
      formdata = FormData.fromMap({
        "phone": userData['phone'],
        "birth_date": userData['injuredDate'],
      });

      if (userData['image'] != null) {
        formdata = FormData.fromMap({
          "phone": userData['phone'],
          "birth_date": userData['injuredDate'],
          "image": await MultipartFile.fromFile("${userData['image'].path}")
        });
      }


      // get user token
      SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
      Map<String, dynamic> currentUser =
      jsonDecode(sharedPreferences.getString("authUser"));

      print("currentUser => $currentUser");
      print("authUserToken => ${currentUser['authToken']}");

      dio.options.headers = {
        "Authorization": "Bearer ${currentUser['authToken']}",
        // "token":"11215"
      };

      response =
      await dio.post("${Settings.baseApilink}/auth/editUser", data: formdata);
      print(response.data.toString());

      if (response.statusCode != 200 && response.statusCode != 201) {
        notifyListeners();
        return false;
      }

      // save user data to local storege

      String authUser = jsonEncode({
        "authToken": currentUser['authToken'],
        "id": response.data['user']['id'],
        "search_code": response.data['user']['search_code'],
        "userName": response.data['user']['name'],
        "phone": response.data['user']['phone'],
        "email": response.data['user']['email'],
        "injuredDate": response.data['user']['birth_date'],
        "state": response.data['user']['state'],
        "image": response.data['user']['image'],
        "gender": response.data['user']['gender'],
        "height": response.data['user']['hight'],
        "weight": response.data['user']['weight'],
        "fuid": response.data['user']['fuid'],
        "average_calorie": response.data['user']['average_calorie'],
        "verified": response.data['user']['type'],
        "fcmToken": response.data['user']['token_id'],
      });

      sharedPreferences.setString("authUser", authUser);

      notifyListeners();

      return true;
    } on DioError catch (e) {
      print("errrrrrrrrrrrrrrrrrrroooooooorrrrrrrrr");
      print(e);
      print('*****************************************************************');
      print(e.response.data);
      print(e.response.headers);
      print(e.response.request);
      return false;
    }
  }
}
