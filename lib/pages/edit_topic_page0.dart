import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../services/item_service.dart';
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

  ItemService itemService = ItemService();
  var result = await itemService.editItemsInTopic(widget.topic.id, items);

  if (result['success']) {
    _showSuccess = true;
    fetchUpdatedItems();
  } else {
    _showError = true;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${result['message']}')),
    );
  }

  setState(() {
    _isSubmitting = false;
  });
}

Future<void> fetchUpdatedItems() async {
  ItemService itemService = ItemService();
  try {
    var updatedItems = await itemService.getItems(widget.topic.id);
    setState(() {
      items = updatedItems;
    });
  } catch (e) {
    // Handle exception
  }
}


void addMoreItems() {
  addItems(Config.EDIT_TOPIC_0_BLANK_ITEMS);
}

@override
Widget build(BuildContext context) {
  return TopicEditor(
    topic: widget.topic,
    child: Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "If this page isn't updating properly after using a different editing method, please return to the profile page and come back. We apologize for the inconvenience.",
            style: TextStyle(color: Colors.red, fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      child: const Text('Submit changes', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80),
                        ),
                      ),
                      onPressed: _isSubmitting ? null : submitChanges,
                    ),
                    if (_showSuccess) Icon(Icons.check_circle, color: Colors.green),
                    if (_showError) Icon(Icons.error, color: Colors.red),
                    ElevatedButton(
                      child: Text('Add ${Config.EDIT_TOPIC_0_BLANK_ITEMS} more blanks'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80),
                        ),
                      ),
                      onPressed: addMoreItems,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 7,
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.all(6.0),
                      padding: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.grey[500]!),
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
      ],
    ),
  );
}
}