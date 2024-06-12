import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xplor/features/multi_lang/domain/mappers/home/home_keys.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';
import 'package:xplor/utils/utils.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';

class EarningSkillWidget extends StatelessWidget {
  const EarningSkillWidget({
    super.key,
    required this.iconPath,
    required this.title,
    required this.subtitle,
    required this.isIncrease,
    required this.color,
  });

  final String iconPath;
  final String title;
  final String subtitle;
  final bool isIncrease;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: AppDimensions.medium.sp, right: AppDimensions.medium.sp, bottom: AppDimensions.medium.sp),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppDimensions.smallXL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: title
                    .titleSemiBold(
                      size: 13.sp,
                    )
                    .singleSidePadding(
                      top: AppDimensions.mediumXL.sp,
                      bottom: AppDimensions.extraSmall.sp,
                    ),
              ),
              AppDimensions.extraSmall.hSpace(),
              Tooltip(
                message: title,
                triggerMode: TooltipTriggerMode.tap,
                child: SvgPicture.asset(
                  Assets.images.info,
                ).singleSidePadding(
                  top: AppDimensions.mediumXL.sp,
                  bottom: AppDimensions.extraSmall.sp,
                ),
              )
            ],
          ),
          subtitle.titleBold(size: 38.sp),
          AppDimensions.small.vSpace(),
          Container(
            padding: const EdgeInsets.all(AppDimensions.extraSmall),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppDimensions.extraSmall),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  !isIncrease ? Assets.images.trendingDown : Assets.images.trendingUp,
                  height: AppDimensions.smallXL.sp,
                  width: AppDimensions.smallXL.sp,
                ),
                AppDimensions.extraSmall.hSpace(),
                '37.8%'.titleBold(size: 12.sp, color: isIncrease ? AppColors.activeGreen : AppColors.redColor),
                Expanded(
                  child: ' ${HomeKeys.thisWeek.stringToString}'
                      .titleBold(size: 12.sp, color: AppColors.greyTextColor, maxLine: 1),
                ),
              ],
            ),
          ),
          AppDimensions.extraSmall.vSpace(),
        ],
      ),
    );
  }
}
