class Topic {
  final int id;
  final int user;
  final String topicName;
  final String? description;
  final String visibility;

  Topic({
    required this.id,
    required this.user,
    required this.topicName,
    this.description,
    required this.visibility,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'],
      user: json['user'],
      topicName: json['topic_name'],
      description: json['description'],
      visibility: json['visibility'],
    );
  }
}
