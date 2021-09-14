import 'package:dreams_come_true/services/auth.dart';
import 'package:dreams_come_true/services/database.dart';
import 'package:dreams_come_true/widget/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerificationScreen extends StatefulWidget {
  final number;
  const VerificationScreen({Key? key, this.number}) : super(key: key);

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  String _verificationId = "";
  bool _loading = false;
  final _pinCodeController = TextEditingController();

  signInWithPhoneNumber() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.verifyPhoneNumber(
      phoneNumber: widget.number,
      timeout: Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {},
      verificationFailed: (FirebaseAuthException e) {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: Text('Phone Number Error'),
                  content: Text(e.message.toString()),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/login'),
                        child: Text('Try again.'))
                  ],
                ));
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  void initState() {
    super.initState();
    signInWithPhoneNumber();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              elevation: 0.0,
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter the code to verify your account',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RichText(
                      text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                        TextSpan(
                            text:
                                'We have sent you an sms with a code to : \n'),
                        TextSpan(
                            text: widget.number,
                            style: TextStyle(color: Colors.blue)),
                      ])),
                  SizedBox(
                    height: 70,
                  ),
                  PinCodeTextField(
                      keyboardType: TextInputType.number,
                      pinTheme: PinTheme(shape: PinCodeFieldShape.circle),
                      appContext: context,
                      length: 6,
                      onChanged: (pin) {
                        _pinCodeController.text = pin;
                      }),
                  SizedBox(
                    height: 80,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.black, elevation: 10.0),
                      onPressed: () async {
                        setState(() {
                          _loading = true;
                        });
                        if (_verificationId.isNotEmpty) {
                          AuthCredential authCredential =
                              PhoneAuthProvider.credential(
                                  verificationId: _verificationId,
                                  smsCode: _pinCodeController.text);
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .signInWithCredential(authCredential);

                          User? user = userCredential.user;

                          if (user != null) {
                            AuthService().userFromFirebase(user);

                            bool isHere =
                                await DatabaseService(uid: user.phoneNumber)
                                    .checkForUser();

                            if (isHere) {
                              Navigator.pushNamed(context, '/auth');
                            } else {
                              Navigator.pushNamed(context, '/edit_profile');
                            }
                          } else {
                            setState(() {
                              _loading = false;
                            });
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      title: Text('Error'),
                                      content: Text('Something went wrong.'),
                                      actions: [
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pushNamed(
                                                    context, '/'),
                                            child: Text('Try again.'))
                                      ],
                                    ));
                          }
                        } else {
                          setState(() {
                            _loading = false;
                          });
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    title: Text('Verification Id'),
                                    content: Text(
                                        'Wait until you receive an sms with the code.'),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pushNamed(context, '/'),
                                          child: Text('Try again.'))
                                    ],
                                  ));
                        }
                      },
                      child: Text('Verify Number'),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Send me a new code',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
