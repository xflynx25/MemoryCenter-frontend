import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/topic.dart';
import '../models/editing_item.dart';
import '../widgets/topic_editor.dart';
import '../utils/config.dart';

class EditTopicPage0 extends StatefulWidget {
  final Topic topic;

  EditTopicPage0({required this.topic});

  @override
  _EditTopicPage0State createState() => _EditTopicPage0State();
}

class _EditTopicPage0State extends State<EditTopicPage0> {
  late List<EditingItem> items;
  late List<TextEditingController> frontControllers;
  late List<TextEditingController> backControllers;
  var _isSubmitting = false;
  var _showSuccess = false;
  var _showError = false;

  @override
  void initState() {
    super.initState();
    items = widget.topic.items
        .map((item) => EditingItem(id: item.id, front: item.front, back: item.back))
        .toList();
    frontControllers = items.map((item) => TextEditingController(text: item.front)).toList();
    backControllers = items.map((item) => TextEditingController(text: item.back)).toList();
    addItems(Config.EDIT_TOPIC_0_BLANK_ITEMS);
  }

  void addItems(int count) {
    setState(() {
      for (var i = 0; i < count; i++) {
        items.add(EditingItem(id: -1, front: '', back: ''));
        frontControllers.add(TextEditingController());
        backControllers.add(TextEditingController());
      }
    });
  }

  Future<void> submitChanges() async {
    setState(() {
      _isSubmitting = true;
      _showSuccess = false;
      _showError = false;
    });

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
        "topic_id": widget.topic.id,
        "items": items.map((item) => {
          "id": item.id,
          "front": item.front,
          "back": item.back
        }).toList()
      }),
    );

    if (response.statusCode == 200) {
        _showSuccess = true;

        // Fetch the updated items
        fetchUpdatedItems(accessToken);
    } else {
        _showError = true;
    }

    setState(() {
      _isSubmitting = false;
    });
  }

  Future<void> fetchUpdatedItems(String accessToken) async {
      var response = await http.get(
        Uri.parse('${Config.HOST}/api/get_topic_items/${widget.topic.id}/'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 200) {
          var responseBody = json.decode(utf8.decode(response.bodyBytes));
          var updatedItems = responseBody["items"];
          setState(() {
              // Update items based on the server response
              items = updatedItems.map(
                  (item) => EditingItem(id: item["id"], front: item["front"], back: item["back"])
              ).toList();
          });
      }
  }


void addMoreItems() {
  addItems(Config.EDIT_TOPIC_0_BLANK_ITEMS);
}

@override
Widget build(BuildContext context) {
  return TopicEditor(
    topic: widget.topic,
    child: Center(
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Spacer(flex: 1),
                Expanded(
                  flex: 8,
                  child: ElevatedButton(
                    child: const Text('Submit changes', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80),
                      ),
                    ),
                    onPressed: _isSubmitting ? null : submitChanges,
                  ),
                ),
                Spacer(flex: 1),
                if (_showSuccess) Icon(Icons.check_circle, color: Colors.green),
                if (_showError) Icon(Icons.error, color: Colors.red),
                Spacer(flex: 8),
                Expanded(
                  flex: 8,
                  child: ElevatedButton(
                    child: Text('Add ${Config.EDIT_TOPIC_0_BLANK_ITEMS} more blanks'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80),
                      ),
                    ),
                    onPressed: addMoreItems,
                  ),
                ),
                Spacer(flex: 1),
              ],
            ),
          ),
          // 70% width for text table
          Expanded(
            flex: 7,
            child: FractionallySizedBox(
              widthFactor: 0.9, // Controls the width
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: const EdgeInsets.all(6.0), // Smaller margin
                          padding: const EdgeInsets.all(6.0), // Smaller padding
                          decoration: BoxDecoration(
                            color: Colors.grey[200], // Change this color to your preference
                            border: Border.all(color: Colors.grey[500]!), // Change this color to your preference
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Row(
                            children: <Widget>[
                              Text(
                                '${index+1}.',
                                style: const TextStyle(
                                  fontSize: 16.0, // Smaller font size
                                  color: Colors.black, // Change this color to your preference
                                ),
                              ),
                              SizedBox(width: 6), // Smaller spacing
                              Expanded(
                                child: TextField(
                                  controller: frontControllers[index],
                                  onChanged: (value) {
                                    setState(() {
                                      items[index].front = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0), // Smaller padding
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white, // Change this color to your preference
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),  // Smaller spacing
                              Expanded(
                                child: TextField(
                                  controller: backControllers[index],
                                  onChanged: (value) {
                                    setState(() {
                                      items[index].back = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0), // Smaller padding
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white, // Change this color to your preference
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red), // Keep this color as red
                                onPressed: () {
                                  setState(() {
                                    items.removeAt(index);
                                    frontControllers.removeAt(index);
                                    backControllers.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}}

