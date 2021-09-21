import 'dart:io';

import 'package:duemak_heard/models/my_dialog.dart';
import 'package:flutter/material.dart';

Future<void> deleteFile(
  File file,
  BuildContext context,
) async {
  myDialog(
    context,
    "Are you sure you want to delete this file?",
    "Confirm",
    () {
      Navigator.pop(context, 'OK');
    },
    () async {
      try {
        if (await file.exists()) {
          await file.delete();
          print("deleted successifully");
          
        }
        Navigator.pop(context, 'OK');
      } catch (e) {
        print(e.toString());
      }
    },
  );
}
