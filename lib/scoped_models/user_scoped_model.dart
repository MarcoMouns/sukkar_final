import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scoped_model/scoped_model.dart';


final String baseUrl = 'http://api.sukar.co/api';

mixin UserScopedModel on Model {
  Response response;
  Dio dio = new Dio();

  // add phone number
  Future<bool> addPhoneNumber(String phone) async {
    try {
      FormData formdata = new FormData();
      formdata.add("phone", phone);

      response =
          await dio.post("$baseUrl/auth/sendGeneratedCode", data: formdata);
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
      formdata.add("token_id", "12345");
      formdata.add("rand", data['code']);

      response = await dio.post("$baseUrl/auth/check_code", data: formdata);
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
  Future<bool> verifyCodeResetPass(Map<String, dynamic> data) async {
    try {
      FormData formdata = new FormData();
      formdata.add("phone", data['phone']);
      formdata.add("rand", data['code']);

      response = await dio.post("$baseUrl/auth/check_code_reset_password",
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
          await dio.post("$baseUrl/auth/resendGeneratedCode", data: formdata);
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

      response = await dio.post("$baseUrl/auth/register", data: formdata);
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
      print('formdata = ${formdata}');

      if (type == "email") {
        response = await dio.post("$baseUrl/auth/email-login", data: formdata);
      } else {
        response = await dio.post("$baseUrl/auth/login", data: formdata);
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
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      Map<String, dynamic> authUser =
          jsonDecode(sharedPreferences.getString("authUser"));

      print("authUser => $authUser");
      print("authUserToken => ${authUser['authToken']}");

      dio.options.headers = {
        "Authorization": "Bearer ${authUser['authToken']}",
        // "token":"11215"
      };

      response = await dio.post("$baseUrl/auth/send_code_reset_password",
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

      // get user token
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      Map<String, dynamic> authUser =
          jsonDecode(sharedPreferences.getString("authUser"));

      print("authUser => $authUser");
      print("authUserToken => ${authUser['authToken']}");

      dio.options.headers = {
        "Authorization": "Bearer ${authUser['authToken']}",
        // "token":"11215"
      };

      response = await dio.post("$baseUrl/auth/reset_password", data: formdata);
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
      response = await dio.post("$baseUrl/auth/provider", data: formdata);
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

      response = await dio.post("$baseUrl/auth/editUser", data: formdata);
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

  // // user login
  // Future<Map<String, dynamic>> profileUpdate(
  //     Map<String, dynamic> userData) async {
  //   try {
  //     FormData formdata = new FormData();

  //     // get user token
  //     SharedPreferences sharedPreferences =
  //         await SharedPreferences.getInstance();
  //     Map<String, dynamic> authUser =
  //         jsonDecode(sharedPreferences.getString("authUser"));

  //     print("authUser => $authUser");
  //     print("authUserToken => ${authUser['token']}");

  //     dio.options.headers = {
  //       "token": authUser['token'],
  //     };

  //     formdata.add("email", userData['email']);
  //     formdata.add("first_name", userData['firstName']);
  //     formdata.add("last_name", userData['lastName']);
  //     if (userData['profileImage'] != null) {
  //       formdata.add(
  //         "image",
  //         UploadFileInfo(
  //           userData['profileImage'],
  //           basename(userData['profileImage'].path),
  //         ),
  //       );
  //     }
  //     if (userData['idPhoto'] != null) {
  //       formdata.add(
  //         "identity_image",
  //         UploadFileInfo(
  //           userData['idPhoto'],
  //           basename(userData['idPhoto'].path),
  //         ),
  //       );
  //     }
  //     formdata.add("job", userData['job']);
  //     formdata.add("nationality_id", userData['nationality']);

  //     int langIndex = 0;
  //     userData['languagesIds'].forEach((value) {
  //       formdata.add("languages[${langIndex++}]", value);
  //     });
  //     formdata.add("country_id", userData['country']);
  //     formdata.add("birthdate", userData['dateOfBirth']);

  //     response = await dio.post("$baseUrl/v1/profile", data: formdata);
  //     print(response.data.toString());
  //     if (response.data['status'] == 0) {
  //       notifyListeners();
  //       return {"success": false, "error": response.data['errors']['email'][0]};
  //     }

  //     if (response.data['status'] == 3) {
  //       notifyListeners();
  //       return {"success": false, "error": "Invalid email or password.."};
  //     }

  //     // save user data to local storege
  //     String user = jsonEncode({
  //       "firstName": response.data['client']['first_name'],
  //       "lastName": response.data['client']['last_name'],
  //       "email": response.data['client']['email'],
  //       "token": response.data['token'],
  //       "job": response.data['client']['job'],
  //       "phone": response.data['client']['phone'],
  //       "countryId": response.data['client']['country_id'],
  //       "cityId": response.data['client']['city_id'],
  //       "active": response.data['client']['active'],
  //       "birthdate": response.data['client']['birthdate'],
  //       "image": response.data['client']['image'],
  //       "identityImage": response.data['client']['identity_image'],
  //       "socialProvider": response.data['client']['social_provider'],
  //     });

  //     sharedPreferences.setString("authUser", user);

  //     notifyListeners();
  //     return {"success": true, "error": null};
  //   } on DioError catch (e) {
  //     print("errrrrrrrrrrrrrrrrrrroooooooorrrrrrrrr"); print(e); print('*****************************************************************');
  //     print(e.response.data);
  //     print(e.response.headers);
  //     print(e.response.request);
  //     return {"success": false, "error": "Server Error"};
  //   }
  // }

  // // Email verification
  // Future<Map<String, dynamic>> sendEmailVerificationCode(String code) async {
  //   try {
  //     FormData formdata = new FormData();

  //     formdata.add("code", code);

  //     response = await dio.post("$baseUrl/v1/auth/verfiy/code", data: formdata);
  //     print(response.data.toString());
  //     if (response.data['status'] == 0) {
  //       notifyListeners();
  //       return {"success": false, "error": response.data['errors']['code'][0]};
  //     }

  //     // save user data to local storege
  //     SharedPreferences sharedPreferences =
  //         await SharedPreferences.getInstance();
  //     String authUser = jsonEncode({
  //       "firstName": response.data['client']['first_name'],
  //       "lastName": response.data['client']['last_name'],
  //       "email": response.data['client']['email'],
  //       "token": response.data['token'],
  //       "job": response.data['client']['job'],
  //       "phone": response.data['client']['phone'],
  //       "countryId": response.data['client']['country_id'],
  //       // "countryName":   response.data['client'][''],
  //       "cityId": response.data['client']['city_id'],
  //       // "cityName":      response.data['client'][''],
  //       "active": response.data['client']['active'],
  //       "birthdate": response.data['client']['birthdate'],
  //       "image": response.data['client']['image'],
  //       "identityImage": response.data['client']['identity_image'],
  //       "socialProvider": response.data['client']['social_provider'],
  //     });

  //     sharedPreferences.setString("authUser", authUser);

  //     notifyListeners();
  //     return {"success": true, "error": null, "user": response.data['client']};
  //   } on DioError catch (e) {
  //     print("errrrrrrrrrrrrrrrrrrroooooooorrrrrrrrr"); print(e); print('*****************************************************************');
  //     print(e.response.data);
  //     print(e.response.headers);
  //     print(e.response.request);
  //     return {"success": false, "error": "Server Error"};
  //   }
  // }

  // // change password
  // Future<Map<String, dynamic>> changePassword(Map<String, dynamic> data) async {
  //   try {
  //     FormData formdata = new FormData();

  //     formdata.add("code", data['code']);
  //     formdata.add("password", data['password']);

  //     response =
  //         await dio.post("$baseUrl/v1/auth/change/password", data: formdata);
  //     print(response.data.toString());
  //     if (response.data['status'] == 0) {
  //       notifyListeners();
  //       return {"success": false, "error": response.data['errors']['code'][0]};
  //     }

  //     notifyListeners();
  //     return {"success": true, "error": null};
  //   } on DioError catch (e) {
  //     print("errrrrrrrrrrrrrrrrrrroooooooorrrrrrrrr"); print(e); print('*****************************************************************');
  //     print(e.response.data);
  //     print(e.response.headers);
  //     print(e.response.request);
  //     return {"success": false, "error": "Server Error"};
  //   }
  // }

  // // get user data
  // Future<UserModel> getUserData() async {
  //   try {
  //     // get user token
  //     SharedPreferences sharedPreferences =
  //         await SharedPreferences.getInstance();
  //     Map<String, dynamic> authUser =
  //         jsonDecode(sharedPreferences.getString("authUser"));

  //     print("authUser => $authUser");
  //     print("authUserToken => ${authUser['token']}");

  //     dio.options.headers = {
  //       "token": authUser['token'],
  //       // "token":"11215"
  //     };

  //     response = await dio.get("$baseUrl/v1/client/info");

  //     print("okkkkkkkk=> ${response.data.toString()}");

  //     response.data['client']['languages'] =
  //         response.data['client']['languages'].map((language) {
  //       return {
  //         "id": language['id'],
  //         "name": language['name'],
  //       };
  //     }).toList();

  //     print("*********** ${response.data['client']['languages']}");
  //     print("yeeeeeeh=> ${response.data.toString()}");

  //     notifyListeners();
  //     return UserModel.fromJson(response.data); // [] => if operations is empty
  //   } on DioError catch (e) {
  //     print("errrrrrrrrrrrrrrrrrrroooooooorrrrrrrrr"); print(e); print('*****************************************************************');
  //     print(e.response.data);
  //     print(e.response.headers);
  //     print(e.response.request);
  //     return null;
  //   }
  // }
}
