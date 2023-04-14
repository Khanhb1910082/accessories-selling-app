import 'package:badges/badges.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myproject_app/service/user_service.dart';
import 'package:myproject_app/ui/profile/profile_detail.dart';
import 'package:myproject_app/ui/screen.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import '../../model/user.dart';
import '../cart/cart_manager.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartManager>(context);
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
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
              padding: EdgeInsets.only(right: 12, top: 16),
              child: Icon(Icons.chat_outlined)),
        ],
        bottom: PreferredSize(
            preferredSize: Size(width, width / 5), child: _buidAvataField()),
      ),
      body: StreamBuilder<List<Users>>(
          stream: UserService.readUser(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text("Lỗi phát sinh"));
            } else if (snapshot.hasData) {
              final user = snapshot.data!;
              return ListView(
                children: user.map(_buildUser).toList(),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Widget _buildUser(Users user) {
    final cartProvider = Provider.of<CartManager>(context);
    double widthDevice = MediaQuery.of(context).size.width;
    return Center(
      child: Column(children: [
        InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfileDetail(user)));
          },
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              children: [
                Container(
                  width: widthDevice / 7,
                  padding: const EdgeInsets.all(10),
                  child: const Icon(
                    Icons.account_box_rounded,
                    color: Colors.pink,
                    size: 35,
                  ),
                ),
                const Text(
                  "Thông tin người dùng",
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 5),
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const OrderStatusView()));
          },
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              children: [
                Container(
                  width: widthDevice / 7,
                  padding: const EdgeInsets.all(10),
                  child: const Icon(
                    Icons.near_me_rounded,
                    color: Colors.pink,
                    size: 35,
                  ),
                ),
                const Text(
                  "Thông tin đơn hàng",
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 5),
        InkWell(
          onTap: () {
            FirebaseAuth.instance.signOut().then((value) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginView()),
                  (route) => false);
              cartProvider.clearCart();
            }).onError((error, stackTrace) {
              Center(
                child: Text("Error ${error.toString()}"),
              );
            });
          },
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              children: [
                Container(
                  width: widthDevice / 7,
                  padding: const EdgeInsets.all(10),
                  child: const Icon(
                    Icons.logout_outlined,
                    color: Colors.pink,
                    size: 35,
                  ),
                ),
                const Text(
                  "Đăng xuất",
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buidAvataField() {
    return StreamBuilder(
        stream: UserService.readUser(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Hệ thống đang được bảo trì"),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            final user = snapshot.data!;
            return Column(
              children: user.map(_buidUserDetail).toList(),
            );
          }
        });
  }

  Widget _buidUserDetail(Users user) {
    double width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Column(
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              width: width / 5,
              height: width / 5,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(width),
              ),
              child: const Center(
                  child: Text(
                "Sửa",
                style: TextStyle(fontWeight: FontWeight.w700),
              )),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.email,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
                decoration: const BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Row(
                  children: const [
                    Text(
                      "Thành viên",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.black,
                      size: 11,
                    ),
                  ],
                )),
            const Text(
              "Yêu thích",
              style: TextStyle(color: Colors.white),
            ),
          ],
        )
      ],
    );
  }
}
