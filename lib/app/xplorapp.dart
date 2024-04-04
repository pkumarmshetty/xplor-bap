import 'package:flutter/material.dart';

import '../core/app_router.dart';

class XplorApp extends StatelessWidget {
  const XplorApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter.router();
    return MaterialApp.router(
      debugShowCheckedModeBanner: true,
      title: 'Xplor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
