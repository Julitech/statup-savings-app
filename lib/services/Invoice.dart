import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:dio/dio.dart' as eos;

class Invoice {
  static String baseUrl = "https://statup.ng/statup/index.php/";

  Future<dynamic> NewInvoice(
      {@required String? invoice_date,
      @required String? invoice_number,
      @required String? customer_name,
      @required String? customer_phone,
      @required String? customer_address,
      @required String? product_name,
      @required String? product_price,
      @required String? unit,
      @required String? qty,
      @required bool? add_logo,
      @required bool? add_bank,
      @required bool? add_signature,
      @required String? business_id}) async {
    try {
      //eos.Response response;
      var dio = eos.Dio();
      //  response = await dio.get('/users/create');
      //  print(response.data.toString());
// Optionally the request above could also be done as

      var formData = eos.FormData.fromMap({
        'invoice_date': invoice_date,
        'invoice_number': invoice_number,
        'customer_name': customer_name,
        'customer_phone': customer_phone,
        'customer_address': customer_address,
        'product_name': product_name,
        'product_price': product_price,
        'unit': unit,
        'qty': qty,
        'add_logo': add_logo == true ? 1 : 0,
        'add_signature': add_signature == true ? 1 : 0,
        'add_bank': add_bank == true ? 1 : 0,
        'business_id': business_id
      });

      var response = await dio.post(baseUrl + 'invoice/saveinvoice',
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
          // Hive.box("statup").put("savings", data['savings_plans']);
          //  Hive.box("statup").put("userID", data['id']);

          print(data["data"]);
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

  Future<dynamic> newBusiness({
    @required String? business_name,
    @required String? category,
    @required String? location,
    @required String? phone,
    @required String? bank,
    @required String? account_name,
    @required String? account_num,
    File? logo,
    File? signature,
  }) async {
    try {
      //eos.Response response;
      var dio = eos.Dio();
      //  response = await dio.get('/users/create');
      //  print(response.data.toString());
// Optionally the request above could also be done as

      var formData = eos.FormData.fromMap({
        'business_name': business_name,
        'category': category,
        'location': location,
        'phone': phone,
        'bank': bank,
        'account_name': account_name,
        'account_num': account_num,
      });

      if (logo != null && signature != null) {
        List<File> temp = [];
        List<File> mainMediaHolder = [];

        mainMediaHolder.add(logo);
        mainMediaHolder.add(signature);

        int c = 0;
        for (File item in mainMediaHolder) {
          formData.files.addAll([
            MapEntry("files" + c.toString(),
                await eos.MultipartFile.fromFile(item.path)),
          ]);
          c++;
        }
      }

      var response = await dio.post(baseUrl + 'invoice/newBusiness',
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
          //  Hive.box("statup").put("savings", data['savings_plans']);
          Hive.box("statup").put("businesses", data['data']);
          Hive.box("statup").put("business_id", data['data']['id']);
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
