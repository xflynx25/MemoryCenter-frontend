class Item {
  final int id;
  final String front;
  final String back;
  final int score;

  Item({
    required this.id,
    required this.front,
    required this.back,
    required this.score,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      front: json['front'],
      back: json['back'],
      score: json['score'] ?? 0,
    );
  }
}
