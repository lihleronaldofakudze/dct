import 'package:dreams_come_true/models/Cart.dart';
import 'package:dreams_come_true/models/Customer.dart';
import 'package:dreams_come_true/models/RegisteredUser.dart';
import 'package:dreams_come_true/services/database.dart';
import 'package:dreams_come_true/widget/cart_list.dart';
import 'package:dreams_come_true/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _orderNameController = TextEditingController();
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
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            title: Text('Check Out'),
                            content: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Please pay 50% deposit to confirm your order.\nPayments via MOMO +26878230372.',
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.red),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextField(
                                  maxLength: 20,
                                  decoration: InputDecoration(
                                      labelText: 'Order Name',
                                      border: OutlineInputBorder()),
                                  controller: _orderNameController,
                                )
                              ],
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancel')),
                              TextButton(
                                  onPressed: () async {
                                    if (_orderNameController.text.isNotEmpty) {
                                      await DatabaseService(
                                              uid: registeredUser.number)
                                          .checkOut(
                                              total: customer!.cartAmount,
                                              orderName:
                                                  _orderNameController.text)
                                          .then((value) {
                                        Navigator.pop(context);
                                        _orderNameController.clear();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(new SnackBar(
                                                content: Text(
                                                    'Order Made Successfully')));
                                      });
                                    } else {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(new SnackBar(
                                              content: Text(
                                                  'Enter Order Name First.')));
                                    }
                                  },
                                  child: Text('Make Order')),
                            ],
                          ));
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
                        'Total = E ${double.parse((customer!.cartAmount).toStringAsFixed(2))}0',
                        style: TextStyle(fontSize: 18),
                      )),
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
