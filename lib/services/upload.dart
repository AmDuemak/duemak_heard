import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

String uid = FirebaseAuth.instance.currentUser!.uid;

Future<void> UploadFile(String filePath) async {
  final ref = FirebaseStorage.instance.ref(uid);

  try {
    await ref
        .child(filePath.substring(filePath.lastIndexOf('/'), filePath.length))
        .putFile(File(filePath));
  } on FirebaseException catch (error) {
    print('Error occured while uplaoding to Firebase ${error.toString()}');
  }
}
