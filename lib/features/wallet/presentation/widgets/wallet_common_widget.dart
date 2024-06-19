import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xplor/utils/app_dimensions.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/utils.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';

class UpdateButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const UpdateButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: AppColors.primaryColor, // Button Background color
          foregroundColor: Colors.white, // To set button text color
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(4.0),
            ), // To remove the default radius.
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              Assets.images.updateIcon,
              height: 16.w,
              width: 16.w,
            ),
            // Your icon
            AppDimensions.small.hSpace(),
            text.titleBold(
              size: 12,
              color: AppColors.white,
            )
          ],
        ));
  }
}

class RevokeButtonWidget extends StatelessWidget {
  final String text;
  final SvgPicture icon;
  final int radius;
  final Color? backgroundColor;
  final VoidCallback onPressed;

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
      onPressed: onPressed,
      style: ButtonStyle(
        padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
        // backgroundColor: MaterialStateColor.resolveWith((states) => Colors.red),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(radius.sp), // Set border radius here
          ),
        ),
        side: WidgetStateProperty.all<BorderSide>(
          const BorderSide(
            color: AppColors.redColor, // Set border color here
            width: 1.0, // Set border width here
          ),
        ),
        backgroundColor: WidgetStateColor.resolveWith(
            (states) => backgroundColor ?? Colors.transparent),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon,
          // Your icon
          AppDimensions.small.hSpace(),
          text.titleBold(
            size: 12,
            color: AppColors.redColor,
          )
        ],
      ),
    );
  }
}
