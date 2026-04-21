
class Product {
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
  });
}

final List<Product> products = [
  Product(
    title: "Mac Air M2",
    description: "Powerful Laptop",
    images: [
      "assets/images/laptop.jpg",
      "assets/images/mac_ios.jpg",
      "assets/images/laptop.jpg",
    ],
    price: 200.00,
    category: "Electronics",
    oldPrice: 280.00,
    rating: 4.2,
    reviewCount: 88,
  ),
  Product(
    title: "Jordan Shoes",
    description: "This is description of the product",
    images: [
      "assets/images/casual shoes.jpg",
      "assets/images/casual shoes.jpg",
      "assets/images/casual shoes.jpg",
    ],
    price: 40.00,
    category: "Footwear",
    oldPrice: 120.00,
    rating: 3.8,
    reviewCount: 62,
  ),
  Product(
    title: "Puma",
    description: "",
    images: [
      "assets/images/shoe2.jpg",
      "assets/images/shoe2.jpg",
      "assets/images/shoe2.jpg",
    ],
    price: 200.00,
    category: "Footwear",
    oldPrice: 280.00,
    rating: 3.5,
    reviewCount: 100,
  ),
  Product(
    title: "Shoe",
    description: "This is description of the product",
    images: [
      "assets/images/shoes2.jpg",
      "assets/images/shoes2.jpg",
      "assets/images/shoes2.jpg",
    ],
    price: 30.00,
    category: "Footwear",
    oldPrice: 62.00,
    rating: 4.1,
    reviewCount: 341,
  ),
  Product(
    title: "T-Shirt",
    description: "This is description of the product",
    images: [
      "assets/images/t-shirt.jpg",
      "assets/images/t-shirt.jpg",
      "assets/images/t-shirt.jpg",
    ],
    price: 15.00,
    category: "Clothing",
    oldPrice: 24.00,
    rating: 3.9,
    reviewCount: 227,
  ),
];
