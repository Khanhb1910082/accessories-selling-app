import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:myproject_app/service/cart_service.dart';
import 'package:myproject_app/ui/order/order_view.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  bool _checkout = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Giỏ hàng"),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('cart')
              .doc(FirebaseAuth.instance.currentUser!.email)
              .collection(FirebaseAuth.instance.currentUser!.email.toString())
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.size != 0) {
              final cart = snapshot.data!;
              return ListView.builder(
                  itemCount: cart.docs.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 120,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                            activeColor: Colors.deepOrange,
                            value: snapshot.data!.docs[index].get("payment"),
                            onChanged: (value) {
                              setState(() {
                                value = _checkout;
                                _checkout = !_checkout;
                                FirebaseFirestore.instance
                                    .collection('cart')
                                    .doc(FirebaseAuth
                                        .instance.currentUser!.email)
                                    .collection(FirebaseAuth
                                        .instance.currentUser!.email
                                        .toString())
                                    .doc(cart.docs[index].get("id"))
                                    .update({"payment": _checkout});
                              });
                            },
                          ),
                          Container(
                            height: 100,
                            width: 80,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.network(
                              cart.docs[index].get("productUrl"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                    cart.docs[index].get("productName"),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                  ),
                                ),
                                Text(
                                  '${cart.docs[index].get("color")}',
                                  style: TextStyle(
                                    fontSize: 14.5,
                                    color: Colors.black.withOpacity(0.8),
                                  ),
                                ),
                                Text(
                                  '${MoneyFormatter(amount: cart.docs[index].get("quantity") * cart.docs[index].get("price").toDouble()).output.withoutFractionDigits}đ',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepOrange),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      FirebaseFirestore.instance
                                          .collection('cart')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.email)
                                          .collection(FirebaseAuth
                                              .instance.currentUser!.email
                                              .toString())
                                          .doc(cart.docs[index].id)
                                          .delete();
                                    });
                                  },
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const SizedBox(width: 10),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (cart.docs[index].get("quantity") >
                                              1) {
                                            FirebaseFirestore.instance
                                                .collection('cart')
                                                .doc(FirebaseAuth.instance
                                                    .currentUser!.email)
                                                .collection(FirebaseAuth
                                                    .instance.currentUser!.email
                                                    .toString())
                                                .doc(cart.docs[index].id)
                                                .update({
                                              "quantity": cart.docs[index]
                                                      .get("quantity") -
                                                  1
                                            });
                                          }
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF7F8FA),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: const Icon(
                                          CupertinoIcons.minus,
                                          size: 12,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    SizedBox(
                                      width: 25,
                                      child: Center(
                                        child: Text(
                                          MoneyFormatter(
                                                  amount: cart.docs[index]
                                                      .get("quantity")
                                                      .toDouble())
                                              .output
                                              .withoutFractionDigits,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 0),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (cart.docs[index].get("quantity") <
                                              40) {
                                            FirebaseFirestore.instance
                                                .collection('cart')
                                                .doc(FirebaseAuth.instance
                                                    .currentUser!.email)
                                                .collection(FirebaseAuth
                                                    .instance.currentUser!.email
                                                    .toString())
                                                .doc(cart.docs[index].id)
                                                .update({
                                              "quantity": cart.docs[index]
                                                      .get("quantity") +
                                                  1,
                                            });
                                          }
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF7F8FA),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: const Icon(
                                          Icons.add,
                                          size: 15,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            }
            return const Center(
                child: Text("Bạn chưa có sản phẩm trong giỏ hàng."));
          }),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  _buildBottomBar() {
    double widthDevice = MediaQuery.of(context).size.width;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('cart')
            .doc(FirebaseAuth.instance.currentUser!.email)
            .collection(FirebaseAuth.instance.currentUser!.email.toString())
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // ignore: avoid_print
            print(snapshot.hasError.toString());
          } else if (snapshot.hasData) {
            double sum = 0;
            for (int index = 0; index < snapshot.data!.docs.length; index++) {
              if (snapshot.data!.docs[index].get("payment") == true) {
                sum = sum +
                    snapshot.data!.docs[index].get("price") *
                        snapshot.data!.docs[index].get("quantity");
              }
            }

            return BottomAppBar(
              child: SizedBox(
                height: widthDevice / 7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: widthDevice / 7,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                width: widthDevice / 3,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: const [
                                    Text(
                                      "Tổng: ",
                                      style: TextStyle(
                                          color: Colors.deepOrange,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: widthDevice / 7,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                width: widthDevice / 3,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${MoneyFormatter(amount: sum).output.withoutFractionDigits}đ',
                                      style: const TextStyle(
                                          color: Colors.deepOrange,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (snapshot.data!.size != 0) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const OrderView()));
                            }
                          },
                          child: Container(
                            height: widthDevice / 7,
                            decoration:
                                const BoxDecoration(color: Colors.pinkAccent),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: widthDevice / 3,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        "Thanh toán",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.5,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
