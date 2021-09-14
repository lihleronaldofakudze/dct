import 'package:dreams_come_true/models/Cart.dart';
import 'package:dreams_come_true/models/RegisteredUser.dart';
import 'package:dreams_come_true/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartList extends StatelessWidget {
  const CartList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<List<Cart>>(context);
    final registeredUser = Provider.of<RegisteredUser?>(context);
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: cart.length,
      itemBuilder: (context, index) {
        return Card(
          child: Row(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(cart[index].image),
                        fit: BoxFit.contain)),
              ),
              SizedBox(
                width: 3,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cart[index].title,
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'E${cart[index].price}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      cart[index].style,
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(50)),
                child: IconButton(
                  padding: EdgeInsets.all(5.0),
                  onPressed: () async {
                    await DatabaseService(
                            productId: cart[index].id,
                            uid: registeredUser!.number)
                        .incrementCart(price: cart[index].price);
                  },
                  icon: Icon(Icons.add),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  '${cart[index].quantity}',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(50)),
                child: IconButton(
                  onPressed: () async {
                    if (cart[index].quantity < 1) {
                      await DatabaseService(
                              productId: cart[index].id,
                              uid: registeredUser!.number)
                          .deleteCart();
                    } else {
                      await DatabaseService(
                              productId: cart[index].id,
                              uid: registeredUser!.number)
                          .decrementCart(price: cart[index].price);
                    }
                  },
                  icon: Icon(Icons.remove),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
