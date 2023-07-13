import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    items = widget.topic.items
        .map((item) => EditingItem(id: item.id, front: item.front, back: item.back))
        .toList();
    frontControllers = items.map((item) => TextEditingController(text: item.front)).toList();
    backControllers = items.map((item) => TextEditingController(text: item.back)).toList();
    // Start by adding 50 blank items to the list
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
@override
Widget build(BuildContext context) {
  return TopicEditor(
    topic: widget.topic,
    child: Center(
      child: Row(
        children: <Widget>[
          // 30% width for buttons
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // 10% space from top
                Spacer(flex: 1),
                // Submit Changes Button
                Expanded(
                  flex: 8,
                  child: ElevatedButton(
                    child: const Text('Submit changes', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Changed to green color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80), // rounder button
                      ),
                    ),
                    onPressed: () {
                      // Call your API to submit changes here
                    },
                  ),
                ),
                // 80% space
                Spacer(flex: 8),
                // Add More Items Button
                Expanded(
                  flex: 8,
                  child: ElevatedButton(
                    child: const Text('Add ${Config.EDIT_TOPIC_0_BLANK_ITEMS} more blanks'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Change this color to your preference
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80), // rounder button
                      ),
                    ),
                    onPressed: () {
                      addItems(Config.EDIT_TOPIC_0_BLANK_ITEMS);
                    },
                  ),
                ),
                // 10% space from bottom
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
                                style: TextStyle(
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

