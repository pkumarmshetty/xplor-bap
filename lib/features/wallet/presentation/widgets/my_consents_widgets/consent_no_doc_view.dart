import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/extensions/space.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_dimensions.dart';
import '../../../../multi_lang/domain/mappers/wallet/wallet_keys.dart';

class ConsentNoDocVcView extends StatelessWidget {
  const ConsentNoDocVcView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(Assets.images.myConsent),
        AppDimensions.mediumXL.vSpace(),
        WalletKeys.noConsentSharedYet.stringToString
            .titleExtraBold(color: AppColors.black, size: AppDimensions.mediumXL.sp, align: TextAlign.center),
        AppDimensions.small.vSpace(),
        WalletKeys.thereAreCurrentlyNoConsent.stringToString
            .titleRegular(size: 14.sp, color: AppColors.black, align: TextAlign.center),
        AppDimensions.smallXL.vSpace(),
      ],
    );
  }
}
