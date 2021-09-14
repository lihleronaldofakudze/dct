import 'package:dreams_come_true/models/Product.dart';
import 'package:dreams_come_true/models/RegisteredUser.dart';
import 'package:dreams_come_true/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewArrivalsList extends StatelessWidget {
  const NewArrivalsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<List<Product>>(context);
    final registeredUser = Provider.of<RegisteredUser?>(context);
    return ListView.builder(
      itemCount: products.length,
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/product',
                arguments: products[index].id);
          },
          child: Padding(
            padding: EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  width: 180,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(products[index].image),
                          fit: BoxFit.cover)),
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
                      onTap: () async {
                        if (products[index]
                            .likes
                            .contains(registeredUser!.number)) {
                          await DatabaseService(
                                  uid: registeredUser.number,
                                  productId: products[index].id)
                              .unLike();
                        } else {
                          await DatabaseService(
                                  uid: registeredUser.number,
                                  productId: products[index].id)
                              .like();
                        }
                      },
                      child:
                          products[index].likes.contains(registeredUser!.number)
                              ? Icon(
                                  Icons.favorite_rounded,
                                  color: Colors.red,
                                )
                              : Icon(Icons.favorite_border_rounded),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
