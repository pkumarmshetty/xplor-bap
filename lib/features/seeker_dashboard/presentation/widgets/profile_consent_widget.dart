import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/extensions/padding.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';

/// A widget that displays a consent card in a profile context.
///
/// The [ProfileConsentWidget] is designed to show a consent or agreement section
/// in a user's profile. It includes an icon, title, job position, and date,
/// formatted in a visually appealing manner.
class ProfileConsentWidget extends StatelessWidget {
  const ProfileConsentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.medium),
        boxShadow: const [
          BoxShadow(
            color: AppColors.searchShadowColor,
            // Shadow color for the container
            offset: Offset(0, 1),
            // Offset for the shadow
            blurRadius: 1, // Blur radius for the shadow effect
          ),
        ],
      ),
      child: Card(
        elevation: 0, // No elevation for the card
        surfaceTintColor: AppColors.white, // Tint color for the card's surface
        color: AppColors.white, // Background color of the card
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon image on the left
            Image.asset(
              Assets.images.consent.path,
              height: 48.sp, // Responsive height using screenutil
            ),
            AppDimensions.medium.w.horizontalSpace, // Horizontal space
            // Expanded widget for the text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title text
                  "Micro Agency".titleBold(
                    size: AppDimensions.medium.sp, // Responsive text size
                    color: AppColors.blackMedium, // Text color
                  ),
                  AppDimensions.extraSmall.verticalSpace,
                  // Vertical space
                  // Job position text
                  "Junior Frontend Developer".titleMedium(size: AppDimensions.smallXL.sp),
                  AppDimensions.extraExtraSmall.verticalSpace,
                  // Small vertical space
                  // Date text
                  "24th April, 2024".titleRegular(size: 10.sp),
                ],
              ),
            ),
            // Arrow icon on the right
            SvgPicture.asset(
              Assets.images.rightArrowProfile,
              height: AppDimensions.large.sp, // Responsive icon size
            ),
          ],
        ).symmetricPadding(
          horizontal: AppDimensions.smallXL.sp, // Horizontal padding
          vertical: AppDimensions.smallXL.sp, // Vertical padding
        ),
      ),
    );
  }
}
