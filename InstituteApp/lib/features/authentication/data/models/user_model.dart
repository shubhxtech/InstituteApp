class User {
  final String id;
  final String name;
  final String email;
  final String? password;
  final String? token;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.password,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      id: json['_id'] ?? json['id'] ?? '',
      token: json['token'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'token': token,
    };
  }
}
