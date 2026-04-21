import 'package:ecommerce_app/view/widgets/orderCard.dart';
import 'package:ecommerce_app/view/widgets/orderData.dart';
import 'package:ecommerce_app/view/widgets/order_status.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  final OrderRepository _repository = OrderRepository();
  OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child:
      Scaffold(
        appBar: AppBar(
          title: Text("My Orders"),
          centerTitle: true,
          automaticallyImplyLeading: false,
          bottom: TabBar(
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.blue,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(text: "Pending Orders",),
              Tab(text: "Received Orders"),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TabBarView(
            children: [
              _orderList(context, OrderStatus.pending),
              _orderList(context, OrderStatus.received),
            ],
          ),
        ),
      ),
    );
  }

  Widget _orderList(BuildContext context, OrderStatus status) {
    final orders = _repository.getOrderByStatus(status);

    return ListView.builder(
      itemCount: orders.length,
      //shrinkWrap: true,
      // physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return OrderCard(orderItem: orders[index],);
      },
    );
  }
}

