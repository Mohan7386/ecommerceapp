import 'package:flutter/material.dart';

class CategoryModel {
  final String name;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  CategoryModel({
    required this.name,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });
}

final List<CategoryModel> categories = [
  CategoryModel(
    name: "All",
    icon: Icons.apps,
    iconColor: Colors.blue,
    backgroundColor: Colors.blue.withValues(alpha: 0.1),
  ),
  CategoryModel(
    name: "Men",
    icon: Icons.man,
    iconColor: Colors.blue,
    backgroundColor: Colors.blue.withValues(alpha: 0.1),
  ),
  CategoryModel(
    name: "Women",
    icon: Icons.woman,
    iconColor: Colors.green,
    backgroundColor: Colors.green.withValues(alpha: 0.1),
  ),
  CategoryModel(
    name: "Kids",
    icon: Icons.baby_changing_station,
    iconColor: Colors.orange,
    backgroundColor: Colors.orange.withValues(alpha: 0.1),
  ),
  CategoryModel(
    name: "Accessories",
    icon: Icons.watch,
    iconColor: Colors.purple,
    backgroundColor: Colors.purple.withValues(alpha: 0.1),
  ),
  CategoryModel(
    name: "Shoes",
    icon: Icons.sports_basketball,
    iconColor: Colors.green,
    backgroundColor: Colors.green.withValues(alpha: 0.1),
  ),
];
