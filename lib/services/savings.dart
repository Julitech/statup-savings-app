import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:dio/dio.dart' as eos;

class Savings {
  static String userId = Hive.box('name').get('userID');
  static String baseUrl = "https://statup.ng/statup/index.php/";

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
      // print("Error/Exception caught" + e.toString());
      return "An error occured1!" + e.toString();
    }
    throw (e) {
      // print("Error/Exception thrown" + e.toString());
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

      //  print(response.data.toString());
      var data = jsonDecode(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data["code"] == 0) {
          //network or server error

          return "An error occured!";
        } else if (data["code"] == 1) {
          Hive.box("statup").put("savings", data["data"]["savings"]);
          //  Hive.box("statup").put("userID", data['id']);

          //(Hive.box("statup").get("savings").toString());
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

  Future<dynamic> pending_tx({
    @required String? savingsID,
    @required String? amount,
    @required String? email,
    @required String? userID,
  }) async {
    try {
      //eos.Response response;
      var dio = eos.Dio();
      //  response = await dio.get('/users/create');
      //  print(response.data.toString());
// Optionally the request above could also be done as

      var formData = eos.FormData.fromMap({
        'savings_id': savingsID,
        'targetAmount': amount,
        'email': email,
        'user_id': userID,
      });

      var response = await dio.post(baseUrl + 'goals/new_pending_tx',
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

          //    print(Hive.box("statup").get("savings").toString());
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

  Future<dynamic> notifications() async {
    try {
      //eos.Response response;
      var dio = eos.Dio();
      //  response = await dio.get('/users/create');
      //  print(response.data.toString());
// Optionally the request above could also be done as

      var response = await dio.get(baseUrl + 'goals/getnotifications',
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
          Hive.box("statup").put("notifications", data["data"]);
          //  Hive.box("statup").put("userID", data['id']);

          //  print(Hive.box("statup").get("notifications").toString());
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

  Future<dynamic> update_notifications() async {
    try {
      //eos.Response response;
      var dio = eos.Dio();
      //  response = await dio.get('/users/create');
      //  print(response.data.toString());
// Optionally the request above could also be done as

      var response = await dio.get(baseUrl + 'goals/updatenotifications',
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
          print("gbedu1 choke");
          return 0;
        } else if (data["code"] == 1) {
          Hive.box("statup").put("unread-notifs", "0");
          print("gbedu3 choke");
          return 1;
        }
      }
    } catch (e) {
      print("gbedu2 choke");
      print("Error/Exception caught" + e.toString());
      return "An error occured1!" + e.toString();
    }
    throw (e) {
      print("Error/Exception thrown" + e.toString());
      return "An error occured!";
    };
  }

  Future<dynamic> deposit(
      {@required String? amount,
      @required String? savingsID,
      @required String? freq,
      @required String? tx_ref}) async {
    try {
      //eos.Response response;
      var dio = eos.Dio();
      //  response = await dio.get('/users/create');
      //  print(response.data.toString());
// Optionally the request above could also be done as

      var formData = eos.FormData.fromMap({
        'amount': amount,
        'savingsID': savingsID,
        'freq': freq,
        'tx_ref': tx_ref,
      });

      var response = await dio.post(baseUrl + 'goals/depositmain',
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
          return 0;
        } else if (data["code"] == 1) {
          Hive.box("statup").put("savings", data["data"]["savings"]);

          Hive.box("statup")
              .put("unread-notifs", data["data"]["notifications"].length);
          //  Hive.box("statup").put("userID", data['id']);

          print("ogun state  " + data.toString());
          return 1;
        } else {
          return 0;
        }
      }
    } catch (e) {
      print("Error/Exception caught" + e.toString());
      return 0;
    }
    throw (e) {
      print("Error/Exception thrown" + e.toString());
      return 0;
    };
  }
}
