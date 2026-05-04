import 'package:ecommerce_app/controller/favorite_provider.dart';
import 'package:ecommerce_app/utils/app_text_styles.dart';
import 'package:ecommerce_app/view/widgets/product.dart';
import 'package:ecommerce_app/view/widgets/rating_widget.dart';
import 'package:flutter/material.dart';
import '../product_details_screen.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final bool isGrid;

  const ProductCard({super.key, required this.product,  this.isGrid = false});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final provider = FavoriteProvider.of(context);
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailScreen(product: widget.product),
        ),
      ),
      child: Container(
        // height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Stack
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: widget.isGrid ? 1 / 1 : 4 / 5, //  grid vs horizontal
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      widget.product.images[0],
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // favorite button icon
                Positioned(
                  top: 5,
                  right: 5,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white,
                    child: IconButton(
                      onPressed: () {
                        provider.toggleFavorite(widget.product);
                      },
                      icon: Icon(
                        provider.isExist(widget.product)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: widget.product.isFavorite
                            ? Colors.grey
                            : Colors.red,
                      ),
                    ),
                  ),
                ),
                if (widget.product.oldPrice != null)
                  Positioned(
                    top: 5,
                    left: 5,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      // Discount Text
                      child: Text(
                        ' ${calculateDiscount(widget.product.price, widget.product.oldPrice!)}% Off',
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
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.title,
                    style: AppTextStyle.withColor(
                      Colors.black,
                      AppTextStyle.h3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2),
                  Text(
                    widget.product.category,
                    style: AppTextStyle.withColor(
                      Colors.grey,
                      AppTextStyle.bodySmall,
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.01),
                  RatingWidget(product: widget.product, showReviews: false),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        '\$${widget.product.price.toStringAsFixed(2)}',
                        style: AppTextStyle.withColor(
                          Colors.black,
                          AppTextStyle.bodyLarge,
                        ),
                      ),
                      if (widget.product.oldPrice != null)
                        Text(
                          '\$${widget.product.oldPrice!.toStringAsFixed(2)}',
                          style: AppTextStyle.withColor(
                            Colors.grey,
                            AppTextStyle.bodySmall,
                          ).copyWith(decoration: TextDecoration.lineThrough),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // calculate Discount
  int calculateDiscount(double currentPrice, double oldPrice) {
    return (((oldPrice - currentPrice) / oldPrice) * 100).round();
  }
}
