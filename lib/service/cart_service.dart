import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myproject_app/model/cart.dart';

class CartService {
  static Stream<List<CartItem>> readCartItem() => FirebaseFirestore.instance
      .collection('cart')
      .doc(FirebaseAuth.instance.currentUser!.email)
      .collection(FirebaseAuth.instance.currentUser!.email.toString())
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => CartItem.fromMap(doc.data())).toList());

  void updateCart(String id, int quantity) async {
    CollectionReference cart = FirebaseFirestore.instance.collection('cart');
    cart
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection(FirebaseAuth.instance.currentUser!.email.toString())
        .where("id", isEqualTo: id)
        .get();

    await cart.doc().update({"quantity": quantity});
  }
}
