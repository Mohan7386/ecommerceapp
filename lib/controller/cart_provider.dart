import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../view/widgets/product.dart';

class CartProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _userId;

  int get cartCount => cart.length;

  List<Product> cart = [];

  void setUserId(String uid) {
    _userId = uid;
    loadCart();
  }

  Future<void> loadCart() async {
    if (_userId == null) return;
    try {
      final snapshot = await _firestore
          .collection("users")
          .doc(_userId)
          .collection("cart")
          .get();
      cart = snapshot.docs.map((doc) {
        final data = doc.data();
        return Product(
          id: doc.id,
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          images: List<String>.from(data['images'] ?? []),
          oldPrice: data['oldPrice']?.toDouble(),
          price: (data['price'] ?? 0).toDouble(),
          category: data['category'] ?? '',
          rating: (data['rating'] ?? 0).toDouble(),
          reviewCount: data['reviewCount'],
          quantity: data['quantity'] ?? 1,
        );
      }).toList();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print(" Load Cart Error: $e");
    }
  }

  Future<void> addToCart(Product product) async {
    final existingIndex = cart.indexWhere((item) => item.id == product.id);
    if (existingIndex != -1) {
      cart[existingIndex].quantity++;
      await _saveCartItem(cart[existingIndex]);
    } else {
      cart.add(product);
      await _saveCartItem(product);
    }
    notifyListeners();
  }

  Future<void> _saveCartItem(Product product) async {
    if (_userId == null) return;
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('cart')
        .doc(product.id)
        .set({
          "title": product.title,
          "description": product.description,
          "price": product.price,
          "oldPrice": product.oldPrice,
          "category": product.category,
          "images": product.images,
          "rating": product.rating,
          "reviewCount": product.reviewCount,
          "quantity": product.quantity,
        });
  }

  Future<void> removeFromCart(int index) async {
    if (_userId != null) {
      await _firestore
          .collection("users")
          .doc(_userId)
          .collection("cart")
          .doc(cart[index].id)
          .delete();
    }
    cart.removeAt(index);
    notifyListeners();
  }

  Future<void>incrementQnt(int index) async {
    cart[index].quantity++;
    await _saveCartItem(cart[index]);
    notifyListeners();
  }

 Future<void> decrementQnt(int index) async {
    if (cart[index].quantity > 1) {
      cart[index].quantity--;
      await _saveCartItem(cart[index]);
      notifyListeners();
    }
  }

  Future<void> clearCart() async {
    if (_userId != null) {
      final snapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('cart')
          .get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    }
    cart.clear();
    notifyListeners();
  }

  double get totalPrice {
    double total = 0.0;
    for (Product element in cart) {
      total += element.price * element.quantity;
    }
    return total;
  }

  static CartProvider of(BuildContext context) {
    return Provider.of<CartProvider>(context);
  }
}
