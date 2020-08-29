import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:loan_manager/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Function> setLoginInformation(User user) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  AppUser loggedUser = new AppUser(user.displayName, user.email, user.uid);
  prefs.setString('user', jsonEncode(loggedUser));
}

Future<Function> removeLoginInformation() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
}

// Future<User> get getLoginInformation async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   final user = prefs.getString('user');

//   if (user != null) {
//     return User.fromJson(jsonDecode(user));
//   }

//   return new User(null, null, null);
// }
