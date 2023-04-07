import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myproject_app/ui/product/product_list.dart';

import '../screen.dart';

class ProductView extends StatelessWidget {
  const ProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
          ),
          title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            height: 35,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const TextField(
              decoration: InputDecoration(
                icon: Icon(
                  Icons.search_outlined,
                  size: 25,
                  color: Colors.pink,
                ),
                hintText: 'Set quà tặng siêu cute',
                border: InputBorder.none,
              ),
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const CartView()));
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(
                  Icons.shopping_cart_outlined,
                  size: 28,
                ),
              ),
            ),
            const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(Icons.chat_outlined)),
          ],
        ),
        body: ListView(children: [ProductList()]));
  }
}
