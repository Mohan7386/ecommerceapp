import 'package:ecommerce_app/controller/cart_provider.dart';
import 'package:ecommerce_app/utils/app_text_styles.dart';
import 'package:ecommerce_app/view/checkout_screen.dart';
import 'package:ecommerce_app/view/widgets/total_price_cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CartProvider>();
    final cartList = provider.cart;

    Widget productQuantity(IconData icon, int index) {
      return GestureDetector(
        onTap: () {
          icon == Icons.add
              ? provider.incrementQnt(index)
              : provider.decrementQnt(index);
        },
        child: Icon(icon, size: 20),
      );
    }
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Spacer(),
                  Text("My Cart ", style: AppTextStyle.h2),
                  Spacer(),
                ],
              ),
            ),

            // list products
            ListView.builder(
              itemCount: cartList.length,
              shrinkWrap: true, // important
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final cartItems = cartList[index];
                return Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        // padding: EdgeInsets.all(20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              // image
                              child: Image.network(
                                cartItems.images[0],
                                fit: BoxFit.cover,
                                width: 100,
                                height: 105,
                              ),
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cartItems.title,
                                    style: AppTextStyle.withWeight(
                                      FontWeight.bold,
                                      AppTextStyle.bodyLarge,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    cartItems.category,
                                    style: AppTextStyle.bodyLarge,
                                  ),

                                  SizedBox(height: 10),
                                  Text(
                                    "₹${cartItems.price.toStringAsFixed(2)}",
                                    style: AppTextStyle.withWeight(
                                      FontWeight.bold,
                                      AppTextStyle.h3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 15,
                      right: 30,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              provider.removeFromCart(index);
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              border: Border.all(
                                color: Colors.grey.shade200,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                productQuantity(Icons.add, index),
                                SizedBox(width: 10),
                                Text(
                                  cartItems.quantity.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(width: 10),
                                productQuantity(Icons.remove, index),
                                SizedBox(width: 10),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                );
              },
            ),
            SizedBox(height: 10),
            TotalPriceCart(),
            SizedBox(height: 10),
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF6397FF), Color(0xFF4376F7)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => CheckoutScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Proceed To Checkout",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
