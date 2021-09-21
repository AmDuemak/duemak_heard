import 'package:duemak_heard/screens/Home_screen/home.dart';
import 'package:duemak_heard/screens/forgot_password/forgot_password_screen.dart';
import 'package:duemak_heard/screens/onBoarding_screen/onBoardScreen.dart';
import 'package:duemak_heard/screens/sign_in/sign_in_screen.dart';
import 'package:duemak_heard/screens/sign_up/sign_up_screen.dart';
import 'package:duemak_heard/models/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Duemak Heard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Wrapper(),
      routes: {
        OnboardingScreen.id: (context) => OnboardingScreen(),
        SignInScreen.id: (context) => SignInScreen(),
        SignUpScreen.id: (context) => SignUpScreen(),
        HomePage.id: (context) => HomePage(),
        ForgotPasswordScreen.id: (context) => ForgotPasswordScreen(),
      },
    );
  }
}
