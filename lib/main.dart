import 'package:flutter/material.dart';
import 'app/xplorapp.dart';
import 'core/dependency_injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  runApp(const XplorApp());
}
