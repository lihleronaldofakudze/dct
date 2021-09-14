import 'package:dreams_come_true/screens/verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NumberScreen extends StatefulWidget {
  const NumberScreen({Key? key}) : super(key: key);

  @override
  _NumberScreenState createState() => _NumberScreenState();
}

class _NumberScreenState extends State<NumberScreen> {
  final _numberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Phone Number Login',
          style: GoogleFonts.bellotaText(),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Eswatini Phone Number Only',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 50,
            ),
            TextField(
              maxLength: 7,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: 'Phone Number', prefixText: '+2687'),
              controller: _numberController,
            ),
            SizedBox(
              height: 70,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.black, elevation: 10.0),
                onPressed: () {
                  if (_numberController.text.isNotEmpty) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => VerificationScreen(
                                  number: '+2687${_numberController.text}',
                                )));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                      content: Text('Please valid phone number.'),
                    ));
                  }
                },
                child: Text('Login'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
