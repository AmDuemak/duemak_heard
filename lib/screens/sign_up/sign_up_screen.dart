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
    return Container(
      child: Body(),
    );
  }
}
