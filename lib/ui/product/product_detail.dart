import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:myproject_app/model/product.dart';
import 'package:myproject_app/service/product_service.dart';
import 'package:myproject_app/ui/cart/cart_view.dart';
import 'package:myproject_app/ui/product/product_detail_bottom.dart';
import 'package:myproject_app/ui/product/product_filter.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail(this.product, {super.key});
  final Product product;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  bool _favorite = false;
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(1, 0, 0, 0),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const CartView()));
              },
              child: const Icon(
                Icons.shopping_cart_outlined,
                size: 28,
              ),
            ),
          ),
          const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.chat_outlined)),
        ],
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          Image(
            image: NetworkImage(widget.product.productUrl[_selectedIndex]),
            fit: BoxFit.fitWidth,
          ),
          const SizedBox(height: 10),
          Center(
            child: SizedBox(
              height: 100,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ListView.builder(
                        itemCount: widget.product.productUrl.length,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _selectedIndex = index;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: _selectedIndex == index
                                      ? Colors.pink
                                      : Colors.black12,
                                  width: 3,
                                ),
                              ),
                              child: Image(
                                image: NetworkImage(
                                    widget.product.productUrl[index]),
                                height: 100,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: width * 8 / 10,
                        child: Text(
                          widget.product.productName,
                          style: const TextStyle(
                              fontSize: 16, overflow: TextOverflow.clip),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            var f = ProductService.readProductFavorite();
                            if (!_favorite) {
                              FirebaseFirestore.instance
                                  .collection("favoritelist")
                                  .doc(FirebaseAuth.instance.currentUser!.email)
                                  .collection(FirebaseAuth
                                      .instance.currentUser!.email
                                      .toString())
                                  .doc(widget.product.id)
                                  .set(widget.product.toMap(),
                                      SetOptions(merge: true));
                            } else {
                              FirebaseFirestore.instance
                                  .collection("favoritelist")
                                  .doc(FirebaseAuth.instance.currentUser!.email)
                                  .collection(FirebaseAuth
                                      .instance.currentUser!.email
                                      .toString())
                                  .doc(widget.product.id)
                                  .delete();
                            }
                            _favorite = !_favorite;
                          });
                        },
                        child: Icon(
                          !_favorite
                              ? Icons.favorite_border
                              : Icons.favorite_sharp,
                          color: Colors.deepOrange,
                          size: 30,
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${MoneyFormatter(amount: widget.product.price.toDouble()).output.withoutFractionDigits}đ',
                      style: const TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      const Text("Loại: "),
                      Text(widget.product.color[0]),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: const BoxDecoration(),
                  child: const Text(
                    'Mô tả:',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                Text(
                  widget.product.describe.toString(),
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Sản phẩm liên quan',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                        fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
          ProductFilter(widget.product.type),
        ],
      ),
      bottomNavigationBar: ProductDetailBottom(widget.product),
    );
  }
}
