import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../../utils/extensions/string_to_string.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_dimensions.dart';
import '../../../../multi_lang/domain/mappers/wallet/wallet_keys.dart';

/// A widget that displays a message when there are no consents shared.
class ConsentNoDocVcView extends StatelessWidget {
  const ConsentNoDocVcView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Displays an SVG image for visual context.
        SvgPicture.asset(Assets.images.myConsent),

        // Adds vertical space between elements.
        AppDimensions.mediumXL.verticalSpace,

        // Displays a bold message indicating no consents have been shared yet.
        WalletKeys.noConsentSharedYet.stringToString.titleExtraBold(
          color: AppColors.black, // Text color
          size: AppDimensions.mediumXL.sp, // Font size
          align: TextAlign.center, // Text alignment
        ),

        // Adds smaller vertical space.
        AppDimensions.small.verticalSpace,

        // Displays a regular message with more details.
        WalletKeys.thereAreCurrentlyNoConsent.stringToString.titleRegular(
          size: AppDimensions.smallXXL.sp, // Font size
          color: AppColors.black, // Text color
          align: TextAlign.center, // Text alignment
        ),

        // Adds more vertical space at the bottom.
        AppDimensions.smallXL.verticalSpace,
      ],
    );
  }
}
