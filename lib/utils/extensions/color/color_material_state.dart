import 'package:flutter/material.dart';

import '../../app_colors.dart';

extension MaterialStateColorExtension on Set<WidgetState> {
  Color getFillColor() {
    if (contains(WidgetState.selected)) {
      return AppColors.primaryColor; // Selected color
    }
    return AppColors.hintColor; // Unselected color
  }
}
