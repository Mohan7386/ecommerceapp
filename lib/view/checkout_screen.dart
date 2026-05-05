import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/controller/auth_controller.dart';
import 'package:ecommerce_app/controller/cart_provider.dart';
import 'package:ecommerce_app/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final pincodeController = TextEditingController();

  String selectedPayment = "COD"; // COD or Online
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = context.read<AuthProvider>().user;
    if (user == null) return;

    nameController.text = user.displayName ?? '';

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (doc.exists) {
      phoneController.text = doc['phone'] ?? '';
    }
  }

  Future<void> _placeOrder() async {
    if(isLoading) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final user = context.read<AuthProvider>().user;
      final cart = context.read<CartProvider>().cart;
      final total = context.read<CartProvider>().totalPrice;

      // Firestore data save
      await FirebaseFirestore.instance.collection('orders').add({
        "userId": user?.uid,
        "userName": nameController.text.trim(),
        "phone": phoneController.text.trim(),
        "address": addressController.text.trim(),
        "city": cityController.text.trim(),
        "pincode": pincodeController.text.trim(),
        "paymentMethod": selectedPayment,
        "totalAmount": total,
        "status": "pending",
        "createdAt": FieldValue.serverTimestamp(),
        "items": cart.map((item) => {
          "productId": item.id,
          "title": item.title,
          "price": item.price,
          "quantity": item.quantity,
          "image": item.images[0],
        }).toList(),
      });

      // Cart clear
      context.read<CartProvider>().clearCart();

      if (!mounted) return;

      // Success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 70),
              SizedBox(height: 16),
              Text("Order Placed!", style: AppTextStyle.h2),
              SizedBox(height: 8),
              Text(
                "Your order has been placed successfully!",
                textAlign: TextAlign.center,
                style: AppTextStyle.bodyMedium,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Text("OK", style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Something went wrong: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout", style: AppTextStyle.h3),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shipping Address
              Text("Shipping Address", style: AppTextStyle.h3),
              SizedBox(height: 12),
              _buildTextField(nameController, "Full Name", Icons.person),
              SizedBox(height: 12),
              _buildTextField(phoneController, "Phone", Icons.phone,
                  keyboardType: TextInputType.phone),
              SizedBox(height: 12),
              _buildTextField(addressController, "Address", Icons.home,
                  maxLines: 2),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(cityController, "City",
                        Icons.location_city),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                        pincodeController, "Pincode", Icons.pin,
                        keyboardType: TextInputType.number),
                  ),
                ],
              ),
              SizedBox(height: 24),

              // Payment Method
              Text("Payment Method", style: AppTextStyle.h3),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _paymentOption(
                      "COD",
                      "Cash on Delivery",
                      Icons.money,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _paymentOption(
                      "Online",
                      "Online Payment",
                      Icons.credit_card,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),

              // Order Summary
              Text("Order Summary", style: AppTextStyle.h3),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ...cart.cart.map((item) => Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item.images[0],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item.title,
                              style: AppTextStyle.bodyMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            "x${item.quantity}",
                            style: AppTextStyle.bodySmall,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "₹${(item.price * item.quantity).toStringAsFixed(2)}",
                            style: AppTextStyle.withWeight(
                                FontWeight.bold, AppTextStyle.bodyMedium),
                          ),
                        ],
                      ),
                    )),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total", style: AppTextStyle.h3),
                        Text(
                          "₹${cart.totalPrice.toStringAsFixed(2)}",
                          style: AppTextStyle.withColor(
                              Colors.blue, AppTextStyle.h3),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),

      // Place Order Button
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: isLoading ? null : _placeOrder,
            child: isLoading
                ? CircularProgressIndicator(color: Colors.white)
                : Text(
              "Place Order",
              style: AppTextStyle.withColor(
                  Colors.white, AppTextStyle.buttonMedium),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      IconData icon, {
        TextInputType keyboardType = TextInputType.text,
        int maxLines = 1,
      }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (v) => v == null || v.isEmpty ? "$label required" : null,
    );
  }

  Widget _paymentOption(String value, String label, IconData icon) {
    final isSelected = selectedPayment == value;
    return GestureDetector(
      onTap: () => setState(() => selectedPayment = value),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.grey.shade100,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    cityController.dispose();
    pincodeController.dispose();
    super.dispose();
  }
}
