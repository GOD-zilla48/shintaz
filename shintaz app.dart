import 'package:flutter/material.dart';
import 'screen/splash_screen.dart';
import 'screen/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Syn cra App',
      theme: ThemeData.dark(),
      home: const SplashScreen(),
    );
  }
}