import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../multi_lang/domain/mappers/profile/profile_keys.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../utils/widgets/outlined_button.dart';
import '../../../../config/routes/path_routing.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_dimensions.dart';

/// Widget displayed when the order list is empty.
class OrderListEmptyWidget extends StatelessWidget {
  const OrderListEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Empty orders illustration using SVG image
        SvgPicture.asset(Assets.images.ordersEmpty),
        AppDimensions.mediumXL.verticalSpace, // Vertical spacing
        // Title indicating that the order list is empty
        ProfileKeys.yourOrderListIsEmpty.stringToString.titleExtraBold(size: AppDimensions.mediumXL.sp),
        AppDimensions.small.verticalSpace, // Vertical spacing
        // Description explaining the empty order situation
        ProfileKeys.emptyOrderDesc.stringToString.titleRegular(
          size: 14.sp,
          align: TextAlign.center,
        ),
        AppDimensions.smallXL.verticalSpace, // Vertical spacing
        // Button to navigate to seeker home page
        OutLinedButton(
          buttonWidth: 190.w,
          onTap: () => Navigator.of(context).pushReplacementNamed(Routes.seekerHome),
          title: ProfileKeys.exploreNow.stringToString,
        ),
      ],
    );
  }
}
