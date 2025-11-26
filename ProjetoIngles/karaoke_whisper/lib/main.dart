import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const KaraokeAIApp());
}

class KaraokeAIApp extends StatelessWidget {
  const KaraokeAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
