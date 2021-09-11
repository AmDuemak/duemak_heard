import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: SpinKitSpinningLines(
          color: Colors.black,
          // duration: Duration(seconds: 10),
        ),
      ),
    );
  }
}
