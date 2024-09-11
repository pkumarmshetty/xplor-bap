import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../multi_lang/domain/mappers/seeker_home/seeker_home_keys.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/extensions/padding.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';

/// A widget that creates a custom app bar for the seeker application.
/// It displays the current location and a notification icon.
class SeekerAppBarWidget extends StatelessWidget {
  /// The address to be displayed in the app bar.
  final String address;

  /// Creates a [SeekerAppBarWidget].
  ///
  /// Requires a [String] [address] to be passed.
  const SeekerAppBarWidget({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppColors.white,
      automaticallyImplyLeading: false,
      actions: [
        // Notification icon on the right side of the app bar.
        SvgPicture.asset(Assets.images.notification).symmetricPadding(horizontal: AppDimensions.medium),
      ],
      leadingWidth: double.infinity,
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppDimensions.small.verticalSpace,
          SeekerHomeKeys.currentLocation.stringToString
              .titleRegular(color: AppColors.tabsUnselectedTextColor, size: 10.sp),
          AppDimensions.extraExtraSmall.verticalSpace,
          if (address.isNotEmpty)
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Displaying the address in bold text style.
                address.titleBold(
                  size: AppDimensions.smallXL.sp,
                  color: AppColors.cityAppBarColor,
                ),
                // Adding horizontal space between the address and the arrow.
                AppDimensions.small.w.horizontalSpace,
                // Down arrow icon next to the address.
                SvgPicture.asset(Assets.images.downArrow),
              ],
            ),
        ],
      ).symmetricPadding(horizontal: AppDimensions.medium),
    );
  }
}
