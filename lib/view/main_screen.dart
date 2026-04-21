import 'package:ecommerce_app/controller/navigationController.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import 'orderScreen.dart';
import 'cart_screen.dart';
import 'profileScreen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = context.watch<NavigationController>();
    final screens = [
      const HomeScreen(),
      const CartScreen(),
      const ProfileScreen(),
      OrderScreen(),
    ];

    return Scaffold(

      body:SafeArea(
        bottom: false,
        child: screens[nav.currentIndex],),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10,
        backgroundColor: Colors.blueGrey.shade50,
        type: BottomNavigationBarType.fixed,
        currentIndex: nav.currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black54,
        showUnselectedLabels: true,
        onTap: (value) {
          print("Tapped index: $value");  // ← add this
          nav.changeIndex(value);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: "Orders",
          ),
        ],
      ),
    );
  }
}
