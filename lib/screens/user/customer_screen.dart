import 'package:dreams_come_true/screens/user/person_screen.dart';
import 'package:dreams_come_true/screens/user/search_screen.dart';
import 'package:flutter/material.dart';

import 'cart_screen.dart';
import 'favorite_screen.dart';
import 'home_screen.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({Key? key}) : super(key: key);

  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  int _selectedNav = 0;
  final _bottomNavs = [
    HomeScreen(),
    SearchScreen(),
    CartScreen(),
    FavoriteScreen(),
    PersonScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 5,
        child: Scaffold(
          backgroundColor: Colors.brown[200],
          body: _bottomNavs[_selectedNav],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedNav,
            unselectedItemColor: Colors.black,
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: false,
            onTap: (index) {
              setState(() {
                _selectedNav = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search_outlined), label: 'Search'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart_outlined), label: 'Cart'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_outline_rounded),
                  label: 'Favourite'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline_rounded), label: 'Person'),
            ],
          ),
        ));
  }
}
