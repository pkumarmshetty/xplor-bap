import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xplor/utils/app_colors.dart';
import 'package:xplor/utils/app_dimensions.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/extensions/padding.dart';

class CircularButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isValid;
  final double elevation;
  final double? padding;
  final String? title;

  const CircularButton(
      {super.key,
      required this.onPressed,
      required this.isValid,
      this.elevation = 1.0, // Default elevation value
      this.padding = AppDimensions.small, // Default padding value
      this.title // Default padding value
      });

  /*@override
  Widget build(BuildContext context) {
    // Calculate the button size based on the child widget and padding
    double buttonSize = (child is Text ? 113.sp : 83.sp);

    return GestureDetector(
      onTap: isValid ? onPressed : null,
      child: Material(
        elevation: elevation, // Add elevation to the button
        shape: const CircleBorder(),
        child: Container(
          width: buttonSize,
          height: buttonSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white, // White border
              width: AppDimensions.medium, // Border width
            ),
          ),
          child: ClipOval(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300), // Animation duration
              opacity: isValid ? 1.0 : 0.5, // Opacity value
              child: Container(
                color: isValid ? AppColors.primaryColor : AppColors.disableColor,
                child: Center(child: child),
              ),
            ),
          ),
        ),
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    var cornerRadius = AppDimensions.medium;
    return GestureDetector(
      onTap: isValid ? onPressed : null,
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.large, vertical: AppDimensions.smallXL),
        decoration: BoxDecoration(
          color: (isValid ? AppColors.primaryColor : AppColors.tabsHomeUnSelectedColor),
          borderRadius: BorderRadius.circular(cornerRadius),
          border: Border.all(
            color: AppColors.white,
            width: AppDimensions.small,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryLightColor.withOpacity(0.25),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: (title ?? '').buttonTextBold(size: 14.sp, color: Colors.white),
      ).symmetricPadding(
        vertical: AppDimensions.smallXL,
      ),
    );
  }
}
