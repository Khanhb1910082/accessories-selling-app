import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:myproject_app/model/user.dart';
import 'package:myproject_app/service/user_service.dart';
import 'package:provider/provider.dart';

import '../cart/cart_manager.dart';
import '../screen.dart';

class OrderView extends StatefulWidget {
  const OrderView({super.key});

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        title: const Text("Thanh toán"),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('cart')
              .doc(FirebaseAuth.instance.currentUser!.email)
              .collection(FirebaseAuth.instance.currentUser!.email.toString())
              .where("payment", isEqualTo: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.hasError.toString());
            } else if (snapshot.hasData) {
              final cart = snapshot.data!;
              double sum = 0;
              for (int index = 0; index < snapshot.data!.docs.length; index++) {
                sum = sum +
                    snapshot.data!.docs[index].get("price") *
                        snapshot.data!.docs[index].get("quantity");
              }
              return ListView(children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom: BorderSide(
                        color: Colors.pink,
                        width: 3,
                      ))),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Icon(
                                Icons.fmd_good_sharp,
                                size: 30,
                                color: Colors.deepOrange,
                              )),
                          StreamBuilder(
                              stream: UserService.readUser(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Center(
                                      child:
                                          Text(snapshot.hasError.toString()));
                                } else if (snapshot.hasData) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: snapshot.data!
                                        .map(_buildUserDetail)
                                        .toList(),
                                  );
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              }),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.green,
                    ),
                    child: const Center(
                        child: Text(
                      "Danh sách sản phẩm thanh toán",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ))),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white10,
                    border: Border.symmetric(
                        horizontal: BorderSide(color: Colors.pink, width: 3)),
                    //borderRadius: BorderRadius.circular(10),
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        itemCount: cart.docs.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 122,
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  height: 100,
                                  width: 100,
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                            color:
                                                Colors.black.withOpacity(0.7),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        cart.docs[index].get("color"),
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        children: [
                                          const SizedBox(width: 8),
                                          SizedBox(
                                            width: 25,
                                            child: Center(
                                              child: Text(
                                                'x${MoneyFormatter(amount: cart.docs[index].get("quantity").toDouble()).output.withoutFractionDigits}',
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
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
                        }),
                  ),
                ),
                Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Icon(
                                Icons.payment,
                                size: 30,
                                color: Colors.deepOrange,
                              ),
                            ),
                            Text(
                              "Chi tiết thanh toán ",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Tổng giá trị đơn hàng"),
                              Text(MoneyFormatter(amount: sum.toDouble())
                                  .output
                                  .withoutFractionDigits),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text("Phí vận chuyển"),
                              Text("0đ"),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Tổng thanh toán",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                              Text(
                                '${MoneyFormatter(amount: sum.toDouble()).output.withoutFractionDigits}đ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: const Text(
                      "Nhấn \"Đặt hàng\" đồng nghĩa với việc bạn đồng ý tuân theo Điều khoản Turtle-K"),
                ),
              ]);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  _buildBottomBar() {
    double widthDevice = MediaQuery.of(context).size.width;
    final cartProvider = Provider.of<CartManager>(context);
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('cart')
            .doc(FirebaseAuth.instance.currentUser!.email)
            .collection(FirebaseAuth.instance.currentUser!.email.toString())
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.hasError.toString()));
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
                          onTap: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const TransactionView()));
                            if (snapshot.data!.size != 0) {
                              final cart = snapshot.data!;
                              for (int index = 0;
                                  index < cart.docs.length;
                                  index++) {
                                if (cart.docs[index].get("payment") == true) {
                                  FirebaseFirestore.instance
                                      .collection('orders')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.email)
                                      .collection(FirebaseAuth
                                          .instance.currentUser!.email
                                          .toString())
                                      .doc()
                                      .set(cart.docs[index].data(),
                                          SetOptions(merge: false));

                                  final total = FirebaseFirestore.instance
                                      .collection('accessory')
                                      .doc(cart.docs[index].get("id"));
                                  final snap = await total.get();
                                  FirebaseFirestore.instance
                                      .collection('accessory')
                                      .doc(cart.docs[index].get("id"))
                                      .update({
                                    "sold": snap.get("sold") +
                                        cart.docs[index].get("quantity")
                                  });
                                }
                              }
                            }
                            var collection = FirebaseFirestore.instance
                                .collection('cart')
                                .doc(FirebaseAuth.instance.currentUser!.email)
                                .collection(FirebaseAuth
                                    .instance.currentUser!.email
                                    .toString());
                            var snapshots = await collection.get();
                            for (var doc in snapshots.docs) {
                              if (doc.get("payment") == true) {
                                doc.reference.delete();
                                cartProvider.deleteToCart(doc.get('quantity'));
                              }
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
                                        "Đặt hàng",
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
        });
  }

  Widget _buildUserDetail(Users user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Địa chỉ nhận hàng",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              Text(user.email,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500)),
              const SizedBox(width: 10),
              Text('Phone: ${user.phone}',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        Text(
          'Địa chỉ: ${user.address}',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
