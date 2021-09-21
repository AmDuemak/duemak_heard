/* import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

getUser(
  
) async {
  String TheUid = await FirebaseAuth.instance.currentUser!.uid.toString();
  try {
    await FirebaseFirestore.instance
        .collection("Users")
        .where("uid", isEqualTo: TheUid)
        .snapshots()
        .listen((data) {
      String fname = data.docs[0]["First Name"];
      String lname = data.docs[0]["Last Name"];
      String phone = data.docs[0]["Phone Numbe"];
      String username = data.docs[0]["Username"];
      String fullNames = " $fname" "$lname";
    });
  } catch (e) {
    print("there was an error");
    print(e);
  }
}
 */