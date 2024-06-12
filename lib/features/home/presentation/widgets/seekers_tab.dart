import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xplor/config/routes/path_routing.dart';
import 'package:xplor/features/multi_lang/domain/mappers/home/home_keys.dart';
import 'package:xplor/utils/extensions/space.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import 'earning_skill_widget.dart';

class SeekersTab extends StatelessWidget {
  const SeekersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.medium.sp),
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
          AppDimensions.medium.hSpace(),
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
