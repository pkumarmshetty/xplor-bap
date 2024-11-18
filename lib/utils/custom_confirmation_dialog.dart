import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../features/multi_lang/domain/mappers/on_boarding/on_boardings_keys.dart';
import 'extensions/string_to_string.dart';
import 'widgets/blur_widget.dart';
import 'app_colors.dart';
import 'app_dimensions.dart';
import 'extensions/padding.dart';

/// Importing custom widgets and resources
import 'widgets/build_button.dart';

/// Custom dialog for confirmation
class CustomConfirmationDialog extends StatelessWidget {
  /// Asset path of the dialog
  final String assetPath;

  /// Title of the dialog
  final Widget title;

  /// Message body of the dialog
  final Widget message;

  /// Callback function for OK button press
  final VoidCallback onConfirmPressed;

  /// Button title
  final String? buttonTitle;

  /// Constructor for CustomConfirmationDialog
  const CustomConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirmPressed,
    required this.assetPath,
    this.buttonTitle,
  });

  @override
  Widget build(BuildContext context) {
    return blurWidget(Dialog(
      // Setting up dialog shape
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.medium),
      ),
      // Setting background color of the dialog
      backgroundColor: AppColors.white,
      elevation: 0,
      // Adjusting padding inside the dialog
      insetPadding: const EdgeInsets.symmetric(horizontal: AppDimensions.medium),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Success icon
          SvgPicture.asset(
            assetPath,
            height: 137.w,
            width: 148.w,
          ),
          AppDimensions.large.verticalSpace,
          // Dialog title
          title,
          AppDimensions.small.verticalSpace,
          // Dialog message
          message,
          AppDimensions.mediumXL.verticalSpace,
          // OK button
          ButtonWidget(
            title: buttonTitle ?? OnBoardingKeys.okay.stringToString,
            isValid: true,
            onPressed: onConfirmPressed,
          ),
        ],
      ).paddingAll(padding: AppDimensions.mediumXL),
    ));
  }
}
