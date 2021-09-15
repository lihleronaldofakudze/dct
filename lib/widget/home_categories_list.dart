import 'package:dreams_come_true/models/Category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeCategoryList extends StatelessWidget {
  const HomeCategoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = [
      Category(category: 'All', image: 'images/1 (1).jpg'),
      Category(category: 'Sale', image: 'images/1 (2).jpg'),
      Category(category: 'Apparel', image: 'images/1 (3).jpg'),
      Category(category: 'Footwear', image: 'images/1 (4).jpg'),
      Category(category: 'Sportswear', image: 'images/1 (5).jpg'),
      Category(category: 'Traditional', image: 'images/1 (6).jpg'),
      Category(category: 'Formal Wear', image: 'images/1 (7).jpg'),
      Category(category: 'Accessories', image: 'images/1 (8).jpg'),
      Category(category: 'Jewelery', image: 'images/1 (9).jpg'),
      Category(category: 'Luggage', image: 'images/1 (10).jpg'),
      Category(category: 'Cosmetics', image: 'images/1 (11).jpg'),
      Category(category: 'Costumes', image: 'images/1 (12).jpg'),
      Category(category: 'Textiles', image: 'images/1 (13).jpg'),
      Category(category: 'Vintage', image: 'images/1 (14).jpg'),
    ];
    return ListView.builder(
      shrinkWrap: true,
      itemCount: categories.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            if (categories[index].category == 'All') {
              Navigator.pushNamed(
                context,
                '/main',
                arguments: categories[index].category,
              );
            } else {
              Navigator.pushNamed(context, '/category',
                  arguments: categories[index].category);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(categories[index].image),
                ),
                Text(categories[index].category)
              ],
            ),
          ),
        );
      },
    );
  }
}
