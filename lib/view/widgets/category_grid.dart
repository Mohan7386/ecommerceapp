import 'package:ecommerce_app/utils/app_text_styles.dart';
import 'package:ecommerce_app/view/widgets/category.dart';
import 'package:flutter/material.dart';

class CategoryGrid extends StatefulWidget {
  const CategoryGrid({super.key});

  @override
  State<CategoryGrid> createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 3,
        mainAxisSpacing: 3,
        crossAxisCount: 3,
      ),
      itemBuilder: (BuildContext context, int index) {
        final category = categories[index];
        final isSelected = selectedIndex == index;
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
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
  }
}
