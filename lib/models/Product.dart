import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String title;
  final String image;
  final String brand;
  final String sizes;
  final String style;
  final String category;
  final double price;
  final dynamic likes;
  final dynamic colors;
  final Timestamp postedAt;

  Product(
      {required this.id,
      required this.title,
      required this.image,
      required this.brand,
      required this.sizes,
      required this.style,
      required this.category,
      required this.price,
      this.likes,
      this.colors,
      required this.postedAt});
}
