import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xplor/utils/app_colors.dart';
import 'package:xplor/utils/app_dimensions.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/utils.dart';

class CommonProfileTitleValueWidget extends StatelessWidget {
  final String icon;
  final String title;
  final String value;
  final bool isDivider;
  const CommonProfileTitleValueWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.isDivider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          SvgPicture.asset(icon),
          AppDimensions.small.hSpace(),
          title.titleSemiBold(size: 14.sp, color: AppColors.grey9898a5)
        ]),
        AppDimensions.small.vSpace(),
        value.titleSemiBold(size: 14.sp, color: AppColors.black),
        AppDimensions.extraSmall.vSpace(),
        isDivider ? Divider(color: AppColors.greydfe2eb) : const SizedBox(),
      ],
    );
  }
}
