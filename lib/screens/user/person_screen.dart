import 'dart:io';

import 'package:dreams_come_true/models/Customer.dart';
import 'package:dreams_come_true/models/RegisteredUser.dart';
import 'package:dreams_come_true/services/auth.dart';
import 'package:dreams_come_true/services/database.dart';
import 'package:dreams_come_true/widget/loading.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class PersonScreen extends StatefulWidget {
  const PersonScreen({Key? key}) : super(key: key);

  @override
  _PersonScreenState createState() => _PersonScreenState();
}

class _PersonScreenState extends State<PersonScreen> {
  PickedFile _pickedImage = PickedFile('');

  updateProfileImage(
      {required String? uid,
      required String name,
      required String address,
      required String role,
      required cartAmount}) async {
    await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 10)
        .then((value) {
      setState(() {
        _pickedImage = value!;
      });
      Reference reference =
          FirebaseStorage.instance.ref().child('dct').child('$uid.png');
      UploadTask uploadTask = reference.putFile(File(_pickedImage.path));
      uploadTask.whenComplete(() async {
        try {
          await reference.getDownloadURL().then((url) async {
            await DatabaseService(uid: uid)
                .editUserProfile(
                    image: url,
                    name: name,
                    address: address,
                    role: role,
                    cartAmount: cartAmount)
                .then((value) {})
                .catchError((onError) {});
          });
        } catch (error) {
          print(error);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final registeredUser = Provider.of<RegisteredUser?>(context);
    return StreamBuilder<Customer>(
        stream: DatabaseService(uid: registeredUser!.number).customer,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Customer? customer = snapshot.data;
            return Scaffold(
              backgroundColor: Colors.brown.shade50,
              appBar: AppBar(
                leading: customer!.role == 'admin'
                    ? IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/admin');
                        },
                        icon: Icon(Icons.admin_panel_settings_outlined))
                    : IconButton(
                        onPressed: () async {
                          await Share.share(
                              'Dream Come True Online Shopping App : http://play.google.com/store/apps/details?id=io.cloutdevelopers.dreams_come_true');
                        },
                        icon: Icon(Icons.shop_rounded)),
                iconTheme: IconThemeData(color: Colors.black),
                backgroundColor: Colors.brown.shade50,
                title: Text(
                  'Profile',
                  style: TextStyle(color: Colors.black),
                ),
                centerTitle: true,
                elevation: 0.0,
                actions: [
                  IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/edit_profile',
                            arguments: customer.image);
                      },
                      icon: Icon(Icons.settings_outlined)),
                  IconButton(
                      onPressed: () {}, icon: Icon(Icons.info_outline_rounded)),
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                  title: Text('Dreams Come True'),
                                  content:
                                      Text('Are you sure you want to exit?'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancel')),
                                    TextButton(
                                        onPressed: () async {
                                          await AuthService()
                                              .signOut()
                                              .then((value) {
                                            Navigator.pushNamed(
                                                context, '/auth');
                                          });
                                        },
                                        child: Text('Log Out'))
                                  ],
                                ));
                      },
                      icon: Icon(Icons.logout_outlined)),
                ],
              ),
              body: Container(
                width: double.infinity,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.brown,
                          backgroundImage: NetworkImage(customer.image),
                        ),
                        Positioned(
                          top: 95,
                          left: 95,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(50)),
                            child: IconButton(
                                onPressed: () => updateProfileImage(
                                    uid: registeredUser.number,
                                    name: customer.name,
                                    address: customer.address,
                                    role: customer.role,
                                    cartAmount: customer.cartAmount),
                                icon: Icon(
                                  Icons.camera_outlined,
                                  color: Colors.white,
                                )),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      customer.name,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '${registeredUser.number}',
                      style: TextStyle(color: Colors.grey),
                    ),
                    InkWell(
                      onTap: () {},
                      child: ListTile(
                        title: Text(
                          'My Address',
                          style: TextStyle(fontSize: 18),
                        ),
                        trailing: Text(customer.address,
                            style: TextStyle(
                                fontSize: 16, color: Colors.brown.shade300)),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/customer_orders');
                      },
                      child: ListTile(
                        title: Text(
                          'My Orders',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    // InkWell(
                    //   onTap: () {},
                    //   child: ListTile(
                    //     title: Text(
                    //       'My Returns',
                    //       style: TextStyle(fontSize: 18),
                    //     ),
                    //     trailing: Text('1 Returns',
                    //         style: TextStyle(
                    //             fontSize: 16, color: Colors.brown.shade300)),
                    //   ),
                    // ),
                    // InkWell(
                    //   onTap: () {},
                    //   child: ListTile(
                    //     title: Text(
                    //       'Payments',
                    //       style: TextStyle(fontSize: 18),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
