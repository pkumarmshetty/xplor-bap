import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xplor/utils/widgets/loading_animation.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../utils/utils.dart';
import '../../../multi_lang/domain/mappers/seeker_home/seeker_home_keys.dart';

class CoursesPreviewNoDataWidget extends StatelessWidget {
  const CoursesPreviewNoDataWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      elevation: 1,
      shadowColor: AppColors.tabsUnselectedTextColor,
      surfaceTintColor: AppColors.white,
      // Set the elevation as needed
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(AppDimensions.medium),
        ),
      ),
      child: SizedBox(
        width: 200.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(AppDimensions.smallXL), topLeft: Radius.circular(AppDimensions.smallXL)),
              child: CachedNetworkImage(
                  height: 140.w,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                  imageUrl: '',
                  placeholder: (context, url) => const Center(
                        child: LoadingAnimation(),
                      ),
                  errorWidget: (context, url, error) => SvgPicture.asset(
                        Assets.images.productThumnail,
                        fit: BoxFit.fill,
                        width: double.infinity,
                      ).paddingAll(padding: AppDimensions.small)),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(Assets.images.courseTutorIcon),
                    6.hSpace(),
                    'Prashant Singh'.titleMedium(size: AppDimensions.smallXL.sp, color: AppColors.grey9898a5),
                  ],
                ),
                AppDimensions.extraSmall.vSpace(),
                'Beginner’s Guide for UIUX Design'.titleSemiBold(size: AppDimensions.medium.sp, maxLine: 2),
                5.vSpace(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    '₹10,000/-'.titleExtraBold(
                      size: 14.sp,
                      color: AppColors.activeGreen,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SeekerHomeKeys.applyNow.stringToString.titleBold(
                          size: AppDimensions.smallXL.sp,
                          color: AppColors.primaryColor,
                        ),
                        AppDimensions.extraSmall.hSpace(),
                        SvgPicture.asset(Assets.images.rightBlueArrow)
                      ],
                    )
                  ],
                )
              ],
            ).symmetricPadding(horizontal: 12.sp, vertical: 8.sp),
          ],
        ),
      ),
    );
  }
}
