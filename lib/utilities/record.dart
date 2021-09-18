import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound/flutter_sound.dart';

late final Directory appDirectory;
String appPath = appDirectory.path;
final duemakFile =
    appPath + "/" + DateTime.now().millisecondsSinceEpoch.toString() + ".aac";

class SoundRecorder {
  FlutterSoundRecorder? _audioRecorder;
  bool _recorderIsInitialized = false;
  bool get isRecording => _audioRecorder!.isRecording;

  Future init() async {
    getApplicationDocumentsDirectory().then((value) => appDirectory = value);
    _audioRecorder = FlutterSoundRecorder();

    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException("Microphone permission is Required");
    }
    await _audioRecorder!.openAudioSession();

    _recorderIsInitialized = true;
  }

  Future dispose() async {
    if (!_recorderIsInitialized) return;
    _audioRecorder!.closeAudioSession();
    _audioRecorder = null;
    _recorderIsInitialized = false;
  }

  Future _record() async {
    if (!_recorderIsInitialized) return;
    await _audioRecorder!.startRecorder(toFile: duemakFile);
  }

  Future _stopRecord() async {
    if (!_recorderIsInitialized) return;
    await _audioRecorder!.stopRecorder();
  }

  Future toggleRecorder() async {
    if (_audioRecorder!.isStopped) {
      await _record();
    } else {
      await _stopRecord();
    }
  }
}
