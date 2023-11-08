import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

// Assuming this function is called after a successful login where `user` is the logged-in User object.
void saveUserToSharedPreferences(User user) async {
  final prefs = await SharedPreferences.getInstance();
  final String userJson = jsonEncode(user.toJson()); // Convert user to JSON string
  await prefs.setString('user', userJson); // Store JSON string in shared prefs
}
