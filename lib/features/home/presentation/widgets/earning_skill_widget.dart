import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../multi_lang/domain/mappers/home/home_keys.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../utils/utils.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';

/// A widget that displays earnings and skills in a customized container.
///
/// This widget takes an icon, title, subtitle, and a boolean to indicate
/// if the trend is increasing or decreasing, and displays this information
/// in a styled container with specific colors.
class EarningSkillWidget extends StatelessWidget {
  /// Path to the icon asset.
  final String iconPath;

  /// The title text of the widget.
  final String title;

  /// The subtitle text of the widget.
  final String subtitle;

  /// Boolean indicating if the trend is increasing.
  final bool isIncrease;

  /// The background color of the container.
  final Color color;

  const EarningSkillWidget({
    super.key,
    required this.iconPath,
    required this.title,
    required this.subtitle,
    required this.isIncrease,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Adds padding to the container.
      padding: EdgeInsets.only(
          left: AppDimensions.medium.sp, right: AppDimensions.medium.sp, bottom: AppDimensions.medium.sp),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppDimensions.smallXL),
      ),
      // Arranges the child widgets vertically.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // A row containing the title and a tooltip icon.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Expands the title to take available space.
              Expanded(
                child: title.titleSemiBold(size: 13.sp).singleSidePadding(
                      top: AppDimensions.mediumXL.sp,
                      bottom: AppDimensions.extraSmall.sp,
                    ),
              ),
              // Adds horizontal space between the title and the tooltip.
              AppDimensions.extraSmall.w.horizontalSpace,
              // Tooltip widget displays additional information on tap.
              Tooltip(
                message: title,
                triggerMode: TooltipTriggerMode.tap,
                child: SvgPicture.asset(Assets.images.info).singleSidePadding(
                  top: AppDimensions.mediumXL.sp,
                  bottom: AppDimensions.extraSmall.sp,
                ),
              ),
            ],
          ),
          // Displays the subtitle with bold styling.
          subtitle.titleBold(size: 38.sp),
          // Adds vertical space between the subtitle and the next section.
          AppDimensions.small.verticalSpace,
          // Container for the trend icon and percentage.
          Container(
            padding: const EdgeInsets.all(AppDimensions.extraSmall),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppDimensions.extraSmall),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Trend icon indicating an increase or decrease.
                SvgPicture.asset(
                  !isIncrease ? Assets.images.trendingDown : Assets.images.trendingUp,
                  height: AppDimensions.smallXL.sp,
                  width: AppDimensions.smallXL.sp,
                ),
                // Adds horizontal space between the icon and the percentage.
                AppDimensions.extraSmall.w.horizontalSpace,
                '37.8%'.titleBold(size: 12.sp, color: isIncrease ? AppColors.activeGreen : AppColors.redColor),
                Expanded(
                  child: ' ${HomeKeys.thisWeek.stringToString}'
                      .titleBold(size: 12.sp, color: AppColors.greyTextColor, maxLine: 1),
                ),
              ],
            ),
          ),
          // Adds vertical space at the bottom of the container.
          AppDimensions.extraSmall.verticalSpace,
        ],
      ),
    );
  }
}
