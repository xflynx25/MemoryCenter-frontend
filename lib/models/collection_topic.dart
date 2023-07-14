class CollectionTopic {
  final int id;
  final int collection;
  final int topic;
  final bool isActive;
  final String topicName; 

  CollectionTopic({
    required this.id,
    required this.collection,
    required this.topic,
    required this.isActive,
    required this.topicName, 
  });

  factory CollectionTopic.fromJson(Map<String, dynamic> json) {
    return CollectionTopic(
      id: json['id'],
      collection: json['collection'],
      topic: json['topic'],
      isActive: json['is_active'],
      topicName: json['topic_name'], 
    );
  }
}
