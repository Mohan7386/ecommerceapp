import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../view/widgets/product.dart';

class FavoriteProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Product> _favorites = [];
  List<Product> get favorites => _favorites;

  List<Product> _allProducts = [];

  void setAllProducts(List<Product> products) {
    _allProducts = products;
    loadFavorite();
  }

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
        "productId":product.id,
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
      List<String> favoriteIds = snapshot.docs.map((doc) => doc.id).toList();

      _favorites = _allProducts
          .where((product) => favoriteIds.contains(product.id))
          .toList();
    } catch (e){
      if (kDebugMode) {
        print(e.toString());
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