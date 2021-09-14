import 'package:dreams_come_true/models/Product.dart';
import 'package:dreams_come_true/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminProductList extends StatelessWidget {
  const AdminProductList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<List<Product>>(context);
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/add_product',
                arguments: products[index].id);
          },
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 400,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(products[index].image),
                            fit: BoxFit.contain)),
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  Text(
                    products[index].style,
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Text(
                      products[index].title,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'E ${products[index].price}0',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 80,
                      ),
                      InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    title: Text('Dreams Come True'),
                                    content: Text(
                                        'Are you want to delete ${products[index].title} product.'),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Cancel')),
                                      TextButton(
                                          onPressed: () async {
                                            await DatabaseService(
                                                    productId:
                                                        products[index].id)
                                                .deleteProduct()
                                                .then((value) {
                                              Navigator.pop(context);
                                            });
                                          },
                                          child: Text('Delete')),
                                    ],
                                  ));
                        },
                        child: Icon(
                          Icons.delete_rounded,
                          color: Colors.red,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
