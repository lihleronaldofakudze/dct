import 'package:cloud_firestore/cloud_firestore.dart';

class Cart {
  final String id;
  final String image;
  final String title;
  final String style;
  final double price;
  final Timestamp addedAt;
  final int quantity;

  Cart(
      {required this.id,
      required this.image,
      required this.title,
      required this.style,
      required this.price,
      required this.addedAt,
      required this.quantity});
}
