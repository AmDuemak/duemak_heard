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

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

Future<void> UploadFile(String filePath) async {
  final ref = FirebaseStorage.instance.ref("myFile");

  try {
    await ref
        .child(filePath.substring(filePath.lastIndexOf('/'), filePath.length))
        .putFile(File(filePath));
  } on FirebaseException catch (error) {
    print('Error occured while uplaoding to Firebase ${error.toString()}');
  }
}
