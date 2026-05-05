import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FilteredProductsScreen extends StatelessWidget {
  final String type;
  final dynamic value;
  final String title;

  const FilteredProductsScreen({
    super.key,
    required this.type,
    this.value,
    required this.title,
  });

  Query _query() {
    final col = FirebaseFirestore.instance.collection("products");

    if (type == "discount") {
      return col.where("discountPercentage",
          isGreaterThanOrEqualTo: value);
    } else if (type == "new") {
      return col.orderBy("createdAt", descending: true).limit(20);
    } else if (type == "category") {
      return col.where("category", isEqualTo: value);
    }
    return col;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: StreamBuilder<QuerySnapshot>(
        stream: _query().snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snap.hasData || snap.data!.docs.isEmpty) {
            return const Center(child: Text("No products found"));
          }

          final docs = snap.data!.docs;

          return GridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: docs.length,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (context, i) {
              final d = docs[i].data() as Map<String, dynamic>;

              final double price =
              (d["price"] as num).toDouble();
              final double oldPrice =
              (d["oldPrice"] as num).toDouble();
              final int discount =
              (d["discountPercentage"] as num).toInt();

              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius:
                            const BorderRadius.vertical(
                                top: Radius.circular(10)),
                            child: Image.network(
                              d["images"][0],
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),

                          ///  Discount badge
                          Positioned(
                            top: 6,
                            left: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius:
                                BorderRadius.circular(6),
                              ),
                              child: Text(
                                "$discount% OFF",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            d["title"],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),

                          Row(
                            children: [
                              Text(
                                "₹$price",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "₹$oldPrice",
                                style: const TextStyle(
                                  decoration:
                                  TextDecoration.lineThrough,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}