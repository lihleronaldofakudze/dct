import 'package:dreams_come_true/models/Product.dart';
import 'package:dreams_come_true/services/database.dart';
import 'package:dreams_come_true/widget/home_carousel.dart';
import 'package:dreams_come_true/widget/home_categories_list.dart';
import 'package:dreams_come_true/widget/home_style.dart';
import 'package:dreams_come_true/widget/new_arrivals_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          'FanC Boutique',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.0,
        actions: [
          IconButton(
              onPressed: () {
                showAboutDialog(
                    context: context,
                    applicationName: 'Dreams Come True',
                    applicationVersion: '1.0.0',
                    applicationIcon: Container(
                      height: 100,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('images/logo.png'))),
                    ));
              },
              icon: Icon(Icons.info_outline_rounded)),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            Container(
              height: 100,
              child: HomeCategoryList(),
            ),
            HomeCarousel(),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                    height: 1,
                    color: Colors.black,
                  ),
                ),
                Flexible(
                    flex: 1,
                    child: Text(
                      'Modern \nEssentials',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    )),
                Flexible(
                  flex: 1,
                  child: Container(
                    height: 1,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Align(
                alignment: Alignment.center,
                child: Text('Discover Eswatini Styles')),
            SizedBox(
              height: 10,
            ),
            StreamProvider<List<Product>>.value(
              value: DatabaseService().productByStyle,
              initialData: [],
              child: HomeStyle(),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.all(20),
              color: Colors.brown[200],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Free returns, fast refunds',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.arrow_circle_down_rounded)
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'New Arrivals',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/main',
                      arguments: 'New',
                    );
                  },
                  child: Row(
                    children: [
                      Text('View All'),
                      Icon(Icons.arrow_forward_rounded),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 285,
              child: NewArrivalsList(),
            ),
          ],
        ),
      ),
    );
  }
}
