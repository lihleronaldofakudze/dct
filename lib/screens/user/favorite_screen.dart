import 'package:dreams_come_true/models/Product.dart';
import 'package:dreams_come_true/models/RegisteredUser.dart';
import 'package:dreams_come_true/services/database.dart';
import 'package:dreams_come_true/widget/main_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final registeredUser = Provider.of<RegisteredUser?>(context);
    return Scaffold(
      backgroundColor: Colors.brown.shade50,
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
          'Favorite',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.0,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.info_outline_rounded)),
          // IconButton(onPressed: () {}, icon: Icon(Icons.info_outline_rounded)),
        ],
      ),
      body: StreamProvider<List<Product>>.value(
        value: DatabaseService(uid: registeredUser!.number).favorites,
        initialData: [],
        child: MainList(),
      ),
    );
  }
}
