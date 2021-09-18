/* import 'dart:io';
import 'package:duemak_heard/utilities/firebase_api.dart';
import 'package:duemak_heard/utilities/record.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

File? file;
UploadTask? task;

class UploadRecording {
  UploadRecording(String duemakFile);

  Future uploadFile() async {
    if (file == null) {
      print("no file");
      return;
    }

    final fileName = basename(duemakFile);
    final destination = 'recondings/$fileName';
    print(fileName);

    task = FirebaseApi.uploadFile(destination, file!);

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');
  }
}
 */