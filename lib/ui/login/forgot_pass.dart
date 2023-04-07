import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

var imgbg = const AssetImage("assets/images/background.png");

class ForgotPassWord extends StatefulWidget {
  const ForgotPassWord({super.key});

  @override
  State<ForgotPassWord> createState() => _ForgotPassWordState();
}

class _ForgotPassWordState extends State<ForgotPassWord> {
  final _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(imgbg, context);
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: imgbg,
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
                          Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              child: const Text(
                                "Quên mật khẩu",
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.pink,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                          _buildEmailField(),
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
        ),
        fillColor: Colors.white,
        filled: true,
        hintText: 'Email',
        hintStyle: const TextStyle(color: Colors.black12),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none),
      ),
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

  _buildSubmitField() {
    return ElevatedButton(
      onPressed: _resetpassword,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.pinkAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 12),
      ),
      child: const Text(
        "Đặt lại mật khẩu",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }

  Future _resetpassword() async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: _emailController.text.trim());
  }
}
