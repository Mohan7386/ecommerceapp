import 'package:flutter/material.dart';
import 'product.dart';

class RatingWidget extends StatelessWidget {
  final Product product;
  final bool showReviews;

  const RatingWidget({
    super.key,
    required this.product,
    this.showReviews = true,
  });

  @override
  Widget build(BuildContext context) {
    final double rating = product.rating;
    final int fullStars = rating.floor();
    final bool halfStar = (rating - fullStars) >= 0.5;

    return Row(
      children: [
        //  Stars
        Row(
          children: List.generate(5, (index) {
            if (index < fullStars) {
              return const Icon(Icons.star, color: Colors.amber, size: 18);
            } else if (index == fullStars && halfStar) {
              return const Icon(Icons.star_half,
                  color: Colors.amber, size: 18);
            } else {
              return const Icon(Icons.star_border,
                  color: Colors.amber, size: 18);
            }
          }),
        ),

        const SizedBox(width: 6),

        //  Rating number
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),

        // Reviews (optional)
        if (showReviews && product.reviewCount != null) ...[
          const SizedBox(width: 4),
          Text(
            "(${product.reviewCount} Reviews)",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}