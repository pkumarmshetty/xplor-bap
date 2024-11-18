import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/routes/path_routing.dart';
import '../../../multi_lang/domain/mappers/home/home_keys.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import 'earning_skill_widget.dart';

/// A tab widget displaying seeker-related information.
///
/// The [SeekersTab] widget consists of two sections.
class SeekersTab extends StatelessWidget {
  const SeekersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Adds padding around the container.
      padding: EdgeInsets.all(AppDimensions.medium.sp),
      // Sets the background color, rounded corners, and shadow for the container.
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.smallXL),
          boxShadow: const [
            BoxShadow(
              color: AppColors.searchShadowColor,
              offset: Offset(0, 2),
              blurStyle: BlurStyle.outer,
              blurRadius: 2,
              spreadRadius: 1,
            ),
          ]),
      child: Row(
        children: [
          // The first expanded section showing total seekers.
          Expanded(
              child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, Routes.seekersList),
            child: EarningSkillWidget(
              iconPath: Assets.images.totalSkills,
              title: HomeKeys.totalSeekers.stringToString,
              subtitle: '₹2k',
              isIncrease: true,
              color: AppColors.lightGreen.withOpacity(0.25),
            ),
          )),
          AppDimensions.medium.w.horizontalSpace,
          // The second expanded section showing new seekers.
          Expanded(
              child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, Routes.seekersList),
            child: EarningSkillWidget(
              iconPath: Assets.images.totalScholarships,
              title: HomeKeys.newSeekers.stringToString,
              subtitle: '30',
              isIncrease: false,
              color: AppColors.tabsSelectedColor.withOpacity(0.4),
            ),
          )),
        ],
      ),
    );
  }
}
