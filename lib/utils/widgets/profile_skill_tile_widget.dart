import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../extensions/font_style/font_styles.dart';
import '../extensions/space.dart';

import '../app_colors.dart';
import '../app_dimensions.dart';

class ProfileSkillTileWidget extends StatelessWidget {
  const ProfileSkillTileWidget({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.backgroundColor,
  });

  final String title;
  final String value;
  final String icon;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.smallXL.sp),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimensions.medium),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(icon),
          10.hSpace(),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title.titleBold(size: 13.sp, color: AppColors.grey707484),
              value.titleSemiBold(size: AppDimensions.large.sp),
            ],
          ))
        ],
      ),
    );
  }
}
