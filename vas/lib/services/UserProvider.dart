import 'package:flutter/material.dart';
import 'package:vas/event/event_db.dart';
import 'package:vas/event/event_pref.dart';
import 'package:vas/models/users.dart';

class Userprovider extends ChangeNotifier {
  User? _user;

  User? get user => _user;


  Future<void> fetchUser(String token, String email, String password) async {
    try {
      User? fetchedUser = await EventDB.getUser(token, email, password);
      _user = fetchedUser;
    } catch (e) {
      print("Error fetching user: $e");
    }
    notifyListeners();
  }

  Future<void> tryLogin() async {
    try {
      String? email = (await EventPref.getCredential())?.email;
      String? password = (await EventPref.getCredential())?.password;

      await EventDB.getlogin(email ?? '', password ?? '');

      String? token = (await EventPref.getCredential())?.data.token;

      User? fetchedUser = await EventDB.getUser(token ?? '', email ?? '', password ?? '');
      _user = fetchedUser;

      notifyListeners();
    } catch (e) {
      print("Error retrying login: $e");
    }
  }
}
