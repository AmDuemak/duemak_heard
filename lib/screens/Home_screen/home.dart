import 'package:duemak_heard/constants.dart';
import 'package:duemak_heard/screens/sign_in/sign_in_screen.dart';
import 'package:duemak_heard/utilities/loading.dart';
import 'package:duemak_heard/utilities/record.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const String id = "home";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loading = false;
  final List<String> errors = [];
  final recorder = SoundRecorder();
  // bool isRecording = recorder.isRecording;

  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error!);
      });
  }

  void removeError({String? error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  void initState() {
    super.initState();

    recorder.init();
  }

  @override
  void dispose() {
    recorder.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isRecording = recorder.isRecording;
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
                        } on FirebaseException catch (e) {
                          String messo = "network-request-failed";
                          if (e.code == "network-request-failed") {
                            myDialog(context, messo);
                          } else {
                            messo = "an error occured";
                            myDialog(context, messo);
                          }
                          print(e.toString());
                          setState(() {
                            loading = false;
                          });
                          
                        }
                        Navigator.pushReplacementNamed(
                              context, SignInScreen.id);
                      },
                    ),
                  ],
                ),
              ),
              body: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    child: Column(),
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  await recorder.toggleRecorder();
                  setState(() {});
                },
                child: isRecording
                    ? Icon(Icons.mic_rounded)
                    : Icon(Icons.mic_off_rounded),
              ),
            ),
    );
  }

  Future<dynamic> myDialog(BuildContext context, String messo) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Signing In error"),
        content: Text(messo),
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
