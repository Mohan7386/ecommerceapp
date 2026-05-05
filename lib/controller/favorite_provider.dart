import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../view/widgets/product.dart';

class FavoriteProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Product> _favorites = [];
  List<Product> get favorites => _favorites;

  int get favoriteCount => _favorites.length;

  FavoriteProvider(){
    loadFavorite();
  }

 void toggleFavorite (Product product) async{
    if(isExist(product)){
    _favorites.removeWhere((item) => item.id == product.id);
    await _firestore.collection("userFavorite").doc(product.id).delete();
  } else {
      _favorites.add(product);
      await _firestore.collection("userFavorite").doc(product.id).set({
        "productId": product.id,
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
    notifyListeners();
  }

  bool isExist(Product product){
  return _favorites.any((item) => item.id == product.id);
 }
  // load Favorites to fireStore
  Future<void> loadFavorite() async {
    try {
      QuerySnapshot snapshot =
      await _firestore.collection("userFavorite").get();

      _favorites = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
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
    } catch (e){
      if (kDebugMode) {
        print("Load Favorite Error: $e");
      }
    }
    notifyListeners();
  }

  static FavoriteProvider of (
      BuildContext context, {
        bool listen = true,
  }) {
   return Provider.of <FavoriteProvider>(
     context, listen:listen,
   );
  }
}
