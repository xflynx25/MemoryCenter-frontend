import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/config.dart';
import '../models/collection.dart';


class AuthResult {
  final bool success;
  final String errorMessage;

  AuthResult(this.success, {this.errorMessage = ''});
}


class AuthService with ChangeNotifier {

  Future<AuthResult> login(String username, String password) async {
  var url = Uri.parse('${Config.HOST}/api/login/');
  try {
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({'username': username, 'password': password}),
    );

    var data = json.decode(response.body);
    if (response.statusCode == 200 && data['status'] == 'success') {
      var prefs = await SharedPreferences.getInstance();
      prefs.setString('accessToken', data['access']);
      prefs.setString('refreshToken', data['refresh']);
      prefs.setInt('loggedInUserId', data['user_id']); // Assuming user_id is an integer

      return AuthResult(true);
    } else {
      // Handle the error message from the response if any
      return AuthResult(false, errorMessage: data['error'] ?? 'Unknown error');
    }
  } catch (e) {
    // Handle the exception and log or show an appropriate message
    debugPrint('Error: $e');
    return AuthResult(false, errorMessage: e.toString());
  }
}

Future<AuthResult> register(String username, String password, String secretMessage) async {
  var url = Uri.parse('${Config.HOST}/api/register/');
  try {
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({'username': username, 'password': password, 'secret_message': secretMessage}), // Include the secret message
    );

    var data = json.decode(response.body);
    if (response.statusCode == 201 && data['status'] == 'success') {
      
      var prefs = await SharedPreferences.getInstance();
      prefs.setString('accessToken', data['access']);
      prefs.setString('refreshToken', data['refresh']);
      prefs.setInt('loggedInUserId', data['user_id']); // Assuming user_id is an integer
      return AuthResult(true);
    } else {
      // Handle the error message from the response if any
      return AuthResult(false, errorMessage: data['error'] ?? 'Unknown error');
    }
  } catch (e) {
    // Handle the exception and log or show an appropriate message
    debugPrint('Error: $e');
    return AuthResult(false, errorMessage: e.toString());
  }
}




  Future<List<Collection>> getCollections() async {
    var url = Uri.parse('${Config.HOST}/api/get_all_collections/');
    var prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString('accessToken');

    var response = await http.get(
      url, 
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken"
      }
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Collection.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load collections');
    }
  }


  Future<void> logout() async {
    // Clear user data from shared preferences or any other local storage
    var prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
    await prefs.remove('loggedInUserId'); // Clear the user ID

    // Perform any other cleanup tasks here, like invalidating tokens on the server if necessary

    // Notify any listeners that the user has logged out
    notifyListeners();
  }

}
