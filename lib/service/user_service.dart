import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myproject_app/model/user.dart';

class UserService {
  static Stream<List<Users>> readUser() => FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Users.fromMap(doc.data()))
          .where(
              (user) => user.email == FirebaseAuth.instance.currentUser!.email)
          .toList());

  static updateUser(Users updateUser) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(updateUser.email)
        .update(updateUser.toMap());
  }

  static Future<bool> checkUser() async {
    final collection = FirebaseFirestore.instance.collection('users');
    final snapshot =
        await collection.doc(FirebaseAuth.instance.currentUser!.email).get();
    final phone = snapshot.get("phone");
    final address = snapshot.get("address");
    if (phone == '' || address == '') {
      return false;
    }
    return true;
  }
}
