class Product {
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

  Product({
    required this.title,
    required this.description,
    required this.images,
    this.oldPrice,
    required this.price,
    required this.category,
    this.isFavorite = false,
    this.quantity = 1,
    required this.rating,
    this.reviewCount,
    required this.id,
  });
}
