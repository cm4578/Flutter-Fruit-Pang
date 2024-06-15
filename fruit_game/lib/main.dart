import 'package:flutter/material.dart';
import 'package:fruit_game/page/game_page.dart';
import 'package:fruit_game/page/result_page.dart';
import 'package:fruit_game/page/start_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static List<String> fruitTypeList = [
    'fruit-apple.png',
    'fruit-banana.png',
    'fruit-grape.png',
    'fruit-peach.png',
    'fruit-watermelon.png',
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const StartPage(),
    );
  }
}


