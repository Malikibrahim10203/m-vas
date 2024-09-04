import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:vas/event/event_pref.dart';
import 'package:vas/models/credential.dart';
import 'package:vas/models/district.dart';
import 'package:vas/models/module.dart';
import 'package:vas/models/office.dart';
import 'package:vas/models/peruri_jwt_token.dart';
import 'package:vas/models/quota.dart';
import 'package:vas/models/province.dart';
import 'package:vas/models/users.dart';
import 'package:vas/screens/auth/change_password.dart';
import 'package:vas/screens/auth/login.dart';
import 'package:vas/screens/pages/dashboard.dart';
import 'package:vas/services/api.dart';
import 'package:get/get.dart';
import 'package:vas/widgets/components.dart';

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

    try {
      var response = await http.get(
        Uri.parse(Api.get_user),
        headers: {'token': token},
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody != null && responseBody['data'] != null) {
          user = User.fromJson(responseBody['data']);
          print(user.firstName);
        } else {
          print("Get User: Data is null or invalid");
        }
      } else {
        print("Get User: Status Code ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    }


    return user;
  }

  static Future<Quota?> getQuota(String token, String targetId) async {
    Quota? specificQuota;
    int count = 1;

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

  static Future<bool> RegisterPeruri(String token, String token_peruri, String password, Map<dynamic, dynamic>? data) async {
    bool status = false;
    try {
      var response = await http.post(
        Uri.parse(Api.regist_peruri),
        headers: {
          'token': token,
          'token_peruri_sign': token_peruri,
        },
        body: {
          'address': data?['address'] ?? '',
          'date_of_birth': data?['dateOfBirth'] ?? '',
          'district': data?['district'].toString() ?? '',
          'gender': data?['gender'] ?? '',
          'ktp': (data?['nik'] ?? '').toString(),
          'ktp_photo': data?['ktp_photo'] ?? '',
          'npwp': (data?['npwp'] ?? '').toString(),
          'npwp_photo': data?['npwp_photo'] ?? '',
          'organization_unit': data?['departement'] ?? '',
          'password': password,
          'place_of_birth': data?['placeOfBirth'] ?? '',
          'position': data?['role'] ?? '',
          'province': data?['province'].toString() ?? '',
          'rt': (data?['rt'] ?? '').toString(),
          'rw': (data?['rw'] ?? '').toString(),
          'self_photo': data?['selfie_photo'] ?? '',
          'sub_district': '',
          'village': data?['village'] ?? '',
          'work_unit': data?['office'] ?? '',
        },
      );


      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if(responseBody['status'] == 'success') {
          status = true;
          print('Success: ${response.body}');
        }
      } else {
        print('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
    return status;
  }





  static Future<PeruriJwtToken?> getPeruriJWTToken(String token) async {
    PeruriJwtToken? tokenPeruri;

    try {
      var response = await http.get(Uri.parse(Api.get_peruri_jwt_token), headers: {
        'token': token
      });

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody != null && responseBody['data'] != null) {
          tokenPeruri = PeruriJwtToken.fromJson(responseBody['data']);
          print(tokenPeruri.expireAt);
        } else {
          print("Data is null or invalid");
        }
      } else {
        print("Data is null or invalid");
      }
    } catch(e) {
      print("Peruri JWT Token : $e");
    }

    return tokenPeruri;
  }

  static Future<void> check(Map? data) async {

    // print(data!['firstName']);
    // print(data!['lastName']);
    // print(data!['phoneNumber']);
    // print();
    // print();
    // print();
    // print();
    // print();
    // print();
    // print();
    // print();
    // print();
    // print();
    // print();
    // print();
    // print();
    // print();
    // print();
    // print();
    // print();
  }

  static Future<List<Office>?> getOffice(String token) async {
    List<Office>? office;
    try {
      var response = await http.get(Uri.parse(Api.get_office), headers: {
        'token': token
      });

      if(response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);

        if(responseBody['data'] != null && responseBody['data'] is List) {
          var officeDataList = List<Map<String, dynamic>>.from(responseBody['data']);
          office = officeDataList.map((data)=>Office.fromJson(data)).toList();
        } else {
          print("Office data is not a list or is missing.");
        }
      } else {
        print("Failed to load office. Status code: ${response.statusCode}");
      }
    } catch(e) {
      print("Error fetching office: $e");
    }

    return office;
  }

  static Future<List<Province>?> getProvinces() async {
    List<Province>? regions;

    try {
      var response = await http.get(Uri.parse(Api.get_region));

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);

        print("Response Body: $responseBody");

        // Ensure that 'region' is a list
        if (responseBody['data'] != null && responseBody['data'] is List) {
          var regionDataList = List<Map<String, dynamic>>.from(responseBody['data']);
          regions = regionDataList.map((data) => Province.fromJson(data)).toList();
        } else {
          print("Region data is not a list or is missing.");
        }
      } else {
        print("Failed to load regions. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching regions province: $e");
    }

    return regions;
  }

  static Future<List<District>?> getDistrict(int? province_id) async {
   List<District>? regions;

   if (province_id == null) {
     throw ArgumentError('provinceId cannot be null');
   }

   try {
     var response = await http.get(Uri.parse(Api.get_region).replace(
       queryParameters: {
        'province_id': province_id.toString()
       }
     ));

     if(response.statusCode == 200) {
       var responseBody = jsonDecode(response.body);

       if(responseBody['data'] != null && responseBody['data'] is List) {
         var regionDataList = List<Map<String, dynamic>>.from(responseBody['data']);
         regions = regionDataList.map((data)=>District.fromJson(data)).toList();
       } else {
         print("Region data is not list or is missing.");
       }
     } else {
       print("Failed to load regions. Status code: ${response.statusCode}");
     }
   } catch(e) {
     print("Error fetching regions district: $e");
   }

   return regions;
  }

  static Future<String>? SendOtp(String? token, String? tokenPeruri) async {
    String? responseOtp;
    try {
      var response = await http.post(Uri.parse(Api.send_otp), headers: {
        'token': token??'',
        'token_peruri_sign': tokenPeruri??''
      });
      var responseBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        responseOtp = responseBody['status'];
      } else {
        responseOtp = responseBody['error'];
      }
    } catch (e) {
      print("Send otp: $e");
    }
    return responseOtp!;
  }

  static Future<String>? ActivateEmail(String tokenLogin, String tokenEmail) async {
    String? responseActivateEmail;
    try {
      var response = await http.post(Uri.parse(Api.activate_email), headers: {
        'token': tokenLogin
      },
      body: {
        'token': tokenEmail
      });
      var responseBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        responseActivateEmail = responseBody['error'];
      } else {
        responseActivateEmail = responseBody['error'];
      }
    } catch (e) {
      print("Send otp: $e");
    }
    return responseActivateEmail!;
  }

  static Future<String>? ResendActivateEmail(String tokenLogin) async {
    String? responseResendActivateEmail;
    try {
      var response = await http.post(Uri.parse(Api.resend_activate_email), headers: {
        'token': tokenLogin
      });

      var responseBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        responseResendActivateEmail = responseBody['status'];
      } else {
        responseResendActivateEmail = responseBody['error'];
      }
    } catch (e) {
      print("Resend Activate Email: $e");
    }
    return responseResendActivateEmail!;
  }

  static Future<String>? CheckOtp(String token, String tokenPeruri, String otp) async {
    String? responseOtp;
    try {
      var response = await http.post(Uri.parse(Api.check_otp),
        headers: {
          'token': token,
          'token_peruri_sign': tokenPeruri
        },
        body: {
          'otp': otp
        }
      );

      var responseBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        responseOtp = responseBody['status'];
      } else {
        responseOtp = responseBody['status'];
      }
    } catch (e) {
      print("Check Otp otp: $e");
    }
    return responseOtp!;
  }

  static Future<String>? VideoKyc(String token, String tokenPeruri, String videoBase64, String otp) async {

    String? messageResponse;

    try {
      var response = await http.post(Uri.parse(Api.regist_video_kyc),
      headers: {
        'token_peruri_sign': tokenPeruri,
        'token': token,
      },
      body: {
        'base64Vid': videoBase64,
        'otp': otp
      });

      var responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        messageResponse = responseBody['status'];
      } else {
        messageResponse = responseBody['status'];
      }
    } catch (e) {
      print("Regist eKyc Video: $e");
    }

    return messageResponse!;
  }

  static Future<List> UploadDocSingle(String token, String docName, String officeId, String description, List<Map<String, dynamic>> tags, String date, String filePath) async {
    List data = [false, ""];
    try {

      File file = File(filePath);

      var request = http.MultipartRequest('POST', Uri.parse(Api.upload_single));

      request.headers['Content-Type'] = 'multipart/form-data';
      // request.headers['token'] = token;

      request.fields['doc_name'] = docName;
      request.fields['office_id'] = officeId;
      request.fields['description'] = description;
      request.fields['tags'] = jsonEncode(tags);
      request.fields['date'] = date;

      request.files.add(
        http.MultipartFile(
          'file',
          file.readAsBytes().asStream(),
          file.lengthSync(),
          filename: filePath.split("/").last,
          contentType: MediaType('application', 'pdf'),
        ),
      );


      var response = await request.send();

      if (response.statusCode == 200 && response.statusCode == 201) {
        print("File uploaded successfully");
        data[0] = true;
      } else {
        var responseBody = await http.Response.fromStream(response);
        var error = jsonDecode(responseBody.body);
        print("File upload failed with status: ${response.statusCode}, body: ${responseBody.body}");
        data[1] = error['error'];
      }
    } catch (e) {
      print("Error Fetch Upload Single: $e");
    }

    return data;
  }
  static Future<List> UploadDocBulk(String token, String docName, String officeId, String description, List<Map<String, dynamic>> tags, String date, List fileBulk) async {
    List data = [false, ""];
    try {

      var request = http.MultipartRequest('POST', Uri.parse(Api.upload_bulk));

      request.headers['Content-Type'] = 'multipart/form-data';
      // request.headers['token'] = token;

      request.fields['folder_name'] = docName;
      request.fields['office_id'] = officeId;
      request.fields['description'] = description;
      request.fields['tags'] = jsonEncode(tags);
      request.fields['date'] = date;


      for(File file in fileBulk) {
        String filePath = file.path;
        request.files.add(
          http.MultipartFile(
            'docs',
            file.readAsBytes().asStream(),
            file.lengthSync(),
            filename: filePath.split("/").last,
            contentType: MediaType('application', 'pdf'),
          )
        );
      }

      var response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("File uploaded successfully");
        data[0] = true;
      } else {
        var responseBody = await http.Response.fromStream(response);
        var error = jsonDecode(responseBody.body);
        print("File upload failed with status: ${response.statusCode}, body: ${responseBody.body}");
        data[1] = error['error'];
      }
    } catch (e) {
      print("Error Fetch Upload Single: $e");
    }

    return data;
  }





  static Future<void> LogOut() async {
    EventPref.clear();
    Future.delayed(Duration(seconds: 2), () {
      Get.off(Login());
    });
  }
}
