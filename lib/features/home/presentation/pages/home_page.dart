import 'package:flutter/material.dart';
import 'package:xplor/core/app_router.dart';

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
          const Text("Welcome to Xplor!"),
          const SizedBox(height: 50),
          ElevatedButton(
              onPressed: () => AppRouter.routes.dynamic,
              child: const Text('Dynamic Json UI form'))
        ],
      )),
    );
  }
}
