import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../app_dimensions.dart';
import '../app_colors.dart';
import '../app_utils/app_utils.dart';
import '../extensions/font_style/font_styles.dart';

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

  /// The width of the button.
  final double? width;

  /// A flag indicating whether the button is enabled or not.
  final bool isValid;

  /// The callback function to be executed when the button is pressed.
  final VoidCallback? onPressed;

  /// The callback function to be executed when the button is pressed.
  final Widget? customText;

  /// The padding of the button.
  final EdgeInsets? padding;

  /// The shape of the button.
  final OutlinedBorder? shape;

  /// The shadow color of the button.
  final Color? shadowColor;

  final bool isFilled;

  final bool isShadow;

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
    this.isShadow = true,
    this.onPressed,
    this.padding,
    this.shape,
    this.width,
    this.shadowColor,
    this.isFilled = true,
  });

  /// Builds the button widget.

  @override
  Widget build(BuildContext context) {
    AppUtils.printLogs('test....$radius');
    var cornerRadius = radius ?? AppDimensions.medium;
    var innerCornerRadius = radius == null ? cornerRadius - 5 : radius! - 4;
    return isFilled
        ? GestureDetector(
            onTap: isValid ? onPressed : null,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(cornerRadius),
                border: Border.all(
                  color: AppColors.white, // Apply outer border color here
                  width: AppDimensions.small, // Double the border width for the outer border
                ),
                boxShadow: isShadow
                    ? [
                        BoxShadow(
                          color: AppColors.primaryLightColor.withOpacity(0.25),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ]
                    : null,
              ),
              child: Container(
                padding: const EdgeInsets.all(AppDimensions.smallXL),
                decoration: BoxDecoration(
                    color:
                        buttonBackgroundColor ?? (isValid ? AppColors.primaryColor : AppColors.tabsHomeUnSelectedColor),
                    borderRadius: BorderRadius.circular(innerCornerRadius)),
                // width: width ?? double.infinity,
                alignment: Alignment.center,
                child: customText ?? (title ?? '').buttonTextBold(size: fontSize ?? 14.sp, color: Colors.white),
              ),
            ),
          )
        : GestureDetector(
            onTap: onPressed,
            child: Container(
              //width: width ?? double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(cornerRadius),
                border: Border.all(
                  color: AppColors.white, // Apply outer border color here
                  width: AppDimensions.small, // Double the border width for the outer border
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
              child: Container(
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(horizontal: AppDimensions.large, vertical: AppDimensions.smallXL - 2),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(innerCornerRadius),
                  border: Border.all(
                    color: AppColors.primaryColor,
                    width: 1,
                  ),
                ),
                child: customText ?? (title ?? '').buttonTextBold(size: fontSize ?? 14.sp, color: Colors.white),
              ),
            ),
          );
  }
}
