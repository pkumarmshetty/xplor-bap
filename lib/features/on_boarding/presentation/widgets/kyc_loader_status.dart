import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../multi_lang/domain/mappers/on_boarding/on_boardings_keys.dart';

class KycLoaderWidget extends StatelessWidget {
  const KycLoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              Assets.images.icKycSuccess,
              height: 137.w,
              width: 148.w,
            ),
            AppDimensions.large.verticalSpace,

            OnBoardingKeys.kycProcessing.stringToString
                .titleMedium(size: 16.sp, color: AppColors.grey64697a, align: TextAlign.center),
            AppDimensions.mediumXXL.verticalSpace,
            // Dialog title
            OnBoardingKeys.pleaseWait.stringToString.titleExtraBold(
              color: AppColors.countryCodeColor,
              size: 20.sp,
            ),
            AppDimensions.small.verticalSpace,
          ],
        ),
      ),
    );
  }
}
