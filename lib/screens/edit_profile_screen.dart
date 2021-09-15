import 'package:dreams_come_true/models/RegisteredUser.dart';
import 'package:dreams_come_true/models/constants.dart';
import 'package:dreams_come_true/services/database.dart';
import 'package:dreams_come_true/widget/loading.dart';
import 'package:dreams_come_true/widget/ok_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool _loading = false;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _addressController = TextEditingController();
  String _role = 'user';
  @override
  Widget build(BuildContext context) {
    final registeredUser = Provider.of<RegisteredUser?>(context);
    final image = ModalRoute.of(context)!.settings.arguments;
    print(image);
    return _loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              leading: Container(),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    image == null ? 'New Customer' : 'Customer Details',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'First Name'),
                    controller: _firstNameController,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Last Name'),
                    controller: _lastNameController,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Address'),
                    controller: _addressController,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.black, elevation: 10.0),
                      onPressed: () async {
                        setState(() {
                          _loading = true;
                        });
                        if (_lastNameController.text.isNotEmpty &&
                            _firstNameController.text.isNotEmpty &&
                            _addressController.text.isNotEmpty) {
                          //admin (+26879064064) (+26878230372)
                          if (registeredUser!.number == '+26879064064' ||
                              registeredUser.number == '+26878230372' ||
                              registeredUser.number == '+26879499014') {
                            setState(() {
                              _role = 'admin';
                            });
                          }
                          await DatabaseService(uid: registeredUser.number)
                              .editUserProfile(
                                  image: image != null
                                      ? image.toString()
                                      : Constants().customer,
                                  name:
                                      '${_firstNameController.text} ${_lastNameController.text}',
                                  address: _addressController.text,
                                  role: _role,
                                  cartAmount: 0.0001)
                              .then((value) {
                            setState(() {
                              _loading = false;
                            });
                            Navigator.pushNamed(context, '/auth');
                          });
                        } else {
                          setState(() {
                            _loading = false;
                          });
                          showDialog(
                              context: context,
                              builder: (_) => okAlertDialog(
                                  context: context,
                                  message: 'Please enter all fields.'));
                        }
                      },
                      child: Text('Save'),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
