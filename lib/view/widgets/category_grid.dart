import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/utils/app_text_styles.dart';
import 'package:ecommerce_app/view/widgets/category.dart';
import 'package:flutter/material.dart';

class CategoryGrid extends StatefulWidget {
  final Function(String) onCategorySelected;
  const CategoryGrid({super.key, required this.onCategorySelected});

  @override
  State<CategoryGrid> createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  String category = "All";
  //final CollectionReference categoriesItems = FirebaseFirestore.instance.collection("App-Category");
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    int categoryCount = width > 800 ? 6 : 3;

    return StreamBuilder(
      stream: category == "All"
          ? FirebaseFirestore.instance.collection('products').snapshots()
          : FirebaseFirestore.instance
                .collection('products')
                .where('category', isEqualTo: category.toLowerCase())
                .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 3,
            mainAxisSpacing: 3,
            crossAxisCount: categoryCount,
          ),
          itemBuilder: (BuildContext context, int index) {
            final category = categories[index];
            final isSelected = selectedIndex == index;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
                widget.onCategorySelected(category.name);
              },
              child: AnimatedScale(
                scale: selectedIndex == index ? 1.18 : 1.0,
                duration: Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: category.backgroundColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(category.icon, color: category.iconColor),
                    ),
                    SizedBox(height: 5),
                    Text(
                      category.name,
                      style: AppTextStyle.withColor(
                        isSelected ? Colors.blue : Colors.grey,
                        AppTextStyle.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
