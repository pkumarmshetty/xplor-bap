import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/extensions/padding.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../multi_lang/domain/mappers/profile/profile_keys.dart';

class AgentTopHeaderWidget extends StatelessWidget {
  const AgentTopHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      ProfileKeys.myProfile.stringToString.titleExtraBold(size: 24.sp),
      Container(
        padding: EdgeInsets.symmetric(vertical: 6.sp, horizontal: AppDimensions.small.sp),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.checkBoxDisableColor,
            // Border color
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
            '₹ 0'.titleSemiBold(
              size: AppDimensions.smallXXL.sp,
            ),
          ],
        ),
      ),
    ]).symmetricPadding(vertical: AppDimensions.mediumXL.sp, horizontal: AppDimensions.medium.sp);
  }
}
