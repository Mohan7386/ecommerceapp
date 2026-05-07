import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class CartService {

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // LOAD CART
  Future<List<ProductModel>> loadCart(
      String userId,
      ) async {

    final snapshot = await _firestore
        .collection("users")
        .doc(userId)
        .collection("cart")
        .get();

    return snapshot.docs.map((doc) {

      final data = doc.data();

      return ProductModel.fromJson(
        data,
        doc.id,
      );

    }).toList();
  }

  // SAVE CART ITEM
  Future<void> saveCartItem(
      String userId,
      ProductModel product,
      ) async {

    await _firestore
        .collection("users")
        .doc(userId)
        .collection("cart")
        .doc(product.id)
        .set(product.toJson());
  }

  // REMOVE ITEM
  Future<void> removeCartItem(
      String userId,
      String productId,
      ) async {

    await _firestore
        .collection("users")
        .doc(userId)
        .collection("cart")
        .doc(productId)
        .delete();
  }

  //  CLEAR CART
  Future<void> clearCart(
      String userId,
      ) async {

    final snapshot = await _firestore
        .collection("users")
        .doc(userId)
        .collection("cart")
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}