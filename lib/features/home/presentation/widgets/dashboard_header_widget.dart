import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xplor/features/on_boarding/domain/entities/user_data_entity.dart';
import 'package:xplor/utils/app_dimensions.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';
import 'package:xplor/utils/utils.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../multi_lang/domain/mappers/home/home_keys.dart';

class DashboardHeaderWidget extends StatelessWidget {
  const DashboardHeaderWidget({super.key, required this.userDataEntity});

  final UserDataEntity userDataEntity;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppDimensions.extraSmall.vSpace(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  '${HomeKeys.hi.stringToString}, ${userDataEntity.kyc?.firstName}'.titleBold(
                    size: AppDimensions.mediumXL.sp,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w800,
                  ),
                  AppDimensions.extraSmall.hSpace(),
                  SvgPicture.asset(Assets.images.dashboardWave),
                ],
              ),
              5.vSpace(),
              HomeKeys.welcomeToDashboard.stringToString.titleRegular(
                size: AppDimensions.smallXXL.sp,
              ),
            ]),
            Container(
              padding: EdgeInsets.symmetric(vertical: 6.sp, horizontal: AppDimensions.small.sp),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.checkBoxDisableColor, // Border color
                  width: 1, // Border width
                ),
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(AppDimensions.mediumXL),
                  right: Radius.circular(AppDimensions.mediumXL),
                ),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(Assets.images.coins),
                  10.hSpace(),
                  '₹ 0'.titleSemiBold(
                    size: AppDimensions.smallXXL.sp,
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
