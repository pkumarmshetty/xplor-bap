import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xplor/config/routes/path_routing.dart';
import 'package:xplor/features/multi_lang/domain/mappers/wallet/wallet_keys.dart';
import 'package:xplor/utils/app_utils/app_utils.dart';
import 'package:xplor/utils/common_top_header.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';
import 'package:xplor/utils/widgets/outlined_button.dart';

import '../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../core/dependency_injection.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/utils.dart';

class WalletNoDocumentView extends StatefulWidget {
  final String? title;

  final bool isSearchEnabled;

  const WalletNoDocumentView({super.key, this.title, this.isSearchEnabled = false});

  @override
  State<WalletNoDocumentView> createState() => _WalletNoDocumentViewState();
}

class _WalletNoDocumentViewState extends State<WalletNoDocumentView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!widget.isSearchEnabled)
          CommonTopHeader(
            title: WalletKeys.wallet.stringToString,
            isTitleOnly: true,
            onBackButtonPressed: () {},
            dividerColor: AppColors.checkBoxDisableColor,
          ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(Assets.images.noDocumentsAdded),
              AppDimensions.mediumXL.vSpace(),
              (widget.title ?? WalletKeys.noDocumentAdded.stringToString).titleExtraBold(
                color: AppColors.black,
                size: AppDimensions.mediumXL.sp,
              ),
              AppDimensions.small.vSpace(),
              if (!widget.isSearchEnabled)
                WalletKeys.thereIsNoDocumentAddedYet.stringToString.titleRegular(size: 14.sp, color: AppColors.black),
              if (!widget.isSearchEnabled)
                WalletKeys.pleaseAddDocument.stringToString.titleRegular(size: 14.sp, color: AppColors.black),
              (!widget.isSearchEnabled) ? AppDimensions.smallXL.vSpace() : AppDimensions.mediumXXL.vSpace(),
              if (!widget.isSearchEnabled)
                OutLinedButton(
                    buttonWidth: 190.w,
                    onTap: () {
                      if (sl<SharedPreferencesHelper>().getString(PrefConstKeys.walletId).isNotEmpty) {
                        Navigator.pushNamed(context, Routes.addDoument);
                      } else {
                        AppUtils.showSnackBar(context, WalletKeys.walletIdEmptyError.stringToString);
                      }
                    },
                    title: WalletKeys.addDocument.stringToString),
            ],
          ),
        ),
      ],
    );
  }
}
