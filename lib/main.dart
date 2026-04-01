import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'home_page.dart';

void main() {
  runApp(const VisiaxxApp());
}

class VisiaxxApp extends StatelessWidget {
  const VisiaxxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Visiaxx — Vision Care, Reimagined',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomePage(),
    );
  }
}
