class ProductModel {

  final String id;
  final String title;
  final String description;
  final List<String> images;
  final double? oldPrice;
  final double price;
  final String category;
  final bool isFavorite;
  final double rating;
  final int? reviewCount;
  int quantity;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.images,
    this.oldPrice,
    required this.price,
    required this.category,
    this.isFavorite = false,
    required this.rating,
    this.reviewCount,
    this.quantity = 1,
  });

  factory ProductModel.fromJson(
      Map<String, dynamic> json,
      String docId,
      ) {
    return ProductModel(
      id: docId,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      oldPrice: (json['oldPrice'] as num?)?.toDouble(),
      price: (json['price'] as num).toDouble(),
      category: json['category'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      reviewCount: json['reviewCount'],
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "images": images,
      "oldPrice": oldPrice,
      "price": price,
      "category": category,
      "isFavorite": isFavorite,
      "rating": rating,
      "reviewCount": reviewCount,
      "quantity": quantity,
    };
  }
}