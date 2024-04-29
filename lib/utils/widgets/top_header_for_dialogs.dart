import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app_colors.dart';
import '../app_dimensions.dart';
import '../extensions/font_style/font_styles.dart';
import '../extensions/padding.dart';
import '../extensions/space.dart';

class TopHeaderForDialogs extends StatelessWidget {
  final String title;
  final bool isCrossIconVisible;

  const TopHeaderForDialogs({super.key, required this.title, required this.isCrossIconVisible});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        /// Vertical space above the title
        AppDimensions.smallXL.vSpace(),

        /// Title with custom styling
        isCrossIconVisible
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  title.titleExtraBold(size: 20.sp).symmetricPadding(horizontal: AppDimensions.mediumXL),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.crossIconColor),
                    // Set custom close icon
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              )
            : title.titleExtraBold(size: 20.sp).symmetricPadding(horizontal: AppDimensions.mediumXL),

        /// Divider below the title
        Divider(
          color: AppColors.cancelButtonBgColor,
          thickness: 0.5.w,
        ),

        /// Vertical space below the divider
        AppDimensions.mediumXL.vSpace(),
      ],
    );
  }
}
