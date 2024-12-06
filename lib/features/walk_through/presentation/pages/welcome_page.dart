import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/extensions/padding.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../utils/extensions/widget_animations.dart';
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
      onPopInvokedWithResult: (val, result) =>
          AppUtils.showAlertDialog(context, false),
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
          ).singleSidePadding(
              top: AppDimensions.xxl, bottom: AppDimensions.small),
        ),
        OnBoardingKeys.discover.stringToString
            .titleBlack(align: TextAlign.center)
            .fadeAnimation()
            .symmetricPadding(horizontal: AppDimensions.xxl),
        AppDimensions.small.verticalSpace,
        OnBoardingKeys.discoverDescription.stringToString
            .titleRegular(
                color: AppColors.grey64697a,
                size: AppDimensions.smallXXL.sp,
                align: TextAlign.center)
            .fadeAnimation()
            .symmetricPadding(horizontal: AppDimensions.large),
        AppDimensions.smallXL.verticalSpace,
        ButtonWidget(
          customText: SizedBox(
            width: double.infinity,
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                Center(
                  child: OnBoardingKeys.getStarted.stringToString
                      .buttonTextBold(
                          size: AppDimensions.smallXXL.sp,
                          color: AppColors.white),
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
          onPressed: () => Navigator.pushNamed(context, Routes.walkThrough),
        ).

        symmetricPadding(horizontal: AppDimensions.medium),
        AppDimensions.small.verticalSpace,
        GestureDetector(
          onTap: () =>
              Navigator.pushNamed(context, Routes.seekerHome, arguments: true),
          child: Center(
            child: OnBoardingKeys.alreadyAccount.stringToString
                .titleSemiBold(
                    color: AppColors.primaryLightColor,
                    size: AppDimensions.smallXXL.sp)
                .fadeInAnimated(),
          ).singleSidePadding(
            left: AppDimensions.medium,
            right: AppDimensions.medium,
            bottom: AppDimensions.medium,
          ),
        ).symmetricPadding(horizontal: AppDimensions.medium),
        AppDimensions.smallXL.verticalSpace,
      ],
    );
  }
}
