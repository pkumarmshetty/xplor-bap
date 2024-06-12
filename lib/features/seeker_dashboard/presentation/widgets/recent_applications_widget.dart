import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xplor/features/multi_lang/domain/mappers/seeker_dashboard/seeker_dashboard_keys.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';
import 'package:xplor/utils/utils.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';

class RecentApplicationsWidget extends StatefulWidget {
  const RecentApplicationsWidget({super.key});

  @override
  State<RecentApplicationsWidget> createState() => _RecentApplicationsWidgetState();
}

class _RecentApplicationsWidgetState extends State<RecentApplicationsWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
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
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(AppDimensions.medium)),
              child: Image.asset(Assets.images.recentApplicationDummy.path),
            )),
        Positioned(
            top: 10,
            left: 9,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
              decoration: const BoxDecoration(
                color: AppColors.activeGreen,
                borderRadius: BorderRadius.all(Radius.circular(AppDimensions.medium)),
              ),
              child: "₹10,000/-".titleExtraBold(size: AppDimensions.smallXL.sp, color: AppColors.white),
            )),
        Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 5.sp),
              decoration: BoxDecoration(
                color: AppColors.green717171.withOpacity(0.27),
                borderRadius: BorderRadius.all(Radius.circular(40.sp)),
              ),
              child: SeekerDashboardKeys.inProgress.stringToString.titleBold(size: 10.sp, color: AppColors.white),
            )),
        Positioned(
            left: 9,
            bottom: 11,
            child: Row(
              children: [
                "Agriculture Guide..".titleExtraBold(size: AppDimensions.smallXXL.sp, color: AppColors.white),
                10.hSpace(),
                SeekerDashboardKeys.details.stringToString.titleExtraBold(size: 10.sp, color: AppColors.white),
                SvgPicture.asset(Assets.images.whiteRightArrow)
              ],
            ))
      ],
    );
  }
}
