class Order {
  final String id;
  final String uid;
  final String orderName;
  final String orderStatus;
  final double total;
  final List orderDetails;

  Order(
      {required this.id,
      required this.uid,
      required this.orderName,
      required this.orderStatus,
      required this.total,
      required this.orderDetails});
}
