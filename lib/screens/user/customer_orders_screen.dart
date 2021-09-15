import 'package:dreams_come_true/models/Order.dart';
import 'package:dreams_come_true/models/RegisteredUser.dart';
import 'package:dreams_come_true/services/database.dart';
import 'package:dreams_come_true/widget/customer_orders_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerOrdersScreen extends StatelessWidget {
  const CustomerOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final registeredUser = Provider.of<RegisteredUser?>(context);
    return Scaffold(
      backgroundColor: Colors.brown.shade50,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.brown.shade50,
        elevation: 0.0,
        title: Text(
          'My Orders',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: StreamProvider<List<Order>>.value(
        value: DatabaseService(uid: registeredUser!.number).customerOrders,
        initialData: [],
        child: CustomerOrdersList(),
      ),
    );
  }
}
