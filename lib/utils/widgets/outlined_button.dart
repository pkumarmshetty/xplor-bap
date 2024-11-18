import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../extensions/font_style/font_styles.dart';
import '../app_colors.dart';
import '../app_dimensions.dart';

class OutLinedButton extends StatelessWidget {
  const OutLinedButton({
    super.key,
    required this.onTap,
    required this.title,
    this.buttonWidth,
  });

  final VoidCallback onTap;
  final String title;
  final double? buttonWidth;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: buttonWidth,
        height: AppDimensions.xxl.w,
        decoration: BoxDecoration(
          color: Colors.transparent,
          // Set the background color to white or Colors.transparent for transparency
          borderRadius: const BorderRadius.all(Radius.circular(AppDimensions.extraSmall)),
          // Adjust radius as needed
          border: Border.all(
            color: AppColors.primaryColor, // Border color
            width: 1, // Border width
          ),
        ),
        child: Center(
          child: title.titleBold(
            color: AppColors.primaryColor,
            size: AppDimensions.smallXL.sp,
          ),
        ),
      ),
    );
  }
}
