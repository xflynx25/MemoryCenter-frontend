import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';
import 'topic.dart';

class TopicService {
  Future<List<Topic>> getAllTopics(int userId) async {
    var url = Uri.parse('${Config.HOST}/api/get_all_topics/');
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
      List<Topic> topics = [];
      for (var topic in data) {
        topics.add(Topic.fromJson(topic));
      }
      return topics;
    } else {
      throw Exception('Failed to load topics');
    }
  }
}
