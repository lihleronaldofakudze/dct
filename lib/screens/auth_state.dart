import 'package:dreams_come_true/models/RegisteredUser.dart';
import 'package:dreams_come_true/screens/user/customer_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'number_screen.dart';

class AuthState extends StatelessWidget {
  const AuthState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final registeredUser = Provider.of<RegisteredUser?>(context);

    if (registeredUser == null) {
      return NumberScreen();
    } else {
      return CustomerScreen();
    }
  }
}
