

enum OrderStatus { pending, received }

class OrderItem {
  final String name;
  final String orderId;
  final double totalAmount;
  final OrderStatus status;
  final String imageUrl;
  final DateTime orderDate;

  OrderItem({
    required this.name,
    required this.totalAmount,
    required this.imageUrl,
    required this.orderDate,
    required this.orderId,
    required this.status,
  });
  String get statusString => status.name;
}
