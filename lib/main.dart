import 'package:ecommerce_app/controller/auth_controller.dart';
import 'package:ecommerce_app/controller/banner_controller.dart';
import 'package:ecommerce_app/controller/cart_provider.dart';
import 'package:ecommerce_app/controller/favorite_provider.dart';
import 'package:ecommerce_app/controller/navigationController.dart';
import 'package:ecommerce_app/controller/view_controller.dart';
import 'package:ecommerce_app/view/main_screen.dart';
import 'package:ecommerce_app/view/signIn_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => NavigationController()),
        ChangeNotifierProvider(create: (context) => BannerProvider()),
        ChangeNotifierProvider(create: (context) => ViewProvider()),
        ChangeNotifierProvider(create: (_)=> CartProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.watch<AuthProvider>().isLoggedIn;
    return MaterialApp(
      home: isLoggedIn ? MainScreen() : SignInScreen(),
      //home: SignupScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
