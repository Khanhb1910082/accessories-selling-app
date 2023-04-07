import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_formatter/money_formatter.dart';

class OrderStatusView extends StatefulWidget {
  const OrderStatusView({super.key});

  @override
  State<OrderStatusView> createState() => _OrderStatusViewState();
}

class _OrderStatusViewState extends State<OrderStatusView> {
  final user = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Đơn hàng"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .doc(user)
            .collection(user.toString())
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Lỗi xảy ra"),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            final product = snapshot.data!;
            return ListView(
              children: [
                for (int index = 0; index < product.docs.length; index++)
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.width / 3.5,
                              width: MediaQuery.of(context).size.width / 3.5,
                              child: Column(
                                children: [
                                  Image.network(
                                    product.docs[index].get('productUrl'),
                                    fit: BoxFit.cover,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.width / 3.5,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 1.7,
                                    child: Text(
                                      product.docs[index].get('productName'),
                                      maxLines: 1,
                                      style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Text(
                                      'Số lượng: ${product.docs[index].get('quantity').toString()}'),
                                  Text(
                                    '${MoneyFormatter(amount: product.docs[index].get('price').toDouble()).output.withoutFractionDigits}đ',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            // Column(
                            //   children: [
                            //     InkWell(
                            //       onTap: () {
                            //         setState(() {});
                            //       },
                            //       child: const Icon(
                            //         Icons.favorite_outlined,
                            //         size: 28,
                            //         color: Colors.pink,
                            //       ),
                            //     ),
                            //   ],
                            // )
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                              border: Border.symmetric(
                                  horizontal: BorderSide(
                            color: Colors.black12,
                          ))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                "Chờ xác nhận",
                                style: TextStyle(color: Colors.blueAccent),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.black26,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                              border: Border.symmetric(
                                  horizontal: BorderSide(
                            color: Colors.black12,
                          ))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.5,
                                child: const Text(
                                  "Nếu bạn có bất cứ thắc mắc gì xin vui lòng chat trực tiếp với chúng tôi.",
                                ),
                              ),
                              ElevatedButton(
                                  onPressed: () {},
                                  child: const Text("Hủy đơn hàng"))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
              ],
            );
          }
        },
      ),
    );
  }
}
