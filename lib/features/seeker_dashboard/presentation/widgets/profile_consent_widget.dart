import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/extensions/padding.dart';
import 'package:xplor/utils/extensions/space.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';

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
            color: AppColors.searchShadowColor, // Shadow color
            offset: Offset(0, 1), // Offset
            blurRadius: 1, // Blur radius
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        surfaceTintColor: AppColors.white,
        color: AppColors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Assets.images.consent.path,
              height: 48.sp,
            ),
            AppDimensions.medium.hSpace(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  "Micro Agency".titleBold(
                    size: AppDimensions.medium.sp,
                    color: AppColors.blackMedium,
                  ),
                  AppDimensions.extraSmall.vSpace(),
                  "Junior Frontend Developer".titleMedium(size: AppDimensions.smallXL.sp),
                  AppDimensions.extraExtraSmall.vSpace(),
                  "24th April, 2024".titleRegular(size: 10.sp),
                ],
              ),
            ),
            SvgPicture.asset(
              Assets.images.rightArrowProfile,
              height: AppDimensions.large.sp,
            ),
          ],
        ).symmetricPadding(
          horizontal: AppDimensions.smallXL.sp,
          vertical: AppDimensions.smallXL.sp,
        ),
      ),
    );
  }
}
