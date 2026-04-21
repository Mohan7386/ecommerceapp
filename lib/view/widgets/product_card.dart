import 'package:ecommerce_app/controller/favorite_provider.dart';
import 'package:ecommerce_app/utils/app_text_styles.dart';
import 'package:ecommerce_app/view/widgets/product.dart';
import 'package:ecommerce_app/view/widgets/rating_widget.dart';
import 'package:flutter/material.dart';
import '../product_details_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final provider = FavoriteProvider.of(context);
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailScreen(product: product),
        ),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          product.images[0],
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // favorite button icon
                    Positioned(
                      top: 5,
                      right: 5,
                      child: IconButton(
                        onPressed: () {
                          provider.toggleFavorite(product);
                        },
                        icon: Icon(
                          provider.isExist(product)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: product.isFavorite ? Colors.grey : Colors.red,
                        ),
                      ),
                    ),
                    if (product.oldPrice != null)
                      Positioned(
                        top: 5,
                        left: 5,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          // Discount Text
                          child: Text(
                            ' ${calculateDiscount(product.price, product.oldPrice!)}% Off',
                            style: AppTextStyle.withColor(
                              Colors.white,
                              AppTextStyle.bodySmall,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                // Product details
                Padding(
                  padding: EdgeInsets.all(screenWidth * 0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        style: AppTextStyle.withColor(
                          Colors.black,
                          AppTextStyle.h3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2),
                      Text(
                        product.category,
                        style: AppTextStyle.withColor(
                          Colors.grey,
                          AppTextStyle.bodySmall,
                        ),
                      ),
                      SizedBox(height: screenWidth * 0.01),
                      Row(
                        children: [
                          // Stars
                          Row(
                            children: List.generate(5, (index) {
                              if (index < product.rating.floor()) {
                                return const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 20,
                                );
                              } else if (index < product.rating &&
                                  product.rating % 1 != 0) {
                                return const Icon(
                                  Icons.star_half,
                                  color: Colors.amber,
                                  size: 20,
                                );
                              } else {
                                return const Icon(
                                  Icons.star_border,
                                  color: Colors.amber,
                                  size: 20,
                                );
                              }
                            }),
                          ),
                          const SizedBox(width: 6),

                          // Rating Number
                          Text(
                            product.rating.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),

                          // Review Count
                          // if (product.reviewCount != null) ...[
                          //   const SizedBox(width: 4),
                          //   Text(
                          //     "($product.reviewCount reviews)",
                          //     style: TextStyle(
                          //       color: Colors.grey.shade600,
                          //       fontSize: 13,
                          //     ),
                          //   ),
                          ],
                      ),
                      // RatingWidget(rating: 4.5,),
                      SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: AppTextStyle.withColor(
                              Colors.black,
                              AppTextStyle.bodyLarge,
                            ),
                          ),
                          if (product.oldPrice != null)
                            Text(
                              '\$${product.oldPrice!.toStringAsFixed(2)}',
                              style:
                                  AppTextStyle.withColor(
                                    Colors.grey,
                                    AppTextStyle.bodySmall,
                                  ).copyWith(
                                    decoration: TextDecoration.lineThrough,
                                  ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      // ],
      // ),
      //],
      // ),
      // ),
    );
  }

  // calculate Discount

  int calculateDiscount(double currentPrice, double oldPrice) {
    return (((oldPrice - currentPrice) / oldPrice) * 100).round();
  }
}
