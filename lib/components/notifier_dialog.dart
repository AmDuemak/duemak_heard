import 'package:flutter/material.dart';

class NotifierDialog extends StatefulWidget {

  @override
  State<NotifierDialog> createState() => _NotifierDialogState();
}

class _NotifierDialogState extends State<NotifierDialog> {

  var errors;
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void notifierDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Error Alart"),
        content: errors,
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
