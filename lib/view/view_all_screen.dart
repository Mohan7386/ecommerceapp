import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/utils/app_text_styles.dart';
import 'package:ecommerce_app/view/widgets/product.dart';
import 'package:ecommerce_app/view/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/view_controller.dart';

class ViewAllScreen extends StatefulWidget {
  const ViewAllScreen({super.key});

  @override
  State<ViewAllScreen> createState() => _ViewAllScreenState();
}

class _ViewAllScreenState extends State<ViewAllScreen> {
  String category = "All";
  @override
  Widget build(BuildContext context) {
    final viewProvider = context.watch<ViewProvider>();
    double width = MediaQuery.of(context).size.width;

    // responsive counts
    int productCount = (width ~/ 250) < 2 ? 2 : (width ~/ 250);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon:Icon(Icons.arrow_back_ios)),
        title:Text("Special For You",style:AppTextStyle.h2),
        centerTitle: true,
      ),
      body:SingleChildScrollView(
        padding: EdgeInsetsGeometry.all(18),
        child:Column(
          children: [
            //  for Shopping Item
            StreamBuilder(
              stream: category == "All"
                  ? FirebaseFirestore.instance.collection('products').snapshots()
                  : FirebaseFirestore.instance
                  .collection('products')
                  .where('category', isEqualTo: category.toLowerCase())
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var docs = snapshot.data!.docs;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: docs.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: productCount,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 16,
                    mainAxisExtent: 320,
                  ),
                  itemBuilder: (context, index) {
                    var data = docs[index];
                    final product = Product(
                      title: data['title'] ?? '',
                      description: data['description'] ?? '',
                      images: List<String>.from(data['images'] ?? []),
                      oldPrice: data['oldPrice']?.toDouble(),
                      price: (data['price'] ?? 0).toDouble(),
                      category: data['category'] ?? '',
                      rating: (data['rating'] ?? 0).toDouble(),
                      reviewCount: data['reviewCount'],
                      quantity: data['quantity'] ?? 1,
                      id: docs[index].id,
                    );
                    return ProductCard(product: product,
                      isGrid: true,
                    );
                  },
                );
              },
            ),
          ],
        )
      ),
    );
  }
}
