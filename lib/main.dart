import 'package:flutter/material.dart';
import 'package:myapp/pages/Homepage.dart';

void main() {
  runApp(const MaChongApp());
}

class MaChongApp extends StatelessWidget {
  const MaChongApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Homepage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
