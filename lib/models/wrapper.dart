import 'package:duemak_heard/screens/Home_screen/home.dart';
import 'package:duemak_heard/screens/onBoarding_screen/onBoardScreen.dart';
import 'package:duemak_heard/screens/sign_in/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Wrapper extends StatefulWidget {
  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  List cachePath = [];

  Future<void> CacheDir() async {
    final cacheDir = await getTemporaryDirectory();
    setState(() {
      cachePath = cacheDir.list() as List;
    });
    print(cacheDir.list());
  }

  @override
  void initState() {
    CacheDir();
    super.initState();
  }

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
            return cachePath.isEmpty ? OnboardingScreen() : SignInScreen();
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
