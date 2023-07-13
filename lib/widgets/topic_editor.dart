import 'package:flutter/material.dart';
import '../models/topic.dart';
import '../widgets/styled_text_button.dart';

class TopicEditor extends StatefulWidget {
  final Topic topic;
  final Widget child;

  TopicEditor({required this.topic, required this.child});

  @override
  _TopicEditorState createState() => _TopicEditorState();
}

class _TopicEditorState extends State<TopicEditor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Topic (${widget.topic.topicName})'),
        actions: <Widget>[
          StyledTextButton(
            label: 'standard (list)',
            onPressed: () {
              Navigator.pushNamed(context, '/edit_topic0', arguments: widget.topic);
            },
          ),
          StyledTextButton(
            label: 'google translate',
            onPressed: () {
              Navigator.pushNamed(context, '/edit_topic1', arguments: widget.topic);
            },
          ),
          StyledTextButton(
            label: 'enter add',
            onPressed: () {
              Navigator.pushNamed(context, '/edit_topic2', arguments: widget.topic);
            },
          ),
        ],
      ),
      body: widget.child,
    );
  }
}
