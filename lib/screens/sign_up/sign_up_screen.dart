import 'package:duemak_heard/constants.dart';
import 'package:flutter/material.dart';
import 'components/body.dart';

class SignUpScreen extends StatefulWidget {
  static const String id = "sign_up";

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text("Sign Up"),
      ),
      body: Body(),
    );
  }
}
