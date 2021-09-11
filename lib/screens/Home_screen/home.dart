import 'package:duemak_heard/constants.dart';
import 'package:duemak_heard/screens/sign_in/sign_in_screen.dart';
import 'package:duemak_heard/utilities/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const String id = "home";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: loading
          ? Loading()
          : Scaffold(
              appBar: AppBar(
                backgroundColor: kPrimaryColor,
              ),
              drawer: Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                      ),
                      child: Text(
                        'Drawer Header',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.message),
                      title: Text('Messages'),
                    ),
                    ListTile(
                      leading: Icon(Icons.account_circle),
                      title: Text('Profile'),
                    ),
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Settings'),
                    ),
                    GestureDetector(
                      child: ListTile(
                        leading: Icon(Icons.logout),
                        title: Text('Logout'),
                      ),
                      onTap: () async {
                        try {
                          setState(() {
                            loading = true;
                          });
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushReplacementNamed(
                              context, SignInScreen.id);
                        } catch (e) {
                          print("error occured");
                          setState(() {
                            loading = false;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
