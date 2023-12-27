import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/config.dart';
import '../models/item.dart';
import '../models/editing_item.dart';

class ItemService {
  Future<Map<String, dynamic>> editItemsInTopic(int topicId, List<EditingItem> items) async {
    var url = Uri.parse('${Config.HOST}/api/edit_items_in_topic_full/');
    var prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString('accessToken') ?? '';

    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: json.encode({
        "topic_id": topicId,
        "items": items.map((item) {
          return {
            "id": item.id,
            "front": item.front,
            "back": item.back
          };
        }).toList(),
      }),
    );

        if (response.statusCode == 200) {
            return {"success": true};
            } else {
            return {"success": false, "message": response.body};
            }
  }

  Future<List<EditingItem>> getItems(int topicId) async {
    var url = Uri.parse('${Config.HOST}/api/get_topic_items/$topicId/');
    var prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString('accessToken') ?? '';

    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<EditingItem> items = [];
      for (var item in data['items']) {
        items.add(EditingItem.fromJson(item));
      }
      return items;
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<Map<String, dynamic>> addItemsToTopic(int topicId, List<List<String>> items) async {
    var url = Uri.parse('${Config.HOST}/api/add_items_to_topic/');
    var prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString('accessToken') ?? '';

    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: json.encode({
        "topic_id": topicId,
        "items": items,
      }),
    );


    if (response.statusCode == 200) {
        return {"success": true};
        } else {
        return {"success": false, "message": response.body};
        }
  }

  // Other methods like addItemsToTopic, deleteItem etc. can be added here.
}
