import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myproject_app/ui/product/product_list.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import '../cart/cart_manager.dart';
import '../screen.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartManager>(context);
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
              child: badges.Badge(
                position: badges.BadgePosition.topEnd(top: -12, end: -12),
                showBadge: true,
                ignorePointer: false,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CartView()));
                },
                badgeContent: Text('${cartProvider.cartCount}'),
                badgeAnimation: const BadgeAnimation.scale(
                  animationDuration: Duration(seconds: 1),
                  colorChangeAnimationDuration: Duration(seconds: 1),
                  loopAnimation: false,
                  curve: Curves.fastOutSlowIn,
                  colorChangeAnimationCurve: Curves.easeInCubic,
                ),
                badgeStyle: badges.BadgeStyle(
                  badgeColor: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(4),
                  elevation: 0,
                ),
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
        ),
        body: ListView(children: const [ProductList()]));
  }
}
