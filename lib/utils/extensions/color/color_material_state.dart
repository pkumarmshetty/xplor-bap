import 'package:flutter/material.dart';

import '../../app_colors.dart';

extension MaterialStateColorExtension on Set<MaterialState> {
  Color getFillColor() {
    if (contains(MaterialState.selected)) {
      return AppColors.primaryColor; // Selected color
    }
    return AppColors.hintColor; // Unselected color
  }
}
