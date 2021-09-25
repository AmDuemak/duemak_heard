import 'package:audioplayers/audioplayers.dart';
import 'package:duemak_heard/constants.dart';
import 'package:duemak_heard/screens/Home_screen/home.dart';
import 'package:duemak_heard/utilities/popup_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

String uid = FirebaseAuth.instance.currentUser!.uid.toString();

class OnlineAudio extends StatefulWidget {
  const OnlineAudio({Key? key}) : super(key: key);

  @override
  State<OnlineAudio> createState() => _OnlineAudioState();
}

class _OnlineAudioState extends State<OnlineAudio> {
  List<Reference> references = [];
  bool? isPlaying;
  late AudioPlayer audioPlayer;
  int? selectedIndex;

  Future<void> DownloadLink() async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    ListResult listResult = await firebaseStorage.ref().child(uid).list();
    setState(() {
      references = listResult.items;
    });
  }

  Future<void> _onListTileButtonPressed(int index) async {
    setState(() {
      isPlaying = true;
      selectedIndex = index;
    });
    audioPlayer.play(await references.elementAt(index).getDownloadURL(),
        isLocal: false);

    audioPlayer.onPlayerCompletion.listen((duration) {
      setState(() {
        isPlaying = false;
        selectedIndex = -1;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    isPlaying = false;
    audioPlayer = AudioPlayer();
    selectedIndex = -1;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              icon: Icon(Icons.arrow_back_ios_new_outlined),
            ),
            centerTitle: true,
            title: Text("Online Files"),
            backgroundColor: kPrimaryColor,
            actions: [
              ThePopupMneu(),
            ]),
        body: FutureBuilder(
          future: FirebaseStorage.instance.ref().child(uid).list(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            DownloadLink();
            /* if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("An error occured while trying to connect"),
              );
            }
            */
            return references.isEmpty
                ? Center(
                    child: CircularProgressIndicator(
                      color: kSecondaryColor,
                    ),
                  )
                : ListView.builder(
                    itemCount: references.length,
                    reverse: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: kSecondaryColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: ListTile(
                            title: Text(references.elementAt(index).name),
                            trailing: IconButton(
                              icon: selectedIndex == index
                                  ? Icon(Icons.pause)
                                  : Icon(Icons.play_arrow),
                              onPressed: () => _onListTileButtonPressed(index),
                            ),
                          ),
                        ),
                      );
                    },
                  );
          },
        ),
      ),
    );
  }

  Future<dynamic> myDialogA(
    BuildContext context,
    String messo,
    String title,
    Function() press,
  ) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(messo),
        actions: <Widget>[
          TextButton(
            onPressed: press,
            child: const Text('OK'),
          )
        ],
      ),
    );
  }
}
