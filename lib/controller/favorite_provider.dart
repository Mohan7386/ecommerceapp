import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/services/favorite_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';

class FavoriteProvider extends ChangeNotifier {
 final FavoriteService _favoriteService = FavoriteService();

  List<ProductModel> _favorites = [];
  List<ProductModel> get favorites => _favorites;

  int get favoriteCount => _favorites.length;

  FavoriteProvider(){
    loadFavorite();
  }

 void toggleFavorite (ProductModel product) async{
    if(isExist(product)){
    _favorites.removeWhere((item) => item.id == product.id);
    await _favoriteService.removeFavorite(product.id);
  } else {
      _favorites.add(product);
      await _favoriteService.addFavorite(product);
      }
    notifyListeners();
  }

  bool isExist(ProductModel product){
  return _favorites.any((item) => item.id == product.id);
 }
  // load Favorites to fireStore
  Future<void> loadFavorite() async {
    try {
      _favorites = await _favoriteService.loadFavorites();
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
