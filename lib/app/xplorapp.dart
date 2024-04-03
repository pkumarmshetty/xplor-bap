import 'package:flutter/material.dart';

import '../core/router.dart';

class XplorApp extends StatelessWidget {
  const XplorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Xplor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routerConfig: GoRouterSingleton.instance.goRouter,
    );
  }
}
