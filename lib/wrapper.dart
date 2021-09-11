import 'package:duemak_heard/screens/Home_screen/home.dart';
import 'package:duemak_heard/screens/onBoarding_screen/onBoardScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (userSnapshot.connectionState == ConnectionState.active) {
          if (userSnapshot.hasData) {
            return HomePage();
          } else {
            return OnboardingScreen();
          }
        } else if (userSnapshot.hasError) {
          return Center(
            child: Text("An error occured while trying to connect"),
          );
        }
        return Center(
          child: Text(
            userSnapshot.data.toString(),
          ),
        );
      },
    );
  }
}
