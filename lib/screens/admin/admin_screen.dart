import 'package:dreams_come_true/screens/admin/admin_orders_screen.dart';
import 'package:dreams_come_true/widget/admin_product_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/add_product');
          },
          child: Icon(Icons.add_rounded),
        ),
        appBar: AppBar(
          title: Text(
            'Admin Panel',
            style: GoogleFonts.bellotaText(),
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Products'),
              Tab(text: 'Orders'),
            ],
          ),
        ),
        body: TabBarView(children: [AdminProductList(), AdminOrdersScreen()]),
      ),
    );
  }
}
