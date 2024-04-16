import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xplor/utils/app_colors.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';

/// A button widget with customizable properties.
class ButtonWidget extends StatelessWidget {
  /// The text displayed on the button.
  final String? title;

  /// The background color of the button.
  final Color? buttonBackgroundColor;

  /// The foreground color of the button (text color).
  final Color? buttonForegroundColor;

  /// The border radius of the button.
  final double? radius;

  /// The font size of the button text.
  final double? fontSize;

  /// A flag indicating whether the button is enabled or not.
  final bool isValid;

  /// The callback function to be executed when the button is pressed.
  final VoidCallback? onPressed;

  /// The callback function to be executed when the button is pressed.
  final Text? customText;

  /// Constructs a [ButtonWidget] with the given properties.
  const ButtonWidget({
    super.key,
    this.title,
    this.customText,
    this.buttonBackgroundColor,
    this.buttonForegroundColor,
    this.radius,
    this.fontSize,
    this.isValid = false,
    this.onPressed,
  });

  /// Builds the button widget.
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Set width to full width
      child: ElevatedButton(
        onPressed: isValid ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonBackgroundColor ?? AppColors.primaryColor, // Button Background color
          foregroundColor: buttonForegroundColor ?? Colors.white, // To set button text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(radius ?? 8.0),
            ), // To remove the default radius.
          ),
        ),
        child: customText ?? (title ?? '').buttonTextBold(size: fontSize ?? 14.sp),
      ),
    );
  }
}
