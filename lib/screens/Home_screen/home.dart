import 'dart:io';

import 'package:duemak_heard/constants.dart';
import 'package:duemak_heard/screens/sign_in/sign_in_screen.dart';
import 'package:duemak_heard/utilities/loading.dart';
import 'package:duemak_heard/utilities/record.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class HomePage extends StatefulWidget {
  static const String id = "home";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loading = false;
  final List<String> errors = [];
  final recorder = SoundRecorder();
  late List<String> records;
  late Directory appDirectory;
  int _selectedIndex = -1;
  late int _totalDuration;
  late int _currentDuration;
  double _completedPercentage = 0.0;
  bool _isPlaying = false;
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
    records = [];
    recorder.init();
    getApplicationDocumentsDirectory().then((value) {
      appDirectory = value;
      appDirectory.list().listen((onData) {
        if (onData.path.contains('.aac')) {
          records.add(onData.path);
        }
      }).onDone(() {
        records = records.reversed.toList();
        setState(() {});
        print(records);
      });
    });
  }

  @override
  void dispose() {
    recorder.dispose();
    appDirectory.delete();
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
              body: FutureBuilder(
                  future: null,
                  builder: (BuildContext context, snapshot) {
                    return ListView.builder(
                      itemCount: records.length,
                      shrinkWrap: true,
                      reverse: true,
                      itemBuilder: (BuildContext context, int i) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: kSecondaryColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: ExpansionTile(
                              title: Text("New recoding ${records.length - i}"),
                              subtitle: Text(getDateFromFilePatah(
                                  filePath: records.elementAt(i))),
                              onExpansionChanged: ((newState) {
                                if (newState) {
                                  setState(() {
                                    _selectedIndex = i;
                                  });
                                }
                              }),
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  height: 100,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      LinearProgressIndicator(
                                        minHeight: 5,
                                        backgroundColor: Colors.black,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                kPrimaryColor),
                                        value: _selectedIndex == i
                                            ? _completedPercentage
                                            : 0,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            child: IconButton(
                                                iconSize: 30,
                                                icon: Icon(Icons.stop),
                                                onPressed: () {
                                                  AudioPlayer().stop();
                                                  setState(() {
                                                    _isPlaying = false;
                                                  });
                                                }),
                                          ),
                                          SizedBox(
                                            child: IconButton(
                                              iconSize: 30,
                                              icon: Icon(Icons.play_arrow),
                                              onPressed: () => _onPlay(
                                                  filePath:
                                                      records.elementAt(i),
                                                  index: i),
                                            ),
                                          ),
                                          SizedBox(
                                            child: IconButton(
                                                iconSize: 30,
                                                icon: Icon(Icons.pause),
                                                onPressed: () {
                                                  AudioPlayer().pause();
                                                  setState(() {
                                                    _isPlaying = false;
                                                  });
                                                }),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: 1,
                items: [
                  BottomNavigationBarItem(
                    label: "Upload to cloud",
                    icon: IconButton(
                      onPressed: () async {
                        await () {};
                        print("Upload pressed");
                      },
                      icon: Icon(Icons.cloud_upload),
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: "HOME",
                    icon: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.home_outlined),
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: "Start OR Stop",
                    icon: IconButton(
                      onPressed: () async {
                        await recorder.toggleRecorder();
                        setState(() {});
                      },
                      icon: isRecording
                          ? Icon(Icons.mic_rounded)
                          : Icon(Icons.mic_off_rounded),
                    ),
                  )
                ],
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

  Future<void> _onPlay({required String filePath, required int index}) async {
    AudioPlayer audioPlayer = AudioPlayer();

    if (!_isPlaying) {
      audioPlayer.play(filePath, isLocal: true);
      setState(() {
        _selectedIndex = index;
        _completedPercentage = 0.0;
        _isPlaying = true;
      });

      audioPlayer.onPlayerStateChanged.listen((event) {
        setState(() {
          _isPlaying = false;
          _completedPercentage = 0.0;
        });
      });

      audioPlayer.onAudioPositionChanged.listen((duration) {
        setState(() {
          _totalDuration = duration.inMicroseconds;
        });
      });

      audioPlayer.onAudioPositionChanged.listen((duration) {
        setState(() {
          _currentDuration = duration.inMicroseconds;
          _completedPercentage =
              _currentDuration.toDouble() / _totalDuration.toDouble();
        });
      });
    }
  }

  String getDateFromFilePatah({required String filePath}) {
    String fromEpoch = filePath.substring(
        filePath.lastIndexOf('/') + 1, filePath.lastIndexOf('.'));

    DateTime recordedDate =
        DateTime.fromMillisecondsSinceEpoch(int.parse(fromEpoch));
    int year = recordedDate.year;
    int month = recordedDate.month;
    int day = recordedDate.day;
    int hour = recordedDate.hour;
    int min = recordedDate.minute;

    return ('$year-$month-$day    $hour:$min');
  }
}
