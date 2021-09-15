import 'package:carousel_slider/carousel_slider.dart';
import 'package:dreams_come_true/models/Product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeCarousel extends StatelessWidget {
  const HomeCarousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<List<Product>>(context);
    return CarouselSlider(
      options: CarouselOptions(
        height: 400.0,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
      ),
      items: products.map((product) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(product.image), fit: BoxFit.cover)),
            );
          },
        );
      }).toList(),
    );
  }
}
