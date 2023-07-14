import './collection_topic.dart';

class Collection {
  final int id;
  final int user;
  final String collectionName;
  final String? description;
  final String visibility;
  final List<CollectionTopic> collectionTopics;

  Collection({
    required this.id,
    required this.user,
    required this.collectionName,
    this.description,
    required this.visibility,
    required this.collectionTopics,
  });

  factory Collection.fromJson(Map<String, dynamic> json) {
    return Collection(
      id: json['id'],
      user: json['user'],
      collectionName: json['collection_name'],
      description: json['description'],
      visibility: json['visibility'],
      collectionTopics: (json['topics'] as List).map((d) => CollectionTopic.fromJson(d)).toList(),
    );
  }
}
