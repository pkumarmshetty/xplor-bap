import 'package:flutter/material.dart';
import 'package:xplor/core/router.dart';

import 'app/xplorapp.dart';
import 'core/dependency_injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  GoRouterSingleton.instance.initialize();
  runApp(const XplorApp());
}
