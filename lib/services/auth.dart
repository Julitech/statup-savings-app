import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:dio/dio.dart' as eos;

class AuthService {
  //static String userId = Hive.box('name').get('userID');
  static String baseUrl = "https://statup.ng/statup/index.php/";

  Future<dynamic> signup(
      {@required String? phone,
      @required String? email,
      @required String? first_name,
      @required String? last_name,
      @required String? pwd,
      String? referrer}) async {
    try {
      //eos.Response response;
      var dio = eos.Dio();
      //  response = await dio.get('/users/create');
      //  print(response.data.toString());
// Optionally the request above could also be done as

      var formData = eos.FormData.fromMap({
        'phone': phone!.trim(),
        'email': email!.trim(),
        'first_name': first_name!.trim(),
        'last_name': last_name!.trim(),
        'password': pwd,
        'referrer': referrer!.trim()
      });

      var response = await dio.post(baseUrl + 'users/create', data: formData);

      print(response.data.toString());
      var data = jsonDecode(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data["code"] == 0) {
          //network or server error

          return "An error occured!";
        } else if (data["code"] == 2) {
          //email already exists
          return "Sorry! That email already exists";
        } else if (data["code"] == 3) {
          //invalid email
          return "Invalid email, try again!";
        } else if (data["code"] == 1) {
          Hive.box("statup").put("email", data['email']);
          Hive.box("statup").put("userID", data['id']);
          Hive.box("statup").put("id", data['id']);
          return 1;
        } else {
          return "error!";
        }
      }
    } catch (e) {
      print("Error/Exception caught" + e.toString());
      return "An error occured1!";
    }
    throw (e) {
      print("Error/Exception thrown" + e.toString());
      return "An error occured!";
    };
  }

  //verify otp

  Future<dynamic> verifyOTP({
    @required String? email,
    @required String? userID,
    @required String? otp,
  }) async {
    try {
      //eos.Response response;
      var dio = eos.Dio();
      //  response = await dio.get('/users/create');
      //  print(response.data.toString());
// Optionally the request above could also be done as

      var formData = eos.FormData.fromMap({
        'otp': otp?.trim(),
        'email': email?.trim(),
        'userID': userID,
      });

      var response =
          await dio.post(baseUrl + 'users/verifyEmail', data: formData);

      print(response.data.toString());
      var data = jsonDecode(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data["code"] == 0) {
          //network or server error

          return "An error occured!";
        } else if (data["code"] == 1) {
          Hive.box("statup").put("email", data['email']);
          Hive.box("statup").put("userID", data['id']);
          Hive.box("statup").put("first_name", data['first_name']);
          Hive.box("statup").put("last_name", data['last_name']);
          Hive.box("statup").put("email", data['email']);
          Hive.box("statup").put("access_token", data['access_token']);
          Hive.box("statup").put("id", data['id']);
          Hive.box("statup").put("phone", data['phone']);

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

  Future<dynamic> setPIN({
    @required String? pin,
  }) async {
    try {
      //eos.Response response;
      var dio = eos.Dio();
      //  response = await dio.get('/users/create');
      //  print(response.data.toString());
// Optionally the request above could also be done as

      var formData = eos.FormData.fromMap({
        'pin': pin?.trim(),
      });

      var response = await dio.post(baseUrl + 'users/setPIN',
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
          Hive.box("statup").put("pin", data['pin']);
          Hive.box("statup").put("loggedIn", true);
          Hive.box("statup").put("savings", data["savings_plans"]);

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

  Future<dynamic> loginWithPIN({
    @required String? pin,
  }) async {
    try {
      //eos.Response response;
      var dio = eos.Dio();
      //  response = await dio.get('/users/create');
      //  print(response.data.toString());
// Optionally the request above could also be done as

      var formData = eos.FormData.fromMap({
        'pin': pin!.trim(),
      });

      var response = await dio.post(baseUrl + 'users/loginwithpin',
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
          Hive.box("statup").put("savings", data["data"]["savings_plans"]);
          Hive.box("statup").put("email", data["data"]['0']["email"]);
          Hive.box("statup").put("id", data["data"]['0']["id"]);
          Hive.box("statup").put("first_name", data["data"]['0']["first_name"]);
          Hive.box("statup").put("last_name", data["data"]['0']["last_name"]);
          Hive.box("statup").put("pin", data["data"]['0']["pin"]);
          Hive.box("statup")
              .put("access_token", data["data"]['0']["access_token"]);
          return 1;
        } else {
          return "error!";
        }
      }
    } catch (e) {
      print(Hive.box("statup").get("access_token"));
      print("Error/Exception caught " + e.toString());
      return "An error occured1!" + e.toString();
    }
    throw (e) {
      print("Error/Exception thrown" + e.toString());

      print(Hive.box("statup").get("access_token"));
      return "An error occured!";
    };
  }

  Future<dynamic> login({
    @required String? email,
    @required String? password,
  }) async {
    try {
      //eos.Response response;
      var dio = eos.Dio();
      //  response = await dio.get('/users/create');
      //  print(response.data.toString());
// Optionally the request above could also be done as

      var formData = eos.FormData.fromMap(
          {'email': email?.trim(), 'password': password?.trim()});

      var response = await dio.post(baseUrl + 'users/login',
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
          return "An error occured!";
        } else if (data["code"] == 1) {
          Hive.box("statup").put("access_token", data["data"]["access_token"]);
          Hive.box("statup").put("first_name", data["data"]["first_name"]);
          Hive.box("statup").put("last_name", data["data"]["last_name"]);
          Hive.box("statup").put("email", data["data"]["email"]);
          Hive.box("statup").put("phone", data["data"]["phone"]);
          Hive.box("statup").put("acc_name", data["data"]["account_name"]);
          Hive.box("statup").put("id", data["data"]["id"]);
          Hive.box("statup").put("acc_num", data["data"]["account_num"]);
          Hive.box("statup")
              .put("profile_image", data["data"]["profile_picture"]);
          Hive.box("statup").put("bank", data["data"]["bank"]);
          Hive.box("statup").put("loggedIn", true);
          Hive.box("statup").put("savings", data["data"]["savings_plans"]);
          print("logged In successfully!");
          Hive.box("statup").put("businesses", data["data"]["businesses"]);
          // Hive.box("statup").put("savings", data["data"]);
          return 1;
        } else if (data["code"] == 2) {
          print("Sorry! No account was found with that email!");
          return "Sorry! No account was found with that email!";
        } else {
          print("An error occured!");
          return "An error occured!";
        }
      }
    } catch (e) {
      print("Error/Exception caught " + e.toString());
      return "An error occured!";
    }
    throw (e) {
      print("Error/Exception thrown" + e.toString());

      return "An error occured!";
    };
  }

  Future<dynamic> updateUser({
    @required String? first_name,
    @required String? last_name,
    @required String? email,
    @required File? dp,
  }) async {
    try {
      //eos.Response response;
      var dio = eos.Dio();
      //  response = await dio.get('/users/create');
      //  print(response.data.toString());
// Optionally the request above could also be done as

      var formData = eos.FormData.fromMap({
        'first_name': first_name?.trim(),
        'last_name': last_name?.trim(),
        'email': email?.trim(),
        'file': await eos.MultipartFile.fromFile(dp!.path, filename: dp.path),
      });

      var response = await dio.post(baseUrl + 'users/editUser',
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
          Hive.box("statup").put("first_name", data["data"]["first_name"]);
          Hive.box("statup").put("last_name", data["data"]["last_name"]);
          Hive.box("statup").put("id", data["data"]["id"]);
          Hive.box("statup")
              .put("profile_image", data["data"]["profile_picture"]);
          Hive.box("statup").put("email", data["data"]["email"]);

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

  Future<dynamic> updateBank({
    @required String? acc_name,
    @required String? acc_num,
    @required String? bank,
  }) async {
    try {
      //eos.Response response;
      var dio = eos.Dio();
      //  response = await dio.get('/users/create');
      //  print(response.data.toString());
// Optionally the request above could also be done as

      var formData = eos.FormData.fromMap({
        'acc_name': acc_name?.trim(),
        'acc_num': acc_num?.trim(),
        'bank': bank?.trim(),
      });

      var response = await dio.post(baseUrl + 'users/editBank',
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
          Hive.box("statup").put("acc_name", data["data"]["account_name"]);
          Hive.box("statup").put("acc_num", data["data"]["account_num"]);

          Hive.box("statup").put("bank", data["data"]["bank"]);

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

  Future<dynamic> forgotPassword({
    @required String? email,
  }) async {
    try {
      //eos.Response response;
      var dio = eos.Dio();
      //  response = await dio.get('/users/create');
      //  print(response.data.toString());
// Optionally the request above could also be done as

      var formData = eos.FormData.fromMap({
        'email': email?.trim(),
      });

      var response =
          await dio.post(baseUrl + 'users/forgotPassword', data: formData);

      print(response.data.toString());
      var data = jsonDecode(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data["code"] == 0) {
          //network or server error

          return "An error occured!";
        } else if (data["code"] == 1) {
          Hive.box("statup").put("email", email?.trim());
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

  Future<dynamic> changePassword({
    @required String? password,
    @required String? email,
    @required String? code,
  }) async {
    try {
      //eos.Response response;
      var dio = eos.Dio();
      //  response = await dio.get('/users/create');
      //  print(response.data.toString());
// Optionally the request above could also be done as

      var formData = eos.FormData.fromMap({
        'email': email!.trim(),
        'password': password!.trim(),
        'code': code!.trim(),
      });

      var response =
          await dio.post(baseUrl + 'users/updatePassword', data: formData);

      print(response.data.toString());
      var data = jsonDecode(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data["code"] == 0) {
          //network or server error

          return "An error occured!";
        } else if (data["code"] == 1) {
          print(data["data"].toString());
          Hive.box("statup").put("access_token", data["data"]["access_token"]);
          Hive.box("statup").put("first_name", data["data"]["first_name"]);
          Hive.box("statup").put("last_name", data["data"]["last_name"]);
          Hive.box("statup").put("email", data["data"]["email"]);
          Hive.box("statup").put("phone", data["data"]["phone"]);
          Hive.box("statup").put("acc_name", data["data"]["account_name"]);
          Hive.box("statup").put("id", data["data"]["id"]);
          Hive.box("statup").put("acc_num", data["data"]["account_num"]);
          Hive.box("statup")
              .put("profile_image", data["data"]["profile_picture"]);
          Hive.box("statup").put("bank", data["data"]["bank"]);
          Hive.box("statup").put("loggedIn", true);

          print("logged In successfully!");
          Hive.box("statup").put("businesses", data["data"]["businesses"]);
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

  Future<dynamic> editPassword({
    @required String? new_password,
    @required String? old_password,
  }) async {
    try {
      //eos.Response response;
      var dio = eos.Dio();
      //  response = await dio.get('/users/create');
      //  print(response.data.toString());
// Optionally the request above could also be done as

      var formData = eos.FormData.fromMap({
        'new_password': new_password!.trim(),
        'old_password': old_password!.trim(),
        'user_id': Hive.box("statup").get("id"),
      });

      var response =
          await dio.post(baseUrl + 'users/changePassword', data: formData);

      print(response.data.toString());
      var data = jsonDecode(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data["code"] == 0) {
          //network or server error

          return "An error occured!";
        } else if (data["code"] == 1) {
          return 1;
        } else if (data["code"] == 2) {
          return 2;
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

  Future<dynamic> editPasscode({
    @required String? password,
    @required String? new_pin,
  }) async {
    try {
      //eos.Response response;
      var dio = eos.Dio();
      //  response = await dio.get('/users/create');
      //  print(response.data.toString());
// Optionally the request above could also be done as

      var formData = eos.FormData.fromMap({
        'password': password!.trim(),
        'new_pin': new_pin!.trim(),
        'user_id': Hive.box("statup").get("id"),
      });

      var response =
          await dio.post(baseUrl + 'users/changePin', data: formData);

      print(response.data.toString());
      var data = jsonDecode(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data["code"] == 0) {
          //network or server error

          return "An error occured!";
        } else if (data["code"] == 1) {
          return 1;
        } else if (data["code"] == 2) {
          return 2;
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
