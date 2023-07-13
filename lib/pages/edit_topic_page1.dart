import 'package:flutter/material.dart';
import '../models/topic.dart';
import '../widgets/topic_editor.dart';
import '../widgets/not_implemented.dart';

class EditTopicPage1 extends StatefulWidget {
  final Topic topic;

  EditTopicPage1({required this.topic});

  @override
  _EditTopicPage1State createState() => _EditTopicPage1State();
}

class _EditTopicPage1State extends State<EditTopicPage1> {
  @override
  Widget build(BuildContext context) {
    return TopicEditor(
      topic: widget.topic,
      child: NotImplemented(),
    );
  }
}
