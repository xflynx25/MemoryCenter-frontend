import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/config.dart';

class ScoreService {
  Future<Map<String, dynamic>> updateScores(List<Map<String, int>> scores) async {
    var url = Uri.parse('${Config.HOST}/api/update_n_items_user/');

    var prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString('accessToken');

    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode({'items': scores}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update scores');
    }
  }
}
