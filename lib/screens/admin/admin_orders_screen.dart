import 'package:dreams_come_true/models/Order.dart';
import 'package:dreams_come_true/services/database.dart';
import 'package:dreams_come_true/widget/admin_orders_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamProvider<List<Order>>.value(
        value: DatabaseService().orders,
        initialData: [],
        child: AdminOrdersList(),
      ),
    );
  }
}
