import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../screen.dart';
import 'forgot_pass.dart';

var imgbg = const AssetImage("assets/images/background.png");

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool pass = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

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
                                "Đăng nhập",
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.pink,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                          _buildEmailField(),
                          const SizedBox(height: 10),
                          _buildPasswordField(),
                          _buildResetPassWordField(),
                          _buildSubmitField(),
                          _buildAnotherLogin(),
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

  _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.key_rounded,
          color: Colors.pink,
        ),
        fillColor: Colors.white,
        filled: true,
        hintText: 'Mật khẩu',
        hintStyle: const TextStyle(color: Colors.black12),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none),
        suffixIcon: _getIcon(),
      ),
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
      onPressed: _signIn,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.pinkAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 12),
      ),
      child: const Text(
        "Đăng nhập",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }

  _buildResetPassWordField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ForgotPassWord()));
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            child: const Text(
              "Quên mật khẩu?",
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildAnotherLogin() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Text(
            "- Đăng nhập với -",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.1),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: SvgPicture.asset(
                  "assets/icons/google.svg",
                  height: 30,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.1),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: SvgPicture.asset(
                  "assets/icons/facebook.svg",
                  height: 37,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.1),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: SvgPicture.asset(
                  "assets/icons/phone-call.svg",
                  height: 35,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              "Nếu bạn chưa có tài khoản? ",
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterView()));
              },
              child: const Text(
                "Đăng ký ngay.",
                style: TextStyle(
                  color: Color.fromARGB(255, 3, 15, 244),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<User?> _signIn() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      )
          .then((value) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeView()));
      });
    }
    return null;
  }
}
