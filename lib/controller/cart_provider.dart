import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../view/widgets/product.dart';

class CartProvider extends ChangeNotifier {
  List<Product> cart = [];

  void removeFromCart(int index) {
    cart.removeAt(index);
    notifyListeners();
  }

  void addToCart(Product product) {
    cart.add(product);
    notifyListeners();
  }
  incrementQnt(int index) {
    cart[index].quantity++;
    notifyListeners();
  }
  decrementQnt(int index) {
    if(cart[index].quantity > 1) {
      cart[index].quantity--;
      notifyListeners();
    }
  }

  void clearCart() {
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
