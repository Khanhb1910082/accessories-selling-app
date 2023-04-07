import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../model/user.dart';
import '../screen.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool pass = true;
  bool repass = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  late Users user;
  @override
  Widget build(BuildContext context) {
    precacheImage(img_bg, context);
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: img_bg,
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ListView(
          children: [
            SizedBox(
              child: Column(
                children: [
                  Image.asset("assets/logo/logo.png"),
                  Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.black12,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white24,
                                  borderRadius: BorderRadius.circular(30)),
                              child: const Icon(Icons.arrow_back, size: 35),
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              child: const Text(
                                "Đăng ký",
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.pink,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                          _buildEmailField(),
                          const SizedBox(height: 10),
                          _buildPasswordField(),
                          const SizedBox(height: 10),
                          _buildConfirmPasswordField(),
                          const SizedBox(height: 10),
                          _buildSubmitField(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.email_rounded,
          color: Colors.pink,
          size: 26,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 17),
        fillColor: Colors.white,
        filled: true,
        hintText: 'Email',
        hintStyle: const TextStyle(color: Colors.black12),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none),
      ),
      style: const TextStyle(fontSize: 17),
      keyboardType: TextInputType.emailAddress,
      cursorColor: Colors.pink,
      validator: (value) {
        if (value!.isEmpty) {
          return "Vui lòng nhập email.";
        }
        if (!value.contains('@') || value.length > 100) {
          return 'Sai định dạng email.';
        }
        return null;
      },
      onSaved: (newValue) {},
    );
  }

  _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.key_rounded,
          color: Colors.pink,
          size: 26,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 17),
        fillColor: Colors.white,
        filled: true,
        hintText: 'Mật khẩu',
        hintStyle: const TextStyle(color: Colors.black12),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none),
        suffixIcon: _getIcon(),
      ),
      style: const TextStyle(fontSize: 17),
      obscureText: pass,
      cursorColor: Colors.pink,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Vui lòng nhập mật khẩu.';
        } else if (value.length < 5) {
          return 'Độ dài mật khẩu quá ngắn.';
        }
        return null;
      },
      onSaved: (newValue) {},
    );
  }

  _getIcon() {
    return GestureDetector(
      onTap: () {
        setState(() {
          pass = !pass;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SvgPicture(
          pass
              ? const SvgAssetLoader(
                  "assets/icons/eye-open.svg",
                )
              : const SvgAssetLoader("assets/icons/eye-closed.svg"),
          colorFilter: const ColorFilter.mode(Colors.black38, BlendMode.srcIn),
        ),
      ),
    );
  }

  _buildSubmitField() {
    return ElevatedButton(
      onPressed: () async {
        if (!_formKey.currentState!.validate()) {
          return;
        }
        FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);

        _formKey.currentState!.save();
        FirebaseFirestore.instance
            .collection("users")
            .doc(_emailController.text)
            .set(
          {
            "email": _emailController.text,
            "address": "",
            "phone": "",
          },
          SetOptions(merge: true),
        );
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Đăng ký thành công'),
            content: const Text(
                'Đăng nhập ngay để nhận ngay hàng ngàn sản phẩm được trợ giá'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginView())),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.pinkAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 12),
      ),
      child: const Text(
        "Đăng ký",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }

  _buildConfirmPasswordField() {
    return TextFormField(
      controller: _repasswordController,
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.key_rounded,
          color: Colors.pink,
          size: 26,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 17),
        fillColor: Colors.white,
        filled: true,
        hintText: 'Mật lại khẩu',
        hintStyle: const TextStyle(color: Colors.black12),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none),
      ),
      style: const TextStyle(fontSize: 17),
      obscureText: repass,
      cursorColor: Colors.pink,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Vui lòng nhập lại mật khẩu.';
        } else if (_passwordController.text != value) {
          return 'Mật khẩu không khớp.';
        }
        return null;
      },
      onSaved: (newValue) {},
    );
  }
}
