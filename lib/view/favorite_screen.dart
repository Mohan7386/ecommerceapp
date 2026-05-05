import 'package:ecommerce_app/controller/favorite_provider.dart';
import 'package:ecommerce_app/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FavoriteProvider>();
    final favoriteList = provider.favorites;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Favorite', style: AppTextStyle.h3),
        centerTitle: true,
      ),
      body: favoriteList.isEmpty
          ? Center(child: Text("No Favorites Yet", style: AppTextStyle.h3))
          : ListView.builder(
              itemCount: favoriteList.length,
              itemBuilder: (context, index) {
                final product = favoriteList[index];

                return Padding(
                  padding: const EdgeInsets.all(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 5),
                      ],
                    ),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        // Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: product.images.isNotEmpty
                              ? Image.network(
                            product.images[0],
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                          ) : Container(
                            width: 90,
                            height: 90,
                            color: Colors.grey.shade200,
                            child: Icon(Icons.image_not_supported),
                          ),
                        ),

                        SizedBox(width: 10),

                        // Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyle.h3,
                              ),
                              SizedBox(height: 5),
                              Text(product.category),
                              SizedBox(height: 5),
                              Text(
                                "\$${product.price}",
                                style: AppTextStyle.h3,
                              ),
                            ],
                          ),
                        ),

                        // Delete button
                        IconButton(
                            onPressed: () {
                              provider.toggleFavorite(favoriteList[index]);
                          },
                          icon: Icon(Icons.delete),
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
