import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xplor/features/multi_lang/domain/mappers/profile/profile_keys.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/extensions/space.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';
import 'package:xplor/utils/widgets/outlined_button.dart';

import '../../../../config/routes/path_routing.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_dimensions.dart';

class OrderListEmptyWidget extends StatelessWidget {
  const OrderListEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(Assets.images.ordersEmpty),
        AppDimensions.mediumXL.vSpace(),
        ProfileKeys.yourOrderListIsEmpty.stringToString.titleExtraBold(size: AppDimensions.mediumXL.sp),
        AppDimensions.small.vSpace(),
        ProfileKeys.emptyOrderDesc.stringToString.titleRegular(
          size: 14.sp,
          align: TextAlign.center,
        ),
        AppDimensions.smallXL.vSpace(),
        OutLinedButton(
            buttonWidth: 190.w,
            onTap: () => Navigator.of(context).pushReplacementNamed(Routes.seekerHome),
            title: ProfileKeys.exploreNow.stringToString),
      ],
    );
  }
}
