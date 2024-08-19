import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vas/models/credential.dart';
import 'package:vas/models/users.dart';

class EventPref {

  static Future<void> saveCredential(Credential credential) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String credentialJson = jsonEncode(credential.toJson());
    await pref.setString('credential', credentialJson);
  }

  static Future<Credential?> getCredential() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? credentialJson = pref.getString('credential');

      if (credentialJson != null && credentialJson.isNotEmpty) {
        Map<String, dynamic> mapCredential = jsonDecode(credentialJson);
        return Credential.fromJson(mapCredential);
      }
    } catch (e) {
      print('Error retrieving credential from SharedPreferences: $e');
    }
  }

  static Future<void> clear() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
  }
}
