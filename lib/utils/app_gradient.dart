import 'package:flutter/cupertino.dart';
import 'app_colors.dart';

class AppGradients {
  /// Gradient for button backgrounds
  static const LinearGradient buttonGradient = LinearGradient(
    colors: [
      AppColors.primaryDarkColor,
      AppColors.primaryColor,
    ],
    begin: Alignment.topCenter, // Start from the top
    end: Alignment.bottomCenter, // End at the bottom
    stops: [0.0, 1.0],
    tileMode: TileMode.clamp,
  );

  static const LinearGradient disableButtonGradient = LinearGradient(
    colors: [
      AppColors.cancelButtonBgColor,
      AppColors.cancelButtonBgColor,
    ],
    begin: Alignment.topCenter, // Start from the top
    end: Alignment.bottomCenter, // End at the bottom
    stops: [0.0, 1.0],
    tileMode: TileMode.clamp,
  );

  /// Gradient for screen backgrounds, headers
  static const LinearGradient screenBackgroundGradient = LinearGradient(
    colors: [
      AppColors.primaryColor,
      AppColors.primaryDarkColor,
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    stops: [0.0, 1.0],
    tileMode: TileMode.clamp,
  );
}
