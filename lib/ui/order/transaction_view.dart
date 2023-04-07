import 'package:flutter/material.dart';
import '../screen.dart';

class TransactionView extends StatefulWidget {
  const TransactionView({super.key});

  @override
  State<TransactionView> createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      "Đặt hàng thành công",
                      style: TextStyle(fontSize: 24),
                    )),
                Image.asset(
                  "assets/images/tick.png",
                  height: 30,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeView()),
                              (route) => false);
                        },
                        child: const Text("Trang chủ"))
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          // Navigator.pushAndRemoveUntil(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => const HomeView()),
                          //     (route) => false);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const OrderStatusView()));
                        },
                        child: const Text("Đơn hàng")),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
