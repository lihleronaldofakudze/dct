import 'package:dreams_come_true/models/Order.dart';
import 'package:dreams_come_true/services/database.dart';
import 'package:dreams_come_true/widget/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminOrderScreen extends StatelessWidget {
  const AdminOrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderId = ModalRoute.of(context)!.settings.arguments as String;
    return StreamBuilder<Order>(
      stream: DatabaseService(orderId: orderId).order,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Order? order = snapshot.data;
          return Scaffold(
            backgroundColor: Colors.brown.shade50,
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.black),
              backgroundColor: Colors.brown.shade50,
              elevation: 0.0,
              title: Text(
                order!.orderName,
                style: TextStyle(color: Colors.black),
              ),
              actions: [
                TextButton(
                    onPressed: () {},
                    child: Text(
                      'E ${double.parse((order.total).toStringAsFixed(2))}0',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ))
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    title: Text('Order Status'),
                    trailing: Text(
                      order.orderStatus,
                      style: TextStyle(
                          color: _getStatusColor(status: order.orderStatus),
                          fontWeight: FontWeight.bold,
                          fontSize: 24),
                    ),
                  ),
                  ListTile(
                    title: Text('Customer Number'),
                    trailing: Text(
                      order.uid,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                  ),
                  Text('Order Details'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                        children: order.orderDetails.map((e) {
                      return Card(
                        child: Column(
                          children: [
                            Container(
                              height: 200,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(e.image),
                                    fit: BoxFit.contain),
                              ),
                            ),
                            ListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 15),
                              title: Text(e.title),
                              subtitle: Text('Title'),
                            ),
                            ListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 15),
                              title: Text(
                                  'E ${double.parse((e.price).toStringAsFixed(2))}0'),
                              subtitle: Text('Price'),
                            ),
                            ListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 15),
                              title: Text('${e.quantity}'),
                              subtitle: Text('Quantity'),
                            ),
                          ],
                        ),
                      );
                    }).toList()),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (order.orderStatus == 'Pending') ...[
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.orange),
                        onPressed: () async {
                          await DatabaseService(orderId: order.id)
                              .updateOrderStatus(status: 'Cancelled')
                              .then((value) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(new SnackBar(
                              content: Text('Successfully Cancelled'),
                            ));
                          });
                        },
                        child: Text('Cancel')),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.green),
                        onPressed: () async {
                          await DatabaseService(orderId: order.id)
                              .updateOrderStatus(status: 'Successful')
                              .then((value) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(new SnackBar(
                              content: Text('Order was made successful'),
                            ));
                          });
                        },
                        child: Text('Make Order Successful')),
                  ] else if (order.orderStatus == 'Cancelled' ||
                      order.orderStatus == 'Successful') ...[
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.red),
                        onPressed: () async {
                          await DatabaseService(orderId: order.id)
                              .deleteOrder()
                              .then((value) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(new SnackBar(
                              content: Text('Successfully Delete'),
                            ));
                            Navigator.pushNamed(context, '/admin');
                          });
                        },
                        child: Text('Delete'))
                  ],
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          );
        } else {
          return Loading();
        }
      },
    );
  }
}

_getStatusColor({required String status}) {
  if (status == 'Pending') {
    return Colors.orange;
  } else if (status == 'Cancelled') {
    return Colors.red;
  } else if (status == 'Successful') {
    return Colors.green;
  }
}
