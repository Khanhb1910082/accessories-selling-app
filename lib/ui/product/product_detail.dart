import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:myproject_app/model/product.dart';
import 'package:myproject_app/ui/cart/cart_view.dart';
import 'package:myproject_app/ui/product/product_detail_bottom.dart';
import 'package:myproject_app/ui/product/product_filter.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';

import '../cart/cart_manager.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail(this.product, {super.key});
  final Product product;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int _selectedIndex = 0;
  final user = FirebaseAuth.instance.currentUser!.email;
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartManager>(context);
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(1, 0, 0, 0),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CartView()));
            },
            child: badges.Badge(
              position: badges.BadgePosition.topEnd(top: -12, end: -12),
              showBadge: true,
              ignorePointer: false,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const CartView()));
              },
              badgeContent: Text(
                '${cartProvider.cartCount}',
                style: const TextStyle(
                    fontWeight: FontWeight.w500, fontSize: 14.5),
              ),
              badgeAnimation: const BadgeAnimation.scale(
                animationDuration: Duration(seconds: 1),
                colorChangeAnimationDuration: Duration(seconds: 1),
                loopAnimation: false,
                curve: Curves.fastOutSlowIn,
                colorChangeAnimationCurve: Curves.easeInCubic,
              ),
              badgeStyle: badges.BadgeStyle(
                badgeColor: Colors.white38,
                borderRadius: BorderRadius.circular(4),
                elevation: 0,
              ),
              child: const Icon(
                Icons.shopping_cart_outlined,
                size: 28,
                color: Colors.pinkAccent,
              ),
            ),
          ),
          const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(
                Icons.chat_outlined,
                color: Colors.pinkAccent,
              )),
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
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('favoritelist')
                  .doc(user)
                  .collection(user.toString())
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Lỗi không tồn tại."),
                  );
                } else if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  bool isFavorite = false;
                  for (int index = 0;
                      index < snapshot.data!.docs.length;
                      index++) {
                    if (widget.product.id ==
                        snapshot.data!.docs[index].get("id")) {
                      isFavorite = true;
                    }
                  }
                  return Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
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
                                      fontSize: 16,
                                      overflow: TextOverflow.clip),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  // final user = FirebaseAuth.instance.currentUser!.email;
                                  // final fa = FirebaseFirestore.instance
                                  //     .collection('favoritelist')
                                  //     .doc(user)
                                  //     .collection(user.toString())
                                  //     .doc(widget.product.id);
                                  // final snap = await fa.get();
                                  // print(snap.reference.id);
                                  if (!isFavorite) {
                                    FirebaseFirestore.instance
                                        .collection("favoritelist")
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.email)
                                        .collection(FirebaseAuth
                                            .instance.currentUser!.email
                                            .toString())
                                        .doc(widget.product.id)
                                        .set(widget.product.toMap(),
                                            SetOptions(merge: true));
                                  } else {
                                    FirebaseFirestore.instance
                                        .collection("favoritelist")
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.email)
                                        .collection(FirebaseAuth
                                            .instance.currentUser!.email
                                            .toString())
                                        .doc(widget.product.id)
                                        .delete();
                                  }
                                  setState(() {
                                    isFavorite = !isFavorite;
                                  });
                                },
                                child: Icon(
                                  !isFavorite
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
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              const Text("Loại:"),
                              for (int index = 0;
                                  index < widget.product.color.length;
                                  index++)
                                Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 5),
                                    decoration: const BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    child: Text(
                                      widget.product.color[index],
                                      textAlign: TextAlign.center,
                                    )),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
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
                              'Đã bán: ${widget.product.sold}',
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          widget.product.describe.toString(),
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }),
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
