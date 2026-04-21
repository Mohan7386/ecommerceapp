// import 'package:ecommerce_app/controller/navigationController.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class CustomBottomNavBar extends StatelessWidget {
//   const CustomBottomNavBar({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final navigationController = Provider.of<NavigationController>(context);
//     return BottomNavigationBar(
//       selectedItemColor: Colors.blue,
//       unselectedItemColor: Colors.grey,
//       showUnselectedLabels: true,
//       type: BottomNavigationBarType.fixed,
//       currentIndex: navigationController.currentIndex,
//       onTap: (index) => context.read<NavigationController>().changeIndex(index),
//       items: [
//         BottomNavigationBarItem(
//           activeIcon: Icon(Icons.home),
//           icon: Icon(Icons.home_outlined),
//           label: 'Home',
//         ),
//         BottomNavigationBarItem(
//           activeIcon: Icon(Icons.shopping_bag),
//           icon: Icon(Icons.shopping_bag_outlined),
//           label: 'Orders',
//         ),
//         BottomNavigationBarItem(
//           activeIcon: Icon(Icons.shopping_cart),
//           icon: Icon(Icons.shopping_cart_outlined),
//           label: 'Cart',
//         ),
//         BottomNavigationBarItem(
//           activeIcon: Icon(Icons.person),
//           icon: Icon(Icons.person_2_outlined),
//           label: 'Profile',
//         ),
//         ]
//     );
//   }
// }
