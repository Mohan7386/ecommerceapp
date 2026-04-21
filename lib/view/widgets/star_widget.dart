import 'package:ecommerce_app/view/widgets/product.dart';
import 'package:flutter/material.dart';

class StarWidget extends StatelessWidget {
  final Product product;

  const StarWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Stars
        Row(
          children: List.generate(5, (index) {
            if (index < product.rating.floor()) {
              return const Icon(Icons.star, color: Colors.amber, size: 20);
            } else if (index < product.rating && product.rating % 1 != 0) {
              return const Icon(Icons.star_half, color: Colors.amber, size: 20);
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
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),

        // Review Count
        if (product.reviewCount != null) ...[
          const SizedBox(width: 4),
          Text(
            product.reviewCount.toString(),
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
        ],
      ],
    );
  }
}
