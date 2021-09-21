import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duemak_heard/constants.dart';
import 'package:duemak_heard/screens/Drawer/my_drawer.dart';
import 'package:duemak_heard/services/detele_file.dart';
import 'package:duemak_heard/utilities/loading.dart';
import 'package:duemak_heard/services/record.dart';
import 'package:duemak_heard/services/upload.dart';
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
  bool isUploading = false;
  final List<String> errors = [];
  final recorder = SoundRecorder();
  late List records;
  late Directory appDirectory;
  int _selectedIndex = -1;
  late int _totalDuration;
  late int _currentDuration;
  double _completedPercentage = 0.0;
  bool _isPlaying = false;
  String fullNames = "";
  String lname = "";
  String username = "";
  String phone = "";
  String fname = "";

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
    DataStream();
    UpdateList();
  }

  @override
  void dispose() {
    recorder.dispose();
    super.dispose();
  }

  Future<void> UpdateList() async {
    Directory Dir = appDirectory;
    Dir.list().listen((onData) {
      if (onData.path.contains('.aac')) {
        String j = onData.path;
        if (!records.contains(j)) {
          records.add(onData.path);
        }
      }
    }).onDone(() {
      setState(() {});
    });
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
                actions: [
                  IconButton(
                    onPressed: () {
                      records.clear();
                      UpdateList();
                      print("pressed");
                      setState(() {});
                    },
                    icon: Icon(Icons.sync),
                  )
                ],
              ),
              drawer: MyDrawer(),
              body: isUploading
                  ? Loading()
                  : FutureBuilder<void>(
                      future: DataStream(),
                      builder: (context, snapshot) {
                        UpdateList();
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
                                  leading: IconButton(
                                    onPressed: () async {
                                      try {
                                        await deleteFile(
                                          File(records.elementAt(i)),
                                          context,
                                        );
                                      } catch (e) {
                                        print(e.toString());
                                        print(records.elementAt(i));
                                      }
                                      setState(() {
                                        ;
                                      });
                                    },
                                    icon: Icon(Icons.delete_forever),
                                  ),
                                  title: Text(
                                      "New recoding ${records.length - i}"),
                                  subtitle: Text(getDateFromFile(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          LinearProgressIndicator(
                                            minHeight: 2,
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
                                                        _completedPercentage =
                                                            0.0;
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
                backgroundColor: kPrimaryColor,
                currentIndex: 1,
                items: [
                  BottomNavigationBarItem(
                    label: "Upload to cloud",
                    icon: IconButton(
                        onPressed: () async {
                          setState(() {
                            isUploading = true;
                          });
                          for (int f = 0; f < records.length; f++) {
                            try {
                              await UploadFile(records.elementAt(f).toString());
                            } on FirebaseException catch (e) {
                              print(e.toString());
                              setState(() {
                                isUploading = false;
                              });
                            }
                          }
                          setState(() {
                            isUploading = false;
                          });
                        },
                        icon: Icon(Icons.cloud_upload)),
                  ),
                  BottomNavigationBarItem(
                    label: "HOME",
                    icon: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.home_outlined),
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: isRecording ? "Close MIC" : "Open MIC",
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

  Future<void> DataStream() async {
    appDirectory = await getApplicationDocumentsDirectory();
    appDirectory.list();
  }

//

//
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

      audioPlayer.onAudioPositionChanged.listen(
        (duration) {
          setState(() {
            _totalDuration = audioPlayer.getDuration() as int;
            _currentDuration = duration.inMicroseconds;
            _completedPercentage =
                _currentDuration.toDouble() / _totalDuration.toDouble();
          });
        },
      );
    }
  }

  String getDateFromFile({required String filePath}) {
    String fromFile = filePath.substring(
        filePath.lastIndexOf('/') + 1, filePath.lastIndexOf('.'));

    DateTime recordedDate =
        DateTime.fromMillisecondsSinceEpoch(int.parse(fromFile));
    int year = recordedDate.year;
    int month = recordedDate.month;
    int day = recordedDate.day;
    int hour = recordedDate.hour;
    int min = recordedDate.minute;

    return ('$year-$month-$day    $hour:$min');
  }
}
