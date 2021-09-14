import 'package:dreams_come_true/models/Cart.dart';
import 'package:dreams_come_true/models/Customer.dart';
import 'package:dreams_come_true/models/RegisteredUser.dart';
import 'package:dreams_come_true/services/database.dart';
import 'package:dreams_come_true/widget/cart_list.dart';
import 'package:dreams_come_true/widget/loading.dart';
import 'package:dreams_come_true/widget/ok_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final registeredUser = Provider.of<RegisteredUser?>(context);
    return StreamBuilder<Customer>(
        stream: DatabaseService(uid: registeredUser!.number).customer,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Customer? customer = snapshot.data;
            return Scaffold(
              backgroundColor: Colors.brown.shade50,
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) => okAlertDialog(
                          message:
                              'Please pay for products via MTN MOMO +26878230372',
                          context: context));
                },
                icon: Icon(Icons.done),
                label: Text('Check Out'),
              ),
              appBar: AppBar(
                iconTheme: IconThemeData(color: Colors.black),
                backgroundColor: Colors.brown.shade50,
                leading: IconButton(
                    onPressed: () async {
                      await Share.share(
                          'Dream Come True Online Shopping App : http://play.google.com/store/apps/details?id=io.cloutdevelopers.dreams_come_true');
                    },
                    icon: Icon(Icons.shop_rounded)),
                title: Text(
                  'Cart',
                  style: TextStyle(color: Colors.black),
                ),
                elevation: 0.0,
                actions: [
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        'Total = E ${customer!.cartAmount}',
                        style: TextStyle(fontSize: 18),
                      )),
                  Stack(
                    children: [
                      Icon(Icons.shopping_cart_rounded),
                    ],
                  ),
                ],
              ),
              body: StreamProvider<List<Cart>>.value(
                value: DatabaseService(uid: registeredUser.number).cart,
                initialData: [],
                child: CartList(),
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
