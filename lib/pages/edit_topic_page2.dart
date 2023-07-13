import 'package:flutter/material.dart';
import '../models/topic.dart';
import '../widgets/topic_editor.dart';
import '../widgets/not_implemented.dart';

class EditTopicPage2 extends StatefulWidget {
  final Topic topic;

  EditTopicPage2({required this.topic});

  @override
  _EditTopicPage2State createState() => _EditTopicPage2State();
}

class _EditTopicPage2State extends State<EditTopicPage2> {
  @override
  Widget build(BuildContext context) {
    return TopicEditor(
      topic: widget.topic,
      child: NotImplemented(),
    );
  }
}
