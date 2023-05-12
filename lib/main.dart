import 'package:flutter/material.dart';
import 'package:we_chat/screens/auth/login_screen.dart';
import 'package:we_chat/screens/auth/splash_screen.dart';
import 'package:we_chat/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

late Size mq;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 1,
            iconTheme: IconThemeData(color: Colors.black),
            titleTextStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 19),
            backgroundColor: Colors.white,
          )),
      home: const SplashScreen(),
    );
  }
}
