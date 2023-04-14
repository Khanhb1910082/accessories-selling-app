import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/product.dart';

class ProductService {
  static Stream<List<Product>> readProduct() => FirebaseFirestore.instance
      .collection('accessory')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Product.fromMap(doc.data())).toList());

  static Stream<List<Product>> readProductFavorite() =>
      FirebaseFirestore.instance
          .collection('favoritelist')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection(FirebaseAuth.instance.currentUser!.email.toString())
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => Product.fromMap(doc.data())).toList());
  static Future<List<Product>> getProductList() async {
    final streamProductList = readProduct();
    final List<Product> productList = await streamProductList.first;
    return productList;
  }
}
