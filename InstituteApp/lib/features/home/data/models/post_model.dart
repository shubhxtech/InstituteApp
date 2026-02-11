class PostItem {
  final String id;
  final String title;
  final String description;
  final List<String> images;
  final String link;
  final String host;
  final String type;
  final String emailId;
  final DateTime createdAt;
  final DateTime updatedAt;

  PostItem({
    required this.id,
    required this.title,
    required this.description,
    required this.images,
    required this.link,
    required this.host,
    required this.type,
    required this.emailId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PostItem.fromJson(Map<String, dynamic> json) {
    return PostItem(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      images: json['images'] != null 
          ? List<String>.from(json['images']) 
          : [],
      link: json['link'] ?? '',
      host: json['host'] ?? '',
      type: json['type'] ?? '',
      emailId: json['emailId'] ?? '',
      createdAt: json['createdAt'] is String 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      updatedAt: json['updatedAt'] is String 
          ? DateTime.parse(json['updatedAt']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'images': images,
      'link': link,
      'host': host,
      'type': type,
      'emailId': emailId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
