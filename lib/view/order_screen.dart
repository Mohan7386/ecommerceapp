import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/controller/auth_provider.dart';
import 'package:ecommerce_app/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Orders", style: AppTextStyle.h3),
          centerTitle: true,
          automaticallyImplyLeading: false,
          bottom: TabBar(
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.blue,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(text: "Pending Orders"),
              Tab(text: "Received Orders"),
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: TabBarView(
            children: [
              _OrderList(status: "pending"),
              _OrderList(status: "received"),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderList extends StatelessWidget {
  final String status;
  const _OrderList({required this.status});

  @override
  Widget build(BuildContext context) {
    final uid = context.read<AuthProvider>().user?.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: uid)
          .where('status', isEqualTo: status)
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        // Error
        if (snapshot.hasError) {
          return Center(child: Text("Something went wrong"));
        }

        // Empty
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  status == "pending" ? "No Pending Orders" : "No Received Orders",
                  style: AppTextStyle.h3,
                ),
              ],
            ),
          );
        }

        final orders = snapshot.data!.docs;

        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index].data() as Map<String, dynamic>;
            final items = (order['items'] as List<dynamic>?) ?? [];

            return Container(
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order ID & Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Order #${orders[index].id.substring(0, 8).toUpperCase()}",
                          style: AppTextStyle.withWeight(
                              FontWeight.bold, AppTextStyle.bodyMedium),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: status == "pending"
                                ? Colors.orange.shade100
                                : Colors.green.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            status == "pending" ? "Pending" : "Received",
                            style: TextStyle(
                              color: status == "pending"
                                  ? Colors.orange
                                  : Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),

                    // Items
                    ...items.map((item) => Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item['image'] ?? '',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey.shade200,
                                child: Icon(Icons.image_not_supported),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title'] ?? '',
                                  style: AppTextStyle.bodyMedium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "Qty: ${item['quantity']}",
                                  style: AppTextStyle.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "₹${item['price']}",
                            style: AppTextStyle.withWeight(
                                FontWeight.bold, AppTextStyle.bodyMedium),
                          ),
                        ],
                      ),
                    )),

                    Divider(),

                    // Total & Payment
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Payment: ${order['paymentMethod'] ?? 'COD'}",
                          style: AppTextStyle.bodySmall,
                        ),
                        Text(
                          "Total: ₹${order['totalAmount']?.toStringAsFixed(0) ?? '0'}",
                          style: AppTextStyle.withWeight(
                              FontWeight.bold, AppTextStyle.bodyLarge),
                        ),
                      ],
                    ),

                    SizedBox(height: 8),

                    // Address
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined,
                            size: 16, color: Colors.grey),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            "${order['address'] ?? ''}, ${order['city'] ?? ''} - ${order['pincode'] ?? ''}",
                            style: AppTextStyle.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
