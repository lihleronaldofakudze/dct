import 'dart:io';

import 'package:dreams_come_true/models/Product.dart';
import 'package:dreams_come_true/models/RegisteredUser.dart';
import 'package:dreams_come_true/services/database.dart';
import 'package:dreams_come_true/widget/loading.dart';
import 'package:dreams_come_true/widget/ok_alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final registeredUser = Provider.of<RegisteredUser?>(context);
    return StreamBuilder<Product>(
      stream: DatabaseService(productId: productId).product,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Product? product = snapshot.data;
          return Scaffold(
            backgroundColor: Colors.brown.shade50,
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.black),
              backgroundColor: Colors.brown.shade50,
              elevation: 0.0,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/style',
                        arguments: product!.style);
                  },
                  child: Text(
                    product!.style,
                    style: TextStyle(fontSize: 18),
                  ),
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 400,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(product.image))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    title: Text(
                      product.title,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    trailing: IconButton(
                        onPressed: () async {
                          final url = Uri.parse(product.image);
                          final response = await http.get(url);
                          final bytes = response.bodyBytes;
                          final temp = await getTemporaryDirectory();
                          final path = '${temp.path}/image.png';
                          File(path).writeAsBytes(bytes);
                          await Share.shareFiles([path],
                              text:
                                  'Title : ${product.title}\nPrice : ${product.price}\Brand : ${product.brand}',
                              subject:
                                  'Title : ${product.title}\nPrice : ${product.price}\NBrand : ${product.brand}');
                        },
                        icon: Icon(Icons.share_rounded)),
                  ),
                  ListTile(
                    title: Text(
                      'E ${product.price}',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    trailing: IconButton(
                        onPressed: () async {
                          if (product.likes.contains(registeredUser!.number)) {
                            await DatabaseService(
                                    uid: registeredUser.number,
                                    productId: product.id)
                                .unLike();
                          } else {
                            await DatabaseService(
                                    uid: registeredUser.number,
                                    productId: product.id)
                                .like();
                          }
                        },
                        icon: product.likes.contains(registeredUser!.number)
                            ? Icon(
                                Icons.favorite_rounded,
                                color: Colors.red,
                              )
                            : Icon(Icons.favorite_border_rounded)),
                  ),
                  ListTile(
                    title: Text(
                      'sizes',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    subtitle: Text(product.sizes,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                  ListTile(
                    title: Text(
                      'brand',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    subtitle: Text(product.brand,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () async {
                        await DatabaseService(
                                uid: registeredUser.number,
                                productId: product.id)
                            .addToCart(
                                image: product.image,
                                title: product.title,
                                style: product.style,
                                price: product.price,
                                quantity: 1)
                            .then((value) {
                          showDialog(
                              context: context,
                              builder: (_) => okAlertDialog(
                                  context: context,
                                  message: '${product.title} added to cart'));
                        });
                      },
                      child: Text('Add to Bag'),
                    ),
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
