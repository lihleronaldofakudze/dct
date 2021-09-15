import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:dreams_come_true/models/Product.dart';
import 'package:dreams_come_true/models/RegisteredUser.dart';
import 'package:dreams_come_true/screens/admin/add_product_screen.dart';
import 'package:dreams_come_true/screens/admin/admin_order_screen.dart';
import 'package:dreams_come_true/screens/admin/admin_screen.dart';
import 'package:dreams_come_true/screens/auth_state.dart';
import 'package:dreams_come_true/screens/edit_profile_screen.dart';
import 'package:dreams_come_true/screens/user/category_screen.dart';
import 'package:dreams_come_true/screens/user/customer_order_screen.dart';
import 'package:dreams_come_true/screens/user/customer_orders_screen.dart';
import 'package:dreams_come_true/screens/user/main_screen.dart';
import 'package:dreams_come_true/screens/user/product_screen.dart';
import 'package:dreams_come_true/screens/user/style_screen.dart';
import 'package:dreams_come_true/services/auth.dart';
import 'package:dreams_come_true/services/database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<RegisteredUser?>.value(
            value: AuthService().user, initialData: RegisteredUser()),
        StreamProvider<List<Product>>.value(
            value: DatabaseService().products, initialData: [])
      ],
      child: MaterialApp(
        routes: {
          '/': (context) => AnimatedSplashScreen(
              splash: SafeArea(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Clout Developers',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('images/logo.png'),
                                fit: BoxFit.contain)),
                      ),
                      Text('Dreams Come True',
                          style: TextStyle(fontSize: 18, color: Colors.grey)),
                    ],
                  ),
                ),
              ),
              splashIconSize: double.infinity,
              nextScreen: AuthState()),

          //General
          '/edit_profile': (context) => EditProfileScreen(),
          '/auth': (context) => AuthState(),
          '/product': (context) => ProductScreen(),

          //Customer
          '/category': (context) => CategoryScreen(),
          '/main': (context) => MainScreen(),
          '/customer_orders': (context) => CustomerOrdersScreen(),
          '/customer_order': (context) => CustomerOrderScreen(),
          '/style': (context) => StyleScreen(),

          //Admin
          '/admin': (context) => AdminScreen(),
          '/add_product': (context) => AddProductScreen(),
          '/admin_order': (context) => AdminOrderScreen(),
        },
        title: 'Dreams Come True',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.brown,
            textTheme:
                GoogleFonts.bellotaTextTextTheme(Theme.of(context).textTheme)),
      ),
    );
  }
}
