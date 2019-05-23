// import 'dart:async';
// import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:handin/src/models/user_model.dart';
//third_party packages
import 'package:scoped_model/scoped_model.dart';

final String baseUrl = 'http://104.248.168.117/api';

mixin UserScopedModel on Model {
  Response response;
  Dio dio = new Dio();

  // user register
  Future<Map<String, dynamic>> userRegister(
      Map<String, dynamic> userData) async {
    try {
      FormData formdata = new FormData();
      formdata.add("first_name", userData['firstName']);
      formdata.add("last_name", userData['lastName']);
      formdata.add("email", userData['email']);
      formdata.add("password", userData['password']);
      response = await dio.post("$baseUrl/v1/auth/register", data: formdata);
      print(response.data.toString());
      if (response.data['status'] == 0) {
        notifyListeners();
        return {"success": false, "error": response.data['errors']['email'][0]};
      }

      notifyListeners();
      return {"success": true, "error": null};
    } on DioError catch (e) {
      print("errrrrrrrrrrrrrrrrrrroooooooorrrrrrrrr");
      print(e.response.data);
      print(e.response.headers);
      print(e.response.request);
      return {"success": false, "error": "Server Error"};
    }
  }

  // // user login
  // Future<Map<String, dynamic>> userLogin(Map<String, dynamic> userData) async {
  //   try {
  //     FormData formdata = new FormData();

  //     formdata.add("email", userData['email']);
  //     formdata.add("password", userData['password']);
  //     response = await dio.post("$baseUrl/v1/auth/login", data: formdata);
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
  //     return {"success": true, "error": null};
  //   } on DioError catch (e) {
  //     print("errrrrrrrrrrrrrrrrrrroooooooorrrrrrrrr");
  //     print(e.response.data);
  //     print(e.response.headers);
  //     print(e.response.request);
  //     return {"success": false, "error": "Server Error"};
  //   }
  // }

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
  //     print("errrrrrrrrrrrrrrrrrrroooooooorrrrrrrrr");
  //     print(e.response.data);
  //     print(e.response.headers);
  //     print(e.response.request);
  //     return {"success": false, "error": "Server Error"};
  //   }
  // }

  // // socialMedia Login
  // Future<Map<String, dynamic>> socialMediaLogin(
  //     Map<String, dynamic> userData) async {
  //   try {
  //     FormData formdata = new FormData();

  //     formdata.add("email", userData['email']);
  //     formdata.add("first_name", userData['firstName']);
  //     formdata.add("last_name", userData['lastName']);
  //     formdata.add("social_provider", userData['provider']);
  //     formdata.add("user_image", userData['imageUrl']);
  //     formdata.add("fcm_token", "");
  //     response = await dio.post("$baseUrl/v1/social/login", data: formdata);
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
  //     return {"success": true, "error": null};
  //   } on DioError catch (e) {
  //     print("errrrrrrrrrrrrrrrrrrroooooooorrrrrrrrr");
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
  //     print("errrrrrrrrrrrrrrrrrrroooooooorrrrrrrrr");
  //     print(e.response.data);
  //     print(e.response.headers);
  //     print(e.response.request);
  //     return {"success": false, "error": "Server Error"};
  //   }
  // }

  // // reset password
  // Future<Map<String, dynamic>> requestResetPasswordCode(String email) async {
  //   try {
  //     FormData formdata = new FormData();

  //     formdata.add("email", email);

  //     response =
  //         await dio.post("$baseUrl/v1/auth/reset/password", data: formdata);
  //     print(response.data.toString());
  //     if (response.data['status'] == 0) {
  //       notifyListeners();
  //       return {"success": false, "error": response.data['errors']['email'][0]};
  //     }

  //     notifyListeners();
  //     return {"success": true, "error": null};
  //   } on DioError catch (e) {
  //     print("errrrrrrrrrrrrrrrrrrroooooooorrrrrrrrr");
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
  //     print("errrrrrrrrrrrrrrrrrrroooooooorrrrrrrrr");
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
  //     print("errrrrrrrrrrrrrrrrrrroooooooorrrrrrrrr");
  //     print(e.response.data);
  //     print(e.response.headers);
  //     print(e.response.request);
  //     return null;
  //   }
  // }
}