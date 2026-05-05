import 'package:ecommerce_app/controller/cart_provider.dart';
import 'package:ecommerce_app/controller/navigation_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import 'order_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = context.watch<NavigationController>();
    final cartCount = context.watch<CartProvider>().cartCount;

    final screens = [
      const HomeScreen(),
      const CartScreen(),
      const ProfileScreen(),
      OrderScreen(),
    ];

    return Scaffold(
      body: SafeArea(bottom: false, child: screens[nav.currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10,
        backgroundColor: Colors.blueGrey.shade50,
        type: BottomNavigationBarType.fixed,
        currentIndex: nav.currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black54,
        showUnselectedLabels: true,
        onTap: (value) {
          if (kDebugMode) {
            print("Tapped index: $value");
          }
          nav.changeIndex(value);
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.shopping_cart),
                if (cartCount > 0)
                  Positioned(
                    right: -6,
                    top: -6,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Text(
                        '$cartCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            label: "Cart",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: "Profile",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: "Orders",
          ),
        ],
      ),
    );
  }
}
