import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';

class AuthService with ChangeNotifier {
  Future<bool> register(String username, String password) async {
    var url = Uri.parse('${Config.HOST}/api/register/');
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({'username': username, 'password': password}),
    );

    if (response.statusCode == 201) {
      return true;
    }

    return false;
  }

  Future<bool> login(String username, String password) async {
    var url = Uri.parse('${Config.HOST}/api/login/');
    var response = await http.post(
      url, 
      headers: {"Content-Type": "application/json"},
      body: json.encode({'username': username, 'password': password})
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var prefs = await SharedPreferences.getInstance();
      prefs.setString('accessToken', data['access']);
      prefs.setString('refreshToken', data['refresh']);
      return true;
    }

    return false;
  }

  Future<String> getHomeData() async {
    var url = Uri.parse('${Config.HOST}/api/home/');
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('accessToken');
    var response = await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return 'WELCOME USER ${data['username']}, YOUR CAREFULLY CHOSEN PASSWORD HASHES TO ${data['password']}';
    }

    return 'Error: ${response.body}';
  }
}
