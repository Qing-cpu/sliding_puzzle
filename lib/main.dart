import 'package:flutter/material.dart';
import 'package:sliding_puzzle/pages/start_page.dart';

import 'data/db_tools/db_tools.dart';

void main() {
  final WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();
  DBTools.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '拼图滑块',
      home: const StartPage(),
    );
  }
}
