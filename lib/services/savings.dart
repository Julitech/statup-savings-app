import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:dio/dio.dart' as eos;

class Savings {
  static String userId = Hive.box('name').get('userID');
  static String baseUrl = "http://statup.ng/statup/index.php/";

  Future<dynamic> setDefaultSavings({
    @required String? defaltSavingsName,
    @required String? targetAmount,
    @required String? startAmount,
    @required String? frequency,
  }) async {
    try {
      //eos.Response response;
      var dio = eos.Dio();
      //  response = await dio.get('/users/create');
      //  print(response.data.toString());
// Optionally the request above could also be done as

      var formData = eos.FormData.fromMap({
        'defaltSavingsName': defaltSavingsName,
        'targetAmount': targetAmount,
        'startAmount': startAmount,
        'frequency': frequency,
      });

      var response = await dio.post(baseUrl + 'goals/create_default',
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

          return "An error occured!";
        } else if (data["code"] == 1) {
          Hive.box("statup").put("savings", data['savings_plans']);
          //  Hive.box("statup").put("userID", data['id']);
          return 1;
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

  Future<dynamic> addSavings({
    @required String? savingsID,
    @required String? targetAmount,
    @required String? frequency,
  }) async {
    try {
      //eos.Response response;
      var dio = eos.Dio();
      //  response = await dio.get('/users/create');
      //  print(response.data.toString());
// Optionally the request above could also be done as

      var formData = eos.FormData.fromMap({
        'savings_id': savingsID,
        'targetAmount': targetAmount,
        'frequency': frequency,
      });

      var response = await dio.post(baseUrl + 'goals/deposit',
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

          return "An error occured!";
        } else if (data["code"] == 1) {
          Hive.box("statup").put("savings", data["data"]);
          //  Hive.box("statup").put("userID", data['id']);

          print(Hive.box("statup").get("savings").toString());
          return 1;
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

  Future<dynamic> transactions() async {
    try {
      //eos.Response response;
      var dio = eos.Dio();
      //  response = await dio.get('/users/create');
      //  print(response.data.toString());
// Optionally the request above could also be done as

      var response = await dio.get(baseUrl + 'goals/gettransactions',
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
          Hive.box("statup").put("transactions", data["data"]);
          //  Hive.box("statup").put("userID", data['id']);

          print(Hive.box("statup").get("transactions").toString());
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

  Future<dynamic> withdraw(
      {@required String? amount,
      @required String? savingsID,
      @required String? savingsName,
      @required String? newTarget,
      @required String? newTargetAmt}) async {
    try {
      //eos.Response response;
      var dio = eos.Dio();
      //  response = await dio.get('/users/create');
      //  print(response.data.toString());
// Optionally the request above could also be done as

      var formData = eos.FormData.fromMap({
        'amount': amount,
        'savingsID': savingsID,
        'savingsName': savingsName,
        'newTarget': newTarget,
        'newTargetAmt': newTargetAmt,
      });

      var response = await dio.post(baseUrl + 'goals/withdraw',
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
          Hive.box("statup").put("savings", data["data"]);
          //  Hive.box("statup").put("userID", data['id']);

          print(Hive.box("statup").get("savings").toString());
          return 1;
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
}
