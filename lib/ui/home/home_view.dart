import 'package:flutter/material.dart';
import 'package:myproject_app/ui/cart/cart_manager.dart';
import 'package:myproject_app/ui/favorite_list/favorite_list.dart';
import 'package:provider/provider.dart';
import '../screen.dart';

class HomeView extends StatefulWidget {
  const HomeView(this._page, {super.key});
  final int _page;
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late int _indexPage = widget._page;
  void _setTotalCart() async {
    final cartProvider = Provider.of<CartManager>(context, listen: false);
    await cartProvider.setTotalCart();
  }

  @override
  void initState() {
    super.initState();
    _setTotalCart();
    ChangeNotifier;
  }

  final List _pages = [
    const ProductView(),
    const FavoriteListView(),
    const ProfileView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _indexPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      //extendBodyBehindAppBar: true,
      // appBar: const PreferredSize(
      //     preferredSize: Size.fromRadius(30), child: AppbarView()),
      body: _pages[_indexPage],

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Sản phẩm'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              label: 'Yêu thích',
              activeIcon: Icon(Icons.favorite)),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: 'Tài khoản',
              activeIcon: Icon(Icons.account_circle_rounded)),
        ],
        currentIndex: _indexPage,
        onTap: _onItemTapped,
      ),
    );
  }
}
