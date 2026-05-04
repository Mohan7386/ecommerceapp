import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/controller/view_controller.dart';
import 'package:ecommerce_app/utils/app_text_styles.dart';
import 'package:ecommerce_app/view/favorite_screen.dart';
import 'package:ecommerce_app/view/view_all_screen.dart';
import 'package:ecommerce_app/view/widgets/carousel_slider.dart';
import 'package:ecommerce_app/view/widgets/category_grid.dart';
import 'package:ecommerce_app/view/widgets/custom_text_field.dart';
import 'package:ecommerce_app/view/widgets/product.dart';
import 'package:ecommerce_app/view/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String category = "All";
  bool showLocation = false;
  String selectedLocation = "Hyderabad";

  final List<String> locations = ["Hyderabad"];

  @override
  Widget build(BuildContext context) {
    final viewProvider = context.watch<ViewProvider>();
    double width = MediaQuery.of(context).size.width;

    // responsive counts
    int productCount = (width ~/ 250) < 2 ? 2 : (width ~/ 250);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(21.0),
            child: Column(
              children: [
                // header Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.location_pin, color: Colors.blue.shade700),
                    Text(
                      "Delivery To ",
                      style: AppTextStyle.withColor(
                        Colors.grey.shade700,
                        AppTextStyle.bodyMedium,
                      ),
                    ),
                    Text(
                      selectedLocation,
                      style: AppTextStyle.withColor(
                        Colors.black,
                        AppTextStyle.h3,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showLocation = !showLocation;
                        });
                      },
                      child: Icon(
                        showLocation
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.blue,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.notifications, color: Colors.grey.shade700),
                    SizedBox(width: 10),
                    IconButton(
                      style: IconButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(15),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FavoriteScreen(),
                          ),
                        );
                      },
                      icon: Icon(Icons.favorite_border_outlined),
                    ),
                  ],
                ),
                // 🔽 Location Dropdown
                if (showLocation)
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: locations.map((loc) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedLocation = loc;
                              showLocation = false;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Text(loc, style: TextStyle(fontSize: 16)),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                SizedBox(height: 15),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Search for Anything",
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                SizedBox(height: 15),
                // Banner Section
                BannerSlider(),
                SizedBox(height: 15),

                // Categories Section
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Categories",
                    style: AppTextStyle.withColor(
                      Colors.black,
                      AppTextStyle.h3,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                CategoryGrid(
                  onCategorySelected: (value) {
                    setState(() {
                      category = value;
                    });
                  },
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Special For You", style: AppTextStyle.h3),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewAllScreen(),
                          ),
                        );
                      },
                      child: Text(
                        viewProvider.viewAll ? "View All " : "View Less ",
                        style: AppTextStyle.withColor(
                          Colors.blue,
                          AppTextStyle.bodyLarge,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 15),
                //  for Shopping Item
                StreamBuilder(
                  stream: category == "All"
                      ? FirebaseFirestore.instance
                            .collection('products')
                            .snapshots()
                      : FirebaseFirestore.instance
                            .collection('products')
                            .where(
                              'category',
                              isEqualTo: category.toLowerCase(),
                            )
                            .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    var docs = snapshot.data!.docs;

                    return SizedBox(
                      height: 420,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: viewProvider.viewAll
                            ? docs.length
                            : min(3, docs.length),
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
                          return SizedBox(
                            width: 220,
                            child: Padding(
                              padding: EdgeInsets.only(right: 12),
                              child: ProductCard(
                                product: product,
                                isGrid: false,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
