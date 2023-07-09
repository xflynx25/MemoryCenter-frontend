import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';
import 'user.dart';

class UserService {
  Future<List<User>> getAllUsers() async {
    var url = Uri.parse('${Config.HOST}/api/get_all_users/');
    var prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString('accessToken');

    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<User> users = [];
      for (var user in data['all_users']) {
        users.add(User.fromJson(user));
      }
      return users;
    } else {
      throw Exception('Failed to load users');
    }
  }
}
