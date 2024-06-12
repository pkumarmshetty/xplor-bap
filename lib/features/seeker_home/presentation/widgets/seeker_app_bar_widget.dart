import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xplor/features/multi_lang/domain/mappers/seeker_home/seeker_home_keys.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/extensions/padding.dart';
import '../../../../utils/extensions/space.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';

class SeekerAppBarWidget extends StatelessWidget {
  //const SeekerAppBarWidget({super.key});

  final String address;

  const SeekerAppBarWidget({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppColors.white,
      automaticallyImplyLeading: false,
      actions: [SvgPicture.asset(Assets.images.notification).symmetricPadding(horizontal: AppDimensions.medium)],
      leadingWidth: double.infinity,
      leading:
          Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
        AppDimensions.small.vSpace(),
        SeekerHomeKeys.currentLocation.stringToString
            .titleRegular(color: AppColors.tabsUnselectedTextColor, size: 10.sp),
        AppDimensions.extraExtraSmall.vSpace(),
        if (address.isNotEmpty)
          Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                address.titleBold(
                  size: AppDimensions.smallXL.sp,
                  color: AppColors.cityAppBarColor,
                ),
                AppDimensions.small.hSpace(),
                SvgPicture.asset(Assets.images.downArrow),
              ])
      ]).symmetricPadding(horizontal: AppDimensions.medium),
    );
  }
}
