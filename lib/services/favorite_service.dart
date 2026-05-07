import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class FavoriteService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // LOAD FAVORITES
  Future<List<ProductModel>> loadFavorites() async {
    QuerySnapshot snapshot =
    await _firestore
        .collection("userFavorite")
        .get();

    return snapshot.docs.map((doc) {
      final data =
      doc.data() as Map<String, dynamic>;

      return ProductModel.fromJson(
        data,
        doc.id,
      );

    }).toList();
  }

  // ADD FAVORITE
  Future<void> addFavorite(
      ProductModel product,
      ) async {

    await _firestore
        .collection("userFavorite")
        .doc(product.id)
        .set(product.toJson());
  }

  // REMOVE FAVORITE
  Future<void> removeFavorite(
      String productId,
      ) async {

    await _firestore
        .collection("userFavorite")
        .doc(productId)
        .delete();
  }
}