import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scoped_model/scoped_model.dart';


final String baseUrl = 'http://api.sukar.co/api';

mixin MedicineScopedModel on Model {
  Response response;
  Dio dio = new Dio();

  Future<bool> addNewMedicine(Map<String, dynamic> medicineData) async {
    
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
      
      };

      response = await dio.post("$baseUrl/medicine", data: formdata);
      print(response.data.toString());


      notifyListeners();
      return true;
    
    
  }
}
