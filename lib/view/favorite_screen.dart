import 'package:ecommerce_app/controller/favorite_provider.dart';
import 'package:ecommerce_app/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteScreen  extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FavoriteProvider>();
    final cartList = provider.favorites;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Favorite', style: AppTextStyle.h3),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartList.length,
              shrinkWrap: true, // important
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final favoriteItems = cartList[index];
                return Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                         padding: EdgeInsets.all(10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              // image
                              child: Image.asset(
                                favoriteItems.images[0],
                                fit: BoxFit.cover,
                                width: 100,
                                height: 105,
                              ),
                            ),
                            SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  favoriteItems.title,
                                  style: AppTextStyle.withWeight(
                                    FontWeight.bold,
                                    AppTextStyle.bodyLarge,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  favoriteItems.category,
                                  style: AppTextStyle.bodyLarge,
                                ),

                                SizedBox(height: 10),
                                Text(
                                  "\$${ favoriteItems.price}",
                                  style: AppTextStyle.withWeight(
                                    FontWeight.bold,
                                    AppTextStyle.h3,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 35,
                      right: 30,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                             cartList.removeAt(index);
                             setState(() {

                             });
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                );
              },
            ),
          ),
        ]
      )
    );
  }
}
