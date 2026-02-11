class LostFoundItem {
  final String id;
  final String from;
  final String lostOrFound;
  final String name;
  final String description;
  final List<String> images;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String phoneNo;

  LostFoundItem({
    required this.id,
    required this.from,
    required this.lostOrFound,
    required this.name,
    required this.description,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
    required this.phoneNo,
  });

  factory LostFoundItem.fromJson(Map<String, dynamic> json) {
    return LostFoundItem(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      from: json['from'] ?? '',
      lostOrFound: json['lostOrFound'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      images: json['images'] != null 
          ? List<String>.from(json['images']) 
          : [],
      createdAt: json['createdAt'] is String 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      updatedAt: json['updatedAt'] is String 
          ? DateTime.parse(json['updatedAt']) 
          : DateTime.now(),
      phoneNo: json['phoneNo'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'from': from,
      'lostOrFound': lostOrFound,
      'name': name,
      'description': description,
      'images': images,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'phoneNo': phoneNo,
    };
  }
}
