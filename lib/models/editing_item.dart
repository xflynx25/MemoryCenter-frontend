class EditingItem {
  int id;
  String front;
  String back;

  EditingItem({
    required this.id,
    required this.front,
    required this.back,
  });

  factory EditingItem.fromJson(Map<String, dynamic> json) {
    return EditingItem(
      id: json['id'],
      front: json['front'],
      back: json['back'],
    );
  }
}
