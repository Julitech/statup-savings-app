import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:dio/dio.dart' as eos;

class Others {
  static String userId = Hive.box('name').get('userID');
  static String baseUrl = "https://statup.ng/statup/index.php/";

  Future<dynamic> getProducts() async {
    try {
      //eos.Response response;
      var dio = eos.Dio();
      //  response = await dio.get('/users/create');
      //  print(response.data.toString());
// Optionally the request above could also be done as

      var response = await dio.get(baseUrl + 'ecom/getProducts',
          // data: formData,
          options: eos.Options(
            headers: {
              "accept": "application/json",
              // "Content-Type": "multipart/form-data",
              "Authorization": Hive.box("statup").get("access_token")
            },
          ));

      print(response.data.toString());
      var data = jsonDecode(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data["code"] == 0) {
          //network or server error

          return [];
        } else if (data["code"] == 1) {
          Hive.box("statup").put("products", data["data"]);
          //  Hive.box("statup").put("userID", data['id']);

          print(Hive.box("statup").get("products").toString());
          return data["data"];
        } else {
          return "error!";
        }
      }
    } catch (e) {
      print("Error/Exception caught" + e.toString());
      return "An error occured1!" + e.toString();
    }
    throw (e) {
      print("Error/Exception thrown" + e.toString());
      return "An error occured!";
    };
  }

  Future<dynamic> support({
    @required String? message,
  }) async {
    try {
      //eos.Response response;
      var dio = eos.Dio();
      //  response = await dio.get('/users/create');
      //  print(response.data.toString());
// Optionally the request above could also be done as

      var formData = eos.FormData.fromMap({
        'message': message?.trim(),
      });

      var response = await dio.post(baseUrl + 'support/supportMessage',
          data: formData,
          options: eos.Options(
            headers: {
              "accept": "application/json",
              // "Content-Type": "multipart/form-data",
              "Authorization": Hive.box("statup").get("access_token")
            },
          ));

      print(response.data.toString());
      var data = jsonDecode(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data["code"] == 0) {
          //network or server error

          print("An error occured!");
          return [];
        } else if (data["code"] == 1) {
          return 1;
        } else {
          return "error!";
        }
      }
    } catch (e) {
      print("Error/Exception caught " + e.toString());
      return "An error occured1!" + e.toString();
    }
    throw (e) {
      print("Error/Exception thrown" + e.toString());
      return "An error occured!";
    };
  }
}
