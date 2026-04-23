import 'dart:math';
import 'package:ecommerce_app/controller/view_controller.dart';
import 'package:ecommerce_app/utils/app_text_styles.dart';
import 'package:ecommerce_app/view/favorite_screen.dart';
import 'package:ecommerce_app/view/widgets/carosel_slider.dart';
import 'package:ecommerce_app/view/widgets/category_grid.dart';
import 'package:ecommerce_app/view/widgets/custom_textField.dart';
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
  bool showLocation = false;
  String selectedLocation = "Hyderabad";

  final List<String> locations = [
    "Hyderabad",
  ];

  @override
  Widget build(BuildContext context) {
    final viewProvider = context.watch<ViewProvider>();
    double width = MediaQuery.of(context).size.width;

    // responsive counts
    int productCount = (width ~/ 250) < 2 ? 2 : (width ~/ 250);
    int categoryCount = width > 800 ? 6 : 3;

    return Scaffold(
      backgroundColor: Colors.white,
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
                            child: Text(
                              loc,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                SizedBox(height: 15),
                CustomTextField(label: "Search", prefixIcon: Icons.search),
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
                CategoryGrid(),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Special For You", style: AppTextStyle.h3),
                    TextButton(
                      onPressed: () {
                        context.read<ViewProvider>().changeView();
                      },
                      child: Text(
                        viewProvider.viewAll ? "View Less" : "View All",
                        style: AppTextStyle.withColor(
                          Colors.blue,
                          AppTextStyle.bodyLarge,
                        ),
                      ),
                    ),
                  ],
                ), // Row for Special For You

                SizedBox(height: 15),
                // for Shopping Item
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: viewProvider.viewAll
                      ? products.length
                      : min(2, products.length),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: productCount,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.78,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return ProductCard(product: products[index]);
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
