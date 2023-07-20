class CardItem {
  final int id;
  final int score;
  final String front;
  final String back;

  CardItem({
    required this.id,
    required this.score,
    required this.front,
    required this.back,
  });

  factory CardItem.fromJson(Map<String, dynamic> json) {
    return CardItem(
      id: json['id'],
      front: json['front'],
      back: json['back'],
      score: json['score'],
    );
  }
}
