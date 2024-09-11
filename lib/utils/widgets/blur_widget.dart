import 'dart:ui';

import 'package:flutter/cupertino.dart';
import '../app_colors.dart';

Widget blurWidget(Widget child) {
  return Stack(
    children: [
      // Background blur effect
      Positioned.fill(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
          child: Container(
            color: AppColors.primarya7b7C6.withOpacity(0.5), // Adjust opacity as needed
          ),
        ),
      ),
      // Dialog
      child
    ],
  );
}
