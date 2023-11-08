class User {
  final int id;
  final String username;
  final String? realname;
  final String? description;
  final List<String>? awards;

  User({
    required this.id,
    required this.username,
    this.realname,
    this.description,
    this.awards,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      realname: json['realname'],
      description: json['description'],
      awards: (json['awards'] as List).cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'realname': realname,
      'description': description,
      'awards': awards,
    };
  }
}
