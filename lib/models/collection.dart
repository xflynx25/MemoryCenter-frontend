import './topic.dart';

class Collection {
  final int id;
  final int user;
  final String collectionName;
  final String? description;
  final String visibility;
  final List<Topic> topics;

  Collection({
    required this.id,
    required this.user,
    required this.collectionName,
    this.description,
    required this.visibility,
    required this.topics,
  });

  factory Collection.fromJson(Map<String, dynamic> json) {
    return Collection(
      id: json['id'],
      user: json['user'],
      collectionName: json['collection_name'],
      description: json['description'],
      visibility: json['visibility'],
      topics: (json['topics'] as List).map((i) => Topic.fromJson(i)).toList(),
    );
  }
}
