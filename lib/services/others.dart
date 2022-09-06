import 'dart:convert';
import 'dart:math';
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
          return [];
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
          return [];
        }
      }
    } catch (e) {
      print("Error/Exception caught " + e.toString());
      return "An error occured1!" + e.toString();
    }
    throw (e) {
      print("Error/Exception thrown" + e.toString());
      return [];
    };
  }

  Future<dynamic> getExplore() async {
    try {
      //eos.Response response;
      var dio = eos.Dio();
      //  response = await dio.get('/users/create');
      //  print(response.data.toString());
// Optionally the request above could also be done as

      var response = await dio.get(baseUrl + 'explore/getExplore',
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
          Hive.box("statup").put("explore", data["data"]);
          //  Hive.box("statup").put("userID", data['id']);

          print(Hive.box("statup").get("explore").toString());
          return data["data"];
        } else {
          return [];
        }
      }
    } catch (e) {
      print("Error/Exception caught" + e.toString());
      return "An error occured1!" + e.toString();
    }
    throw (e) {
      print("Error/Exception thrown" + e.toString());
      return [];
    };
  }

  Future<dynamic> getReferrals() async {
    try {
      //eos.Response response;
      var dio = eos.Dio();
      //  response = await dio.get('/users/create');
      //  print(response.data.toString());
// Optionally the request above could also be done as

      var response = await dio.get(baseUrl + 'users/getReferrals',
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
          Hive.box("statup").put("referrals", data["data"]);
          //  Hive.box("statup").put("userID", data['id']);

          print(Hive.box("statup").get("referrals").toString());
          return data["data"];
        } else {
          return [];
        }
      }
    } catch (e) {
      print("Error/Exception caught" + e.toString());
      return [];
    }
    throw (e) {
      print("Error/Exception thrown" + e.toString());
      return [];
    };
  }

  Future<dynamic> order({
    @required String? state,
    @required String? amount,
    @required String? address,
    @required String? productID,
    @required String? phone,
    @required String? tx_ref,
  }) async {
    try {
      //eos.Response response;
      var dio = eos.Dio();
      //  response = await dio.get('/users/create');
      //  print(response.data.toString());
// Optionally the request above could also be done as

      var formData = eos.FormData.fromMap({
        'state': state,
        'phone': phone,
        'address': address?.trim(),
        'amount': amount,
        'email': Hive.box("statup").get("email"),
        'tx_ref': tx_ref,
        'product_id': productID,
      });

      var response = await dio.post(baseUrl + 'ecom/purchase',
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
