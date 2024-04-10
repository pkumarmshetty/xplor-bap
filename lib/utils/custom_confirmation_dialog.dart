import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xplor/utils/app_dimensions.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/extensions/padding.dart';
import 'package:xplor/utils/extensions/space.dart';

/// Importing custom widgets and resources
import '../features/on_boarding/presentation/widgets/build_button.dart';
import 'app_colors.dart';

/// Custom dialog for confirmation
class CustomConfirmationDialog extends StatelessWidget {
  /// Asset path of the dialog
  final String assetPath;

  /// Title of the dialog
  final String title;

  /// Message body of the dialog
  final Widget message;

  /// Callback function for OK button press
  final VoidCallback onConfirmPressed;

  /// Constructor for CustomConfirmationDialog
  const CustomConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirmPressed,
    required this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // Setting up dialog shape
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.medium),
      ),
      // Setting background color of the dialog
      backgroundColor: AppColors.white,
      elevation: 0,
      // Adjusting padding inside the dialog
      insetPadding: const EdgeInsets.symmetric(horizontal: AppDimensions.medium),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Success icon
            SvgPicture.asset(
              assetPath,
              height: 64.w,
              width: 64.w,
            ),
            AppDimensions.large.vSpace(),
            // Dialog title
            title.titleSemiBold(
              color: AppColors.countryCodeColor,
              size: 18.sp,
            ),
            AppDimensions.small.vSpace(),
            // Dialog message
            message,
            AppDimensions.mediumXL.vSpace(),
            // OK button
            ButtonWidget(
              title: 'Ok',
              isValid: true,
              onPressed: onConfirmPressed,
            ).symmetricPadding(horizontal: AppDimensions.medium),
            AppDimensions.medium.vSpace(),
          ],
        ).paddingAll(padding: AppDimensions.mediumXL),
      ),
    );
  }
}
