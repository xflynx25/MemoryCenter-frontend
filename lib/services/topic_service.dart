import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/config.dart';
import '../models/topic.dart';
import '../models/item.dart';

class TopicService {
  Future<List<Topic>> getAllTopics(int userId) async {
    var url = Uri.parse('${Config.HOST}/api/get_all_topics/$userId/');
    
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

  Future<List<Item>> getAllItems(int topicId) async {
    var url = Uri.parse('${Config.HOST}/api/get_all_items/$topicId/');

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
      List<Item> items = [];
      for (var item in data) {
        items.add(Item.fromJson(item));
      }
      return items;
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<bool> createTopic(String topicName, String description, String visibility) async {
    var url = Uri.parse('${Config.HOST}/api/create_topic/');

    var prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString('accessToken');

    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode(<String, String>{
        'topic_name': topicName,
        'description': description,
        'visibility': visibility,
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
}

Future<bool> deleteTopic(int topicId) async {
    var url = Uri.parse('${Config.HOST}/api/delete_topic/');

    var prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString('accessToken');

    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode(<String, int>{
        'topic_id': topicId,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}