import 'package:flutter/material.dart';
import '../models/editing_collection_topic.dart';
import '../models/collection.dart';
import '../models/topic.dart';

class EditCollectionPage extends StatefulWidget {
  final Collection collection;
  final Future<List<Topic>> futureTopics;

  EditCollectionPage({required this.collection, required this.futureTopics});

  @override
  _EditCollectionPageState createState() => _EditCollectionPageState();
}

class _EditCollectionPageState extends State<EditCollectionPage> {
  late List<Topic> allTopics;
  List<EditingCollectionTopic> editingCollectionTopics = [];

  @override
  void initState() {
    super.initState();
    _initializeEditingCollectionTopics();
  }

  void _initializeEditingCollectionTopics() {
    editingCollectionTopics = widget.collection.collectionTopics.map(
      (collectionTopic) => EditingCollectionTopic(
        id: collectionTopic.topic,
        topicName: collectionTopic.topicName,
        isActive: collectionTopic.isActive,
      ),
    ).toList();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Edit Collection (${widget.collection.collectionName})'),
    ),
    body: Padding(  
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.05,
        horizontal: MediaQuery.of(context).size.width * 0.2,
      ),
      child: FutureBuilder<List<Topic>>(
        future: widget.futureTopics,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            allTopics = snapshot.data!;
            return ListView.builder(
              itemCount: allTopics.length,
              itemBuilder: (context, index) {
                Topic currentTopic = allTopics[index];
                String status = _getTopicStatus(currentTopic);
                return _buildTopicRow(currentTopic, status);
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('An error occurred'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    ),
  );
}

String _getTopicStatus(Topic topic) {
  // Check if the topic exists in the editingCollectionTopics
  for (var editingCollectionTopic in editingCollectionTopics) {
    if (editingCollectionTopic.id == topic.id) {
      // Check if the topic is active or inactive
      return editingCollectionTopic.isActive ? 'active' : 'inactive';
    }
  }
  // If the topic was not found in the editingCollectionTopics, it's not selected
  return 'not_selected';
}

void _setTopicStatus(Topic topic, String newStatus) {
  setState(() {
    for (var i = 0; i < editingCollectionTopics.length; i++) {
      var editingCollectionTopic = editingCollectionTopics[i];

      if (editingCollectionTopic.id == topic.id) {
        if (newStatus == 'not_selected') {
          // Found the topic in editingCollectionTopics, remove it
          editingCollectionTopics.removeAt(i);
        } else {
          // Update its status
          editingCollectionTopic.isActive = newStatus == 'active';
        }
        return;
      }
    }

    // If topic not found in editingCollectionTopics and new status is not 'not_selected', add it with the appropriate status
    if (newStatus != 'not_selected') {
      editingCollectionTopics.add(EditingCollectionTopic(
        id: topic.id,
        topicName: topic.topicName,
        isActive: newStatus == 'active',
      ));
    }
  });
}

Widget _buildTopicRow(Topic topic, String status) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey.withOpacity(0.5),
            width: 1.0,
            style: BorderStyle.solid,
          ),
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.5),
            width: 1.0,
            style: BorderStyle.solid,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0), // added vertical padding
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Text(
                topic.topicName,
                style: TextStyle(
                  fontSize: 18.0, 
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ChoiceChip(
                    label: Text('Active'),
                    selected: status == 'active',
                    onSelected: (bool selected) {
                      setState(() {
                        _setTopicStatus(topic, 'active');
                      });
                    },
                    selectedColor: Colors.green,
                  ),
                  ChoiceChip(
                    label: Text('Inactive'),
                    selected: status == 'inactive',
                    onSelected: (bool selected) {
                      setState(() {
                        _setTopicStatus(topic, 'inactive');
                      });
                    },
                    selectedColor: Colors.red,
                  ),
                  ChoiceChip(
                    label: Text('Not Selected'),
                    selected: status == 'not_selected',
                    onSelected: (bool selected) {
                      setState(() {
                        _setTopicStatus(topic, 'not_selected');
                      });
                    },
                    selectedColor: Colors.grey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}
