import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';
import 'app_dimensions.dart';
import 'extensions/font_style/font_styles.dart';
import 'extensions/padding.dart';
import 'extensions/space.dart';

/// Import color definitions and custom widget
import 'widgets/build_button.dart';
import 'widgets/top_header_for_dialogs.dart';

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
      insetPadding: const EdgeInsets.symmetric(horizontal: AppDimensions.medium),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// Vertical space above the title
          TopHeaderForDialogs(title: title, isCrossIconVisible: false),

          /// Message with custom styling
          message
              .titleRegular(color: AppColors.alertDialogMessageColor, size: 14.sp)
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
