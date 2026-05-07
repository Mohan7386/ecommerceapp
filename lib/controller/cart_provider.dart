import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../services/cart_service.dart';

class CartProvider extends ChangeNotifier {
  final CartService _cartService = CartService();

  String? _userId;

  int get cartCount => cart.length;

  List<ProductModel> cart = [];

  void setUserId(String uid) {
    _userId = uid;
    loadCart();
  }

  // load cart

  Future<void> loadCart() async {
    if (_userId == null) return;
    try {
      cart = await _cartService.loadCart(_userId!);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print(" Load Cart Error: $e");
    }
  }

  // add cart

  Future<void> addToCart(ProductModel product) async {
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

  // save item

  Future<void> _saveCartItem(ProductModel product) async {
    if (_userId == null) return;

    await _cartService.saveCartItem(_userId!, product);
  }

  // Remove Item

  Future<void> removeFromCart(int index) async {
    if (_userId != null) {
      await _cartService.removeCartItem(_userId!, cart[index].id);
    }
    cart.removeAt(index);
    notifyListeners();
  }

  // Increment
  Future<void> incrementQnt(int index) async {
    cart[index].quantity++;
    await _saveCartItem(cart[index]);
    notifyListeners();
  }

  // Decrement
  Future<void> decrementQnt(int index) async {
    if (cart[index].quantity > 1) {
      cart[index].quantity--;
      await _saveCartItem(cart[index]);
      notifyListeners();
    }
  }

  // Clear Cart
  Future<void> clearCart() async {
    if (_userId != null) {
      await _cartService.clearCart(_userId!);
    }
    cart.clear();
    notifyListeners();
  }

  // Total Price
  double get totalPrice {
    double total = 0.0;
    for (ProductModel element in cart) {
      total += element.price * element.quantity;
    }
    return total;
  }

  static CartProvider of(BuildContext context) {
    return Provider.of<CartProvider>(context);
  }
}
