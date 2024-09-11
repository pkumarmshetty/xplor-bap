import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';

/// A widget for creating an "Update" button with customizable text and action.
class UpdateButtonWidget extends StatelessWidget {
  final String text; // The text displayed on the button
  final VoidCallback onPressed; // The callback function when the button is pressed

  const UpdateButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, // Set the onPressed callback function
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        // Remove any internal padding
        backgroundColor: AppColors.primaryColor,
        // Set the button's background color
        foregroundColor: Colors.white,
        // Set the button's text color
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppDimensions.extraSmall), // Set a uniform border radius of 4.0
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        // Wrap content size to the minimum
        mainAxisAlignment: MainAxisAlignment.center,
        // Center-align the row content
        crossAxisAlignment: CrossAxisAlignment.center,
        // Center-align vertically
        children: [
          SvgPicture.asset(
            Assets.images.updateIcon, // Load the SVG icon for the update button
            height: AppDimensions.medium.w, // Set the icon height
            width: AppDimensions.medium.w, // Set the icon width
          ),
          AppDimensions.small.w.horizontalSpace,
          // Add horizontal space between icon and text
          text.titleBold(
            size: AppDimensions.smallXL, // Set the text size to 12sp
            color: AppColors.white, // Set the text color to white
          ),
        ],
      ),
    );
  }
}

/// A widget for creating a "Revoke" button with customizable properties.
class RevokeButtonWidget extends StatelessWidget {
  final String text; // The text displayed on the button
  final SvgPicture icon; // The icon displayed on the button
  final int radius; // The border radius for the button
  final Color? backgroundColor; // The background color of the button, defaults to transparent
  final VoidCallback onPressed; // The callback function when the button is pressed

  const RevokeButtonWidget({
    super.key,
    required this.text,
    required this.radius,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed, // Set the onPressed callback function
      style: ButtonStyle(
        padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
        // backgroundColor: MaterialStateColor.resolveWith((states) => Colors.red),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius.sp), // Set border radius dynamically
          ),
        ),
        side: WidgetStateProperty.all<BorderSide>(
          const BorderSide(
            color: AppColors.redColor, // Set the border color to red
            width: 1.0, // Set the border width to 1.0
          ),
        ),
        backgroundColor: WidgetStateColor.resolveWith((states) => backgroundColor ?? Colors.transparent),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        // Center-align the row content
        crossAxisAlignment: CrossAxisAlignment.center,
        // Center-align vertically
        children: [
          icon,
          // Display the icon
          AppDimensions.small.w.horizontalSpace,
          // Add horizontal space between icon and text
          text.titleBold(
            size: AppDimensions.smallXL, // Set the text size to 12sp
            color: AppColors.redColor, // Set the text color to red
          ),
        ],
      ),
    );
  }
}
