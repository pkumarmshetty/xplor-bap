import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xplor/gen/assets.gen.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/extensions/padding.dart';
import 'package:xplor/utils/extensions/space.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';
import 'package:xplor/utils/extensions/widget_animations.dart';

import '../../../../config/routes/path_routing.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/app_utils/app_utils.dart';
import '../../../../utils/widgets/app_background_widget.dart';
import '../../../../utils/widgets/build_button.dart';
import '../../../multi_lang/domain/mappers/on_boarding/on_boardings_keys.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool val) {
        AppUtils.showAlertDialog(context, false);
      },
      child: Scaffold(
        body: AppBackgroundDecoration(
            child: SafeArea(
          child: buildViewItems(context),
        )),
      ),
    );
  }

  buildViewItems(
    BuildContext context,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: SvgPicture.asset(
            Assets.images.welcomePage,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover, // Set the width of the SVG
          ).singleSidePadding(top: AppDimensions.xxl, bottom: AppDimensions.small),
        ),
        OnBoardingKeys.discover.stringToString
            .titleBlack(align: TextAlign.center)
            .fadeAnimation()
            .symmetricPadding(horizontal: AppDimensions.xxl),
        AppDimensions.small.vSpace(),
        OnBoardingKeys.discoverDescription.stringToString
            .titleRegular(color: AppColors.grey64697a, size: 14.sp, align: TextAlign.center)
            .fadeAnimation()
            .symmetricPadding(horizontal: AppDimensions.large),
        AppDimensions.smallXL.vSpace(),
        ButtonWidget(
          customText: SizedBox(
            width: double.infinity,
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                Center(
                  child: OnBoardingKeys.getStarted.stringToString.buttonTextBold(size: 14.sp, color: Colors.white),
                ),
                const Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: AppColors.white,
                  size: AppDimensions.medium,
                )
              ],
            ),
          ),
          isValid: true,
          onPressed: () {
            Navigator.pushNamed(context, Routes.walkThrough);
          },
        ).symmetricPadding(
          horizontal: AppDimensions.medium,
        ),
        AppDimensions.small.vSpace(),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, Routes.login, arguments: true);
          },
          child: Center(
            child: OnBoardingKeys.alreadyAccount.stringToString
                .titleSemiBold(color: AppColors.primaryLightColor, size: 14.sp)
                .fadeInAnimated(),
          ).singleSidePadding(
            left: AppDimensions.medium,
            right: AppDimensions.medium,
            bottom: AppDimensions.medium,
          ),
        ).symmetricPadding(
          horizontal: AppDimensions.medium,
        ),
        AppDimensions.smallXL.vSpace(),
      ],
    );
  }
}
