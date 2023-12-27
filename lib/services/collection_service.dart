import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/config.dart';
import '../models/collection.dart';
import '../models/card_item.dart';
import 'package:http/http.dart' as http;



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

  Future<http.Response> createCollection(String collectionName, String description, String visibility) async {
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

    return response;
  }

Future<bool> deleteCollection(int collectionId) async {
    var url = Uri.parse('${Config.HOST}/api/delete_collection/');

    var prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString('accessToken');

    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode(<String, int>{
        'collection_id': collectionId,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

Future<List<CardItem>> fetchNFromCollection(int collectionId, int n) async {
  var url = Uri.parse('${Config.HOST}/api/fetch_n_from_collection/?collection_id=$collectionId&n=$n');

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
    List<dynamic> body = json.decode(response.body);
    return body.map((dynamic item) => CardItem.fromJson(item)).toList();
  } else if (response.statusCode == 405){
    throw Exception('No More Items');
    }else {
    throw Exception('Failed to fetch card items');
  }
}
}