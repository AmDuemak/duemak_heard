import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duemak_heard/models/my_dialog.dart';
import 'package:duemak_heard/screens/online_files/online_stream.dart';
import 'package:duemak_heard/screens/sign_in/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';

class MyDrawer extends StatefulWidget {
  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String TheUid = FirebaseAuth.instance.currentUser!.uid.toString();
  static String fname = "";
  static String lname = "";
  static String phone = "";
  static String username = "";
  static String fullNames = "";

  @override
  build(BuildContext context) {
    return Drawer(
      child: StreamBuilder<Object>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .where("uid", isEqualTo: TheUid)
            .snapshots(),
        builder: (context, snapshot) {
          FirebaseFirestore.instance
              .collection("Users")
              .where("uid", isEqualTo: TheUid)
              .snapshots()
              .listen((data) {
            // fname = data.docs[0]["First Name"];
            lname = data.docs[0]["Last Name"];
            phone = data.docs[0]["Phone Number"];
            username = data.docs[0]["Username"];
            fname = data.docs[0]["First Name"];
            fullNames = " $fname   $lname";
          });
          return Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/onbrd/img.png'),
                            radius: 50,
                          ),
                          SizedBox(width: 5),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  fullNames,
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  username,
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                )
                              ])
                        ],
                      ),

                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Container(
                          padding: EdgeInsets.only(right: 10, left: 10),
                          color: Colors.grey,
                          height: 1,
                        ),
                      ),
                      SizedBox(height: 15),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: Theme.of(context).splashColor,
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OnlineAudio(),
                                ),
                              );
                            },
                            title: Text(
                              'Synced Data',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            trailing: Icon(Icons.chevron_right_rounded),
                            leading: Icon(
                              FontAwesomeIcons.lockOpen,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),

                      _listTileContent(
                          'Name', fname, Icons.email_outlined, context),
                      _listTileContent('UserName', username,
                          Icons.near_me_outlined, context),
                      _listTileContent('Phone ', phone,
                          Icons.phone_android_outlined, context),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Container(
                          padding: EdgeInsets.only(right: 10, left: 10),
                          color: Colors.grey,
                          height: 1,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      _listTileContent('Notifications', "",
                          Icons.notifications_outlined, context),
                      _listTileContent(
                          'Privacy', '', Icons.privacy_tip_outlined, context),
                      _listTileContent(
                          'Language', 'English', Icons.language, context),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Container(
                          padding: EdgeInsets.only(right: 10, left: 10),
                          color: Colors.grey,
                          height: 1,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      // _listTileContent('Logout', "", Icons.logout_outlined, context),

                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: Theme.of(context).splashColor,
                          onTap: () {
                            myDialog(
                              context,
                              "Backup all your Data first. \nAll your recordings will be lost should you proceed",
                              "Warning",
                              () => Navigator.pop(context, 'OK'),
                              () async {
                                try {
                                  await FirebaseAuth.instance.signOut();
                                  await _deleteAppDir();
                                } on FirebaseAuthException catch (e) {
                                  print(e.toString());
                                } catch (e) {
                                  print(e.toString());
                                }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignInScreen()),
                                );
                              },
                            );
                          },
                          child: ListTile(
                            leading: Icon(
                              Icons.logout,
                              color: Colors.black,
                            ),
                            title: Text(
                              'Logout',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _listTileContent(
      String text, String details, IconData icon, BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        splashColor: Theme.of(context).splashColor,
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.black,
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
              Flexible(
                child: Text(
                  details,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w200,
                      color: Colors.black),
                ),
              ),
            ],
          ),
          trailing: Icon(Icons.chevron_right),
        ),
      ),
    );
  }

  /// this will delete cache
  Future<void> _deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  /// this will delete app's storage
  Future<void> _deleteAppDir() async {
    final appDir = await getApplicationDocumentsDirectory();

    if (appDir.existsSync()) {
      try {
        appDir.deleteSync(recursive: true);
      } catch (e) {
        print(e.toString());
      }
    }
  }
}
