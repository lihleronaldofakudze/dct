import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                autofocus: true,
                decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: Icon(Icons.search_outlined),
                    suffix: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.send,
                          color: Colors.black,
                        ))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
