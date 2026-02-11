class Cafeteria {
  final String id;
  final String name;
  final String location;
  final String time;
  final String contact;
  final String deliveryTime;
  final List<String> images;
  final List<String> menu;

  Cafeteria({
    required this.id,
    required this.name,
    required this.location,
    required this.time,
    required this.contact,
    required this.deliveryTime,
    required this.images,
    required this.menu,
  });

  factory Cafeteria.fromJson(Map<String, dynamic> json) {
    return Cafeteria(
      id: json['_id']?.toString() ?? '',
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      time: json['time'] ?? '',
      contact: json['contact'] ?? '',
      deliveryTime: json['deliveryTime'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      menu: List<String>.from(json['menu'] ?? []),
    );
  }
}
