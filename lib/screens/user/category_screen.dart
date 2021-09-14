import 'package:dreams_come_true/models/Product.dart';
import 'package:dreams_come_true/services/database.dart';
import 'package:dreams_come_true/widget/main_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final category = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      backgroundColor: Colors.brown.shade50,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.brown.shade50,
        title: Text(
          category.toString(),
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: StreamProvider<List<Product>>.value(
        value: DatabaseService(productCategory: category.toString())
            .productByCategory,
        initialData: [],
        child: MainList(),
      ),
    );
  }
}
