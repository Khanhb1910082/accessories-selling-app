import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myproject_app/model/user.dart';
import 'package:myproject_app/service/favorite_service.dart';
import 'package:myproject_app/service/user_service.dart';
import 'package:provider/provider.dart';

import 'ui/screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoriteManager()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Turtle-K Shop',
        theme: ThemeData(
          primarySwatch: Colors.pink,
        ),
        home: const MainPage(),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white70,
        body: StreamBuilder<List<Users>>(
            stream: UserService.readUser(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const HomeView();
              } else {
                return const LoginView();
              }
            }));
  }
}
