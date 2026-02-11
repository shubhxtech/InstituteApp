class UserEntity {
  final String? id;
  final String name;
  final String email;
  final String? password;
  final String? image;
  final String? token;

  UserEntity({
    this.id,
    required this.image,
    required this.name,
    required this.email,
    this.password,
    this.token,
  });

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

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      image: json['image'],
      token: json['token'],
    );
  }
}
