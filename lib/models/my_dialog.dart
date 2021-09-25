import 'package:flutter/material.dart';

Future<dynamic> myDialog(BuildContext context, String messo, String title,
    Function() press, Function() press1) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(title),
      content: Text(messo),
      actions: <Widget>[
        TextButton(
          onPressed: press,
          /*  () => Navigator.pop(context, 'OK'), */
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: press1,
          child: const Text('OK'),
        )
      ],
    ),
  );
}
