import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';

import '../app_colors.dart';
import '../app_dimensions.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.onTap,
    required this.title,
    this.buttonWidth,
    required this.disabled,
  });

  final VoidCallback onTap;
  final String title;
  final double? buttonWidth;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: buttonWidth,
        height: 32,
        decoration: BoxDecoration(
          color: disabled ? AppColors.hintColor : AppColors.primaryColor,
          // Set the background color to white or Colors.transparent for transparency
          borderRadius: const BorderRadius.all(Radius.circular(AppDimensions.extraSmall)),
          // Adjust radius as needed
          border: Border.all(
            color: disabled ? AppColors.hintColor : AppColors.primaryColor,
            // Border color
            width: 1, // Border width
          ),
        ),
        child: Center(
          child: title.titleBold(
            color: AppColors.white,
            size: AppDimensions.smallXL.sp,
          ),
        ),
      ),
    );
  }
}
