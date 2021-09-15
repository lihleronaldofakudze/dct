import 'package:dreams_come_true/models/Product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeStyle extends StatelessWidget {
  const HomeStyle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Product> products = Provider.of<List<Product>>(context);
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: MediaQuery.of(context).size.width / 540),
      itemCount: products.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/style',
                arguments: products[index].style);
          },
          child: Container(
            child: Column(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(products[index].image),
                          fit: BoxFit.cover)),
                ),
                SizedBox(
                  height: 3,
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    products[index].style,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: 7,
                ),
                Text(
                  products[index].category,
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
