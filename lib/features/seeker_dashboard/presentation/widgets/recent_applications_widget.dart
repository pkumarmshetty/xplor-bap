import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../multi_lang/domain/mappers/seeker_dashboard/seeker_dashboard_keys.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';

/// Widget representing a recent application item in the seeker dashboard.
///
/// Displays a card with an image, application details, and status indicators.
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
        // Card containing the application image
        Card(
          color: AppColors.white,
          elevation: 1,
          shadowColor: AppColors.tabsUnselectedTextColor,
          surfaceTintColor: AppColors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(AppDimensions.medium),
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(AppDimensions.medium),
            ),
            child: Image.asset(Assets.images.recentApplicationDummy.path),
          ),
        ),
        // Positioned widget for the top-left badge
        Positioned(
          top: 10.sp,
          left: 9.sp,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.small.sp, vertical: AppDimensions.extraSmall.sp),
            decoration: BoxDecoration(
              color: AppColors.activeGreen,
              borderRadius: BorderRadius.circular(AppDimensions.medium),
            ),
            child: "₹10,000/-".titleExtraBold(
              size: AppDimensions.smallXL.sp,
              color: AppColors.white,
            ),
          ),
        ),
        // Positioned widget for the top-right status indicator
        Positioned(
          top: 10.sp,
          right: 10.sp,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 5.sp),
            decoration: BoxDecoration(
              color: AppColors.green717171.withOpacity(0.27),
              borderRadius: BorderRadius.circular(40.sp),
            ),
            child: SeekerDashboardKeys.inProgress.stringToString.titleBold(size: 10.sp, color: AppColors.white),
          ),
        ),
        // Positioned widget for the bottom-left application details
        Positioned(
          left: 9.sp,
          bottom: 11.sp,
          child: Row(
            children: [
              "Agriculture Guide..".titleExtraBold(
                size: AppDimensions.smallXXL.sp,
                color: AppColors.white,
              ),
              10.w.horizontalSpace,
              SeekerDashboardKeys.details.stringToString.titleExtraBold(
                size: 10.sp,
                color: AppColors.white,
              ),
              SvgPicture.asset(Assets.images.whiteRightArrow),
            ],
          ),
        ),
      ],
    );
  }
}
