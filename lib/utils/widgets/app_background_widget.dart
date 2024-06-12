import 'package:flutter/cupertino.dart';
import 'package:xplor/gen/assets.gen.dart';

class AppBackgroundDecoration extends StatelessWidget {
  const AppBackgroundDecoration({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(Assets.images.appBackground.path), fit: BoxFit.cover),
      ),
      child: child,
    );
  }
}
