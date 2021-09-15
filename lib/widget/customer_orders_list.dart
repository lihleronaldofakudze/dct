import 'package:dreams_come_true/models/Order.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class CustomerOrdersList extends StatelessWidget {
  const CustomerOrdersList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<List<Order>>(context);
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/customer_order',
                arguments: orders[index].id);
          },
          child: Card(
            child: Column(
              children: [
                ListTile(
                  title: Text('Order Name'),
                  trailing: Text(
                    orders[index].orderName,
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.brown,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  title: Text('Order Status'),
                  trailing: Text(
                    orders[index].orderStatus,
                    style: TextStyle(
                        color:
                            _getStatusColor(status: orders[index].orderStatus),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  title: Text('Order Total'),
                  trailing: Text(
                    'E ${double.parse((orders[index].total).toStringAsFixed(2))}0',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
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
