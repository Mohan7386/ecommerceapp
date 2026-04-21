import 'order_status.dart';

class OrderRepository {
  List<OrderItem> getOrders() {
    return [
      OrderItem(
        name: 'Mac Air Pro',
        totalAmount: 200,
        imageUrl: 'assets/images/laptop.jpg',
        orderDate: DateTime.now(),
        orderId: '457452',
        status: OrderStatus.pending,
      ),
      OrderItem(
        name: 'T-shirt',
        totalAmount: 60,
        imageUrl: 'assets/images/t-shirt.jpg',
        orderDate: DateTime.now(),
        orderId: '785783',
        status: OrderStatus.pending,
      ),
      OrderItem(
        name: 'shoe',
        totalAmount: 30.5,
        imageUrl: 'assets/images/casual shoes.jpg',
        orderDate: DateTime.now(),
        orderId: '42574',
        status: OrderStatus.pending,
      ),
      OrderItem(
        name:'shoes',
        totalAmount: 50.12,
        imageUrl: 'assets/images/shoe2.jpg',
        orderDate: DateTime.now(),
        orderId: '742846',
        status: OrderStatus.received,
      ),
    ];
  }

  List<OrderItem> getOrderByStatus(OrderStatus status) {
    return getOrders().where((order) => order.status == status).toList();
  }
}
