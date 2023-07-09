import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';
import 'collection.dart';

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


}

