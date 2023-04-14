import 'package:flutter/material.dart';
import 'package:myproject_app/ui/cart/cart_view.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import '../cart/cart_manager.dart';

class AppbarView extends StatefulWidget {
  const AppbarView({super.key});

  @override
  State<AppbarView> createState() => _AppbarViewState();
}

class _AppbarViewState extends State<AppbarView> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartManager>(context);
    return AppBar(
      //backgroundColor: const Color.fromARGB(1, 0, 0, 0),
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
        badges.Badge(
          badgeContent: Text('3'),
          child: Icon(Icons.settings),
        ),
        // const Padding(
        //     padding: EdgeInsets.only(right: 12),
        //     child: Icon(Icons.chat_outlined)),
      ],
      elevation: 0,
    );
  }
}
