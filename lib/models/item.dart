class Item {
  final int id;
  final String front;
  final String back;
  final List<int> users;
  final List<int> topics;

  Item({
    required this.id,
    required this.front,
    required this.back,
    required this.users,
    required this.topics,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      front: json['front'],
      back: json['back'],
      users: List<int>.from(json['users']),
      topics: List<int>.from(json['topics']),
    );
  }
}
