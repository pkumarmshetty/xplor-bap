import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xplor/utils/app_dimensions.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/extensions/padding.dart';
import 'package:xplor/utils/extensions/space.dart';

/// Import color definitions and custom widget
import 'widgets/build_button.dart';
import 'app_colors.dart';

/// Custom dialog view widget
class CustomDialogView extends StatelessWidget {
  /// Title of the dialog
  final String title;

  /// Message to display in the dialog
  final String message;

  /// Callback function for when the OK button is pressed
  final VoidCallback onConfirmPressed;

  /// Constructor for CustomDialogView
  const CustomDialogView({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirmPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.medium),
      ),
      backgroundColor: AppColors.white,
      elevation: 0,
      insetPadding:
          const EdgeInsets.symmetric(horizontal: AppDimensions.medium),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// Vertical space above the title
          AppDimensions.smallXL.vSpace(),

          /// Title with custom styling
          title
              .titleExtraBold(color: AppColors.countryCodeColor, size: 20.sp)
              .symmetricPadding(horizontal: AppDimensions.medium),

          /// Divider below the title
          Divider(
            color: AppColors.crossIconColor,
            thickness: 0.5.w,
          ),

          /// Vertical space below the divider
          AppDimensions.mediumXL.vSpace(),

          /// Message with custom styling
          message
              .titleRegular(
                  color: AppColors.alertDialogMessageColor, size: 14.sp)
              .symmetricPadding(horizontal: AppDimensions.medium),

          /// Vertical space below the message
          AppDimensions.large.vSpace(),

          /// OK button
          ButtonWidget(
            title: 'Ok',
            isValid: true,
            onPressed: onConfirmPressed,
          ).symmetricPadding(horizontal: AppDimensions.medium),

          /// Vertical space below the OK button
          AppDimensions.large.vSpace(),
        ],
      ),
    );
  }
}
