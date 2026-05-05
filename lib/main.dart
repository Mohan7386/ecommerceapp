import 'package:ecommerce_app/controller/auth_controller.dart';
import 'package:ecommerce_app/controller/banner_controller.dart';
import 'package:ecommerce_app/controller/cart_provider.dart';
import 'package:ecommerce_app/controller/favorite_provider.dart';
import 'package:ecommerce_app/controller/navigation_controller.dart';
import 'package:ecommerce_app/controller/view_controller.dart';
import 'package:ecommerce_app/firebase_options.dart';
import 'package:ecommerce_app/view/main_screen.dart';
import 'package:ecommerce_app/view/sign_in_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => NavigationController()),
        ChangeNotifierProvider(create: (context) => BannerProvider()),
        ChangeNotifierProvider(create: (context) => ViewProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
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
    final auth = context.watch<AuthProvider>();

    if (auth.user != null) {
      context.read<CartProvider>().setUserId(auth.user!.uid);
    }

    if (!auth.isInitialized) {
      return MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
        debugShowCheckedModeBanner: false,
      );
    }

    return MaterialApp(
      home: auth.isLoggedIn ? MainScreen() : SignInScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}