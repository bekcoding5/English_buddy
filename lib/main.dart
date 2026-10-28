import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'pages/shell.dart';

void main() => runApp(const EnglishBuddy());

class EnglishBuddy extends StatelessWidget {
  const EnglishBuddy({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'English Buddy',
      theme: buildTheme(),
      home: const Shell(),
    );
  }
}