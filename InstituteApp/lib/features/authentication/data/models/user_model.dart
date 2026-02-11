class User {
  final String id;
  final String name;
  final String email;
  final String? password;
  final String? image;
  final String? token;

  User({
    required this.id,
    required this.image,
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
      image: json['image'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'email': email,
      'password': password,
      'token': token,
    };
  }
}
