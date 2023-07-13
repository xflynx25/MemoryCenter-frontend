import './item.dart';

class Topic {
  final int id;
  final int user;
  final String topicName;
  final String? description;
  final String visibility;
  final List<Item> items;
  //final List<Item> collections;

  Topic({
    required this.id,
    required this.user,
    required this.topicName,
    this.description,
    required this.visibility,
    required this.items
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'],
      user: json['user'],
      topicName: json['topic_name'],
      description: json['description'],
      visibility: json['visibility'],
      items: (json['items'] as List).map((i) => Item.fromJson(i)).toList(),
    );
  }
}

