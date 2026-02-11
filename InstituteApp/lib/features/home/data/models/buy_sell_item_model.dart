class BuySellItem {
  final String id;
  final String name;
  final String productDescription;
  final List<String> productImage;
  final String soldBy;
  final String maxPrice;
  final String minPrice;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String phoneNo;

  BuySellItem({
    required this.id,
    required this.name,
    required this.productDescription,
    required this.productImage,
    required this.soldBy,
    required this.maxPrice,
    required this.minPrice,
    required this.createdAt,
    required this.updatedAt,
    required this.phoneNo,
  });

  factory BuySellItem.fromJson(Map<String, dynamic> json) {
    return BuySellItem(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      productDescription: json['productDescription'] ?? '',
      productImage: json['productImage'] != null 
          ? List<String>.from(json['productImage']) 
          : [],
      soldBy: json['soldBy'] ?? '',
      maxPrice: json['maxPrice'] ?? '',
      minPrice: json['minPrice'] ?? '',
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
      'name': name,
      'productDescription': productDescription,
      'productImage': productImage,
      'soldBy': soldBy,
      'maxPrice': maxPrice,
      'minPrice': minPrice,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'phoneNo': phoneNo,
    };
  }
}
