import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> userSetup(
  String firstName,
  String lastName,
  String userName,
  String phoneNumber,
) async {
   CollectionReference users = FirebaseFirestore.instance.collection('Users');
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = auth.currentUser!.uid.toString();
  users.add(
    {
      'uid': uid,
      'First Name': firstName,
      'Last Name': lastName,
      'Phone Number': phoneNumber,
      'Username': userName,
    },
  );
  return;
}
