import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/config.dart';
import '../models/collection.dart';


class CollectionService {
  Future<List<Collection>> getAllCollections(int userId) async {
    var url = Uri.parse('${Config.HOST}/api/get_all_collections/$userId/');
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
      List<Collection> collections = [];
      for (var collection in data) {
        collections.add(Collection.fromJson(collection));
      }
      return collections;
    } else {
      throw Exception('Failed to load collections');
    }
  }
  
  Future<bool> createCollection(String collectionName, String description, String visibility) async {
    var url = Uri.parse('${Config.HOST}/api/create_collection/');

    var prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString('accessToken');

    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode(<String, String>{
        'collection_name': collectionName,
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
}