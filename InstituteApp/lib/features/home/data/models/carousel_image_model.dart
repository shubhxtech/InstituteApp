class CarouselImage {
  final String id;
  final String imageUrl;
  final String title;
  final String description;
  final String link;
  final int order;
  final bool active;

  CarouselImage({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.link,
    required this.order,
    required this.active,
  });

  factory CarouselImage.fromJson(Map<String, dynamic> json) {
    return CarouselImage(
      id: json['_id']?.toString() ?? '',
      imageUrl: json['imageUrl'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      link: json['link'] ?? '',
      order: json['order'] ?? 0,
      active: json['active'] ?? true,
    );
  }
}
