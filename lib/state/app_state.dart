import '../models/user.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserState {
  User? currentUser;

  Future<void> initUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userJson = prefs.getString('user');
    if (userJson != null) {
      currentUser = User.fromJson(jsonDecode(userJson));
    }
  }

  // Other methods related to user state could go here.
}
