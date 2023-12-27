import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/topic.dart';
import '../utils/config.dart';
import '../widgets/topic_editor.dart';
import 'dart:convert';
import '../services/item_service.dart';



class EditTopicPage2 extends StatefulWidget {
  final Topic topic;

  EditTopicPage2({required this.topic});

  @override
  _EditTopicPage2State createState() => _EditTopicPage2State();
}

class _EditTopicPage2State extends State<EditTopicPage2> {
  TextEditingController _dataController = TextEditingController();
  var _isSubmitting = false;
  var _showSuccess = false;
  var _showError = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> submitChanges() async {
  setState(() {
    _isSubmitting = true;
    _showSuccess = false;
    _showError = false;
  });

  var lines = _dataController.text.split('\n');
  var items = <List<String>>[];

  for (var line in lines) {
    var parts = line.split(',');
    if (parts.length != 2 || parts[0].trim().isEmpty || parts[1].trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid or empty format in line: $line'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isSubmitting = false;
        _showError = true;
      });
      return;
    }
    items.add([parts[0].trim(), parts[1].trim()]);
  }

  ItemService itemService = ItemService();
  var result = await itemService.addItemsToTopic(widget.topic.id, items);

  if (result['success']) {
    _showSuccess = true;
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


  @override
  Widget build(BuildContext context) {
    return TopicEditor(
      topic: widget.topic,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: _dataController,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "Enter data here, each line should have format: front, back"
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                child: Text('Submit changes', style: TextStyle(color: Colors.white)),
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
            ],
          ),
        ),
      ),
    );
  }
}
