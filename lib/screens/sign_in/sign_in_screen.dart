import 'package:flutter/material.dart';
import 'components/body.dart';

class SignInScreen extends StatefulWidget {
  static const String id = "sign_in";
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Body(),
    );
  }
}
