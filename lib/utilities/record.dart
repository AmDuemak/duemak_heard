import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

final duemakFile = "example.aac";

class SoundRecorder {
  FlutterSoundRecorder? _audioRecorder;
  bool _recorderIsInitialized = false;
  bool get isRecording => _audioRecorder!.isRecording;

  Future init() async {
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
