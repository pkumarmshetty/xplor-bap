import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../on_boarding/domain/entities/user_data_entity.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../multi_lang/domain/mappers/home/home_keys.dart';

/// A widget for displaying the dashboard header with user greeting and a balance indicator.
///
/// This widget shows a personalized greeting to the user, as well as their current balance.
/// It requires a [UserDataEntity] to display the user's first name.
class DashboardHeaderWidget extends StatelessWidget {
  /// The user data entity that contains user information.
  final UserDataEntity userDataEntity;

  const DashboardHeaderWidget({super.key, required this.userDataEntity});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Adds a small vertical space above the header.
        AppDimensions.extraSmall.verticalSpace,

        // The main row containing the greeting and the balance indicator.
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Column containing the greeting text and welcome message.
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Displays a greeting message using the user's first name.
                    '${HomeKeys.hi.stringToString}, ${userDataEntity.kyc?.firstName}'.titleBold(
                      size: AppDimensions.mediumXL.sp,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w800,
                    ),
                    AppDimensions.extraSmall.w.horizontalSpace,
                    SvgPicture.asset(Assets.images.dashboardWave),
                  ],
                ),
                5.verticalSpace,
                HomeKeys.welcomeToDashboard.stringToString.titleRegular(
                  size: AppDimensions.smallXXL.sp,
                ),
              ],
            ),

            // Container for the balance indicator.
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 6.sp,
                horizontal: AppDimensions.small.sp,
              ),
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
                  10.w.horizontalSpace,
                  // Displays the balance amount in bold text.
                  '₹ 0'.titleSemiBold(
                    size: AppDimensions.smallXXL.sp,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
