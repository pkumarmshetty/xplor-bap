import 'package:flutter/material.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          "Welcome".titleBold(),
        ],
      )),
    );
  }
}
