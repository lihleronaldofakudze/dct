import 'package:flutter/material.dart';

AlertDialog okAlertDialog(
    {required BuildContext context, required String message}) {
  return AlertDialog(
    title: Text('Dreams Come True'),
    content: Text(message),
    actions: [
      TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Ok'))
    ],
  );
}
