import 'package:ecommerce_app/utils/app_text_styles.dart';
import 'package:ecommerce_app/view/widgets/custom_textField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/cart_provider.dart';

class TotalPriceCart extends StatelessWidget {
  const TotalPriceCart({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CartProvider>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// 🔹 Coupon
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    label: "Enter Discount Code",
                    prefixIcon: Icons.local_offer_outlined,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue
                  ),
                    onPressed: () {},
                    child: Text("Apply", style: AppTextStyle.withColor(Colors.white, AppTextStyle.bodyLarge))),
              ],
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.topLeft,
              child: Text("Price Details", style: AppTextStyle.h3),
            ),
            SizedBox(height: 20),
            //  SubTotal
            /// 🔹 Subtotal
            priceRow(
              "SubTotal",
              "₹${provider.totalPrice().toStringAsFixed(0)}",
            ),

            /// 🔹 Delivery
            priceRow("Delivery Fee", "Free", color: Colors.green),

            /// 🔹 Platform fee
            priceRow("Platform Fee", "₹5"),

            /// 🔹 Discount (dummy)
            // priceRow("Discount", "-₹200", color: Colors.green),
            const SizedBox(height: 10),
            Divider(),
            const SizedBox(height: 10),

            /// 🔹 Total
            priceRow(
              "Total",
              "₹${(provider.totalPrice() + 5).toStringAsFixed(0)}",
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }
}

Widget priceRow(
  String title,
  String value, {
  Color? color,
  bool isBold = false,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyle.bodyLarge),
        Text(
          value,
          style: TextStyle(
            color: color ?? Colors.black,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: 16,
          ),
        ),
      ],
    ),
  );
}
