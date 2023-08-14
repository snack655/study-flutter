import 'package:flutter/material.dart';
import 'package:medi/pages/home_page.dart';
import 'components/medi_themes.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: MediThemes.lightTheme,
      home: const HomePage(),
    );
  }
}
