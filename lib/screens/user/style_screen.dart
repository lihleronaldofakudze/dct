import 'package:dreams_come_true/models/Product.dart';
import 'package:dreams_come_true/services/database.dart';
import 'package:dreams_come_true/widget/main_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StyleScreen extends StatelessWidget {
  const StyleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      backgroundColor: Colors.brown.shade50,
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.brown.shade50,
        title: Text(
          style,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: StreamProvider<List<Product>>.value(
        value: DatabaseService(style: style).productByStyles,
        initialData: [],
        child: MainList(),
      ),
    );
  }
}
