import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:health/pages/Settings.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scoped_model/scoped_model.dart';



mixin UserScopedModel on Model {
  Response response;
  Dio dio = new Dio();

  // add phone number
  Future<bool> addPhoneNumber(String phone) async {
    try {
      FormData formdata = new FormData();
      formdata.add("phone", phone);

      response =
          await dio.post("${Settings.baseApilink}/auth/sendGeneratedCode", data: formdata);
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
      formdata.add("phone", data['phone']);
      formdata.add("rand", data['code']);

      response = await dio.post("${Settings.baseApilink}/auth/check_code", data: formdata);
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
      formdata.add("phone", data['phone']);
      formdata.add("rand", data['code']);

      response = await dio.post("${Settings.baseApilink}/auth/check_code_reset_password",
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
      formdata.add("phone", phone);

      response =
          await dio.post("${Settings.baseApilink}/auth/resendGeneratedCode", data: formdata);
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
      formdata.add("name", userData['userName']);
      formdata.add("email", userData['email']);
      formdata.add("birth_date", userData['birthDate']);
      formdata.add("injuredDate", userData['injuredDate']);
      formdata.add("token_id", "0000000000");
      formdata.add("gender", userData['gender']);
      formdata.add("phone", userData['phone']);
      formdata.add("password", userData['password']);
      formdata.add("fuid", userData['fuid']);

      if (userData['image'] != null) {
        formdata.add(
          "image",
          UploadFileInfo(
            userData['image'],
            basename(userData['image'].path),
          ),
        );
      }

      response = await dio.post("${Settings.baseApilink}/auth/register", data: formdata);
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

      if (type == "email") {
        formdata.add("email", userData['email']);
      } else {
        formdata.add("phone", userData['phone']);
      }
      formdata.add("password", userData['password']);
      formdata.add("token_id", '12345');
      print('formdata = $formdata');

      if (type == "email") {
        response = await dio.post("${Settings.baseApilink}/auth/email-login", data: formdata);
      } else {
        response = await dio.post("${Settings.baseApilink}/auth/login", data: formdata);
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

      formdata.add("phone", phone);

      // get user token

  

      response = await dio.post("${Settings.baseApilink}/auth/send_code_reset_password",
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

      formdata.add("phone", data['phone']);
      formdata.add("password", data['password']);
      // formdata.add("rand", data['code']);
      formdata.add("token_id", '1234');



    

      response = await dio.post("${Settings.baseApilink}/auth/reset_password", data: formdata);
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

      formdata.add("email", userData['email']);
      formdata.add("name", userData['name']);
      formdata.add("gender", userData['gender']);
      formdata.add("provider", userData['provider']);
      // formdata.add("provider_id", userData['provider_id'].toString());
      formdata.add("provider_id", 1545);
      formdata.add("token_id", "12345");
      response = await dio.post("${Settings.baseApilink}/auth/provider", data: formdata);
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

      formdata.add("phone", userData['phone']);
      if (userData['image'] != null) {
        formdata.add(
          "image",
          UploadFileInfo(
            userData['image'],
            basename(userData['image'].path),
          ),
        );
      }
      formdata.add("birth_date", userData['injuredDate']);


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

      response = await dio.post("${Settings.baseApilink}/auth/editUser", data: formdata);
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
