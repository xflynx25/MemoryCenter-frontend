import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/topic.dart';
import '../utils/config.dart';

class EditTopicPage1 extends StatefulWidget {
  final Topic topic;

  EditTopicPage1({required this.topic});

  @override
  _EditTopicPage1State createState() => _EditTopicPage1State();
}

class _EditTopicPage1State extends State<EditTopicPage1> {
  TextEditingController _frontController = TextEditingController();
  TextEditingController _backController = TextEditingController();
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

    var url = Uri.parse('${Config.HOST}/api/add_items_to_topic/');

    var prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString('accessToken') ?? '';

    var frontItems = _frontController.text.split('.');
    var backItems = _backController.text.split('.');

    if (frontItems.length != backItems.length) {
      // Items count mismatch, cannot proceed
      setState(() {
        _isSubmitting = false;
        _showError = true;
      });
      return;
    }

    var items = List<List<String>>.generate(frontItems.length, (index) {
      return [
        frontItems[index].trim(),
        backItems[index].trim()
      ];
    });


    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: json.encode({
        "topic_id": widget.topic.id,
        "items": items,
      }),
    );

    if (response.statusCode == 200) {
      _showSuccess = true;
    } else {
      _showError = true;
    }

    setState(() {
      _isSubmitting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Topic'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _frontController,
              maxLines: null,
              decoration: InputDecoration(
                hintText: "Enter fronts here, separated by periods"
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _backController,
              maxLines: null,
              decoration: InputDecoration(
                hintText: "Enter backs here, separated by periods"
              ),
            ),
            SizedBox(height: 16),
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
          ],
        ),
      ),
    );
  }
}
