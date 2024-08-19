import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:vas/event/event_pref.dart';
import 'package:vas/models/credential.dart';
import 'package:vas/models/module.dart';
import 'package:vas/models/quota.dart';
import 'package:vas/models/users.dart';
import 'package:vas/screens/auth/change_password.dart';
import 'package:vas/screens/auth/login.dart';
import 'package:vas/screens/pages/dashboard.dart';
import 'package:vas/services/api.dart';
import 'package:get/get.dart';

class EventDB {
  static Future<Credential?> getlogin(String email, String password) async {
    Credential? dataToken;
    try {
      var response = await http.post(Uri.parse(Api.login), body: {
        'email': email,
        'password': password,
      });

      var responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseBody['status'] == 'success') {
          var data = responseBody['data'];

          if (data != null) {
            try {
              Credential credential = Credential(
                email: email,
                password: password,
                data: Data.fromJson(data),
              );

              // Menyimpan credential
              await EventPref.saveCredential(credential);
              dataToken = credential;
              print(responseBody['data']);
            } catch (e) {
              print('Error parsing data item: $e');
            }
          } else {
            print("Data is null or invalid");
          }
        } else {
          print('Unexpected status: ${responseBody['status']}');
        }
      } else {
        print('Error: ${responseBody['error']}');
      }
    } catch (e, stacktrace) {
      print('Error occurred: $e');
      print('Stacktrace: $stacktrace');
    }
    return dataToken;
  }

  static Future<String?> ForgotPassword(String email) async {

    String? data;
    try {
      var response = await http.put(Uri.parse(Api.forget_password).replace(
        queryParameters: {
          'email': email,
        }
      ));

      var responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print(responseBody['status']);
        print(responseBody['data']);
        data = "not null";
      }
    } catch (e) {
      print(e);
    }

    return data;
  }

  static Future<void> ChangePassword(String password, String token) async {

    try {
      var response = await http.put(Uri.parse(Api.change_password), body: {
        'newPassword': password,
        'token': token
      });

      var responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print(responseBody['status']);
        print(responseBody['data']);
        Future.delayed(Duration(seconds: 2), () {
          Get.off(Login());
        });
      } else {
        print("Post success, but change password failed.");
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<User?> getUser(String token, String email, String password) async {
    User? user;
    int count = 0;

    while(count < 2){
      try {
        var response = await http.get(Uri.parse(Api.get_user), headers: {
          'token': token
        });

        var responseBody = jsonDecode(response.body);
        if (responseBody != null && responseBody['data'] != null) {
          user = User.fromJson(responseBody['data']);
        } else {
          print("Data is null or invalid");
        }
      } catch(e) {
        print("S: $e");
      }

      if(user == null){
        EventPref.clear();
        getlogin(email, password);

        count++;
      } else {
        break;
      }
    }
    return user;
  }

  static Future<Quota?> getQuota(String token, String targetId) async {
    Quota? specificQuota;
    int count = 1;

    while (count <= 3) {
      try {
        var response = await http.get(Uri.parse(Api.check_quota), headers: {
          'token': token,
        });

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseBody = jsonDecode(response.body);

          // Check if the status is 'success'
          if (responseBody['status'] == 'success') {
            // Extract the 'data' list
            List<dynamic> dataList = responseBody['data'];

            // Find the Datum with the specific ID
            Map<String, dynamic>? datumJson = dataList.firstWhere(
                  (datum) => datum['id'] == targetId,
              orElse: () => null,
            );

            if (datumJson != null) {
              // Create a Quota instance from the JSON
              specificQuota = Quota.fromJson(datumJson);
              print('Quota with ID $targetId fetched: ${specificQuota.toJson()}');
              print(token);
              break; // Exit the loop if successful
            } else {
              print('Datum with ID $targetId not found.');
            }
          } else {
            print('Unexpected status: ${responseBody['status']}');
          }
        } else {
          print('Failed to load data: ${response.statusCode}');
        }
      } catch (e, stacktrace) {
        print('Error occurred: $e');
        print('Stacktrace: $stacktrace');
      }

      if (specificQuota != null) {
        break;
      } else {
        print('Retrying... ($count)');
        print("Token: $token");
        count++;
      }
    }

    return specificQuota;
  }


  static Future<ModuleData?> getModule(String token) async {
    ModuleData? module;
    try {
      var response = await http.get(Uri.parse(Api.get_module), headers: {
        'token': token,
      });

      var responseBody = jsonDecode(response.body);
      if (responseBody != null && responseBody['data'] != null) {
        module = ModuleData.fromJson(responseBody['data']);
        print("success");
      } else {
        print("Data is null or invalid");
      }

    } catch(e) {
      print('Status: $e');
    }

    return module;
  }

  static Future<void> LogOut() async {
    EventPref.clear();
    Future.delayed(Duration(seconds: 2), () {
      Get.off(Login());
    });
  }
}
