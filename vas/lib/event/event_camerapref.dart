import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vas/models/camera.dart';
import 'package:vas/models/users.dart';

class CameraPref {

  static Future<void> saveCamera(Camera camera) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String cameraJson = jsonEncode(camera.toJson());
    await pref.setString('camera', cameraJson);
  }

  static Future<Camera?> getCamera() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? cameraJson = pref.getString('camera');

      if (cameraJson != null && cameraJson.isNotEmpty) {
        Map<String, dynamic> mapCamera = jsonDecode(cameraJson);
        return Camera.fromJson(mapCamera);
      }
    } catch (e) {
      print('Error retrieving credential from SharedPreferences: $e');
    }
  }

  static Future<void> clearSpecificPreference(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static void clearCameraPreference() async {
    await clearSpecificPreference('camera');
    print('Camera preference cleared');
  }
}
