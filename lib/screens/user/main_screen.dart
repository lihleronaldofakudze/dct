import 'package:dreams_come_true/widget/main_list.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final header = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      backgroundColor: Colors.brown.shade50,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.brown.shade50,
        elevation: 0.0,
        title: Text(
          header,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: MainList(),
    );
  }
}
