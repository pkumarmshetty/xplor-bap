import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../config/routes/path_routing.dart';
import '../../../multi_lang/domain/mappers/wallet/wallet_keys.dart';
import '../../../../utils/app_utils/app_utils.dart';
import '../../../../utils/common_top_header.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../utils/widgets/outlined_button.dart';
import '../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../core/dependency_injection.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';

/// Widget that displays a view when no documents are added to the wallet.
class WalletNoDocumentView extends StatefulWidget {
  final String? title;
  final bool isSearchEnabled;

  /// Constructor for WalletNoDocumentView.
  /// [title]: Optional title to display instead of default text.
  /// [isSearchEnabled]: Whether search functionality is enabled or not.
  const WalletNoDocumentView({
    super.key,
    this.title,
    this.isSearchEnabled = false,
  });

  @override
  State<WalletNoDocumentView> createState() => _WalletNoDocumentViewState();
}

class _WalletNoDocumentViewState extends State<WalletNoDocumentView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!widget.isSearchEnabled)
          // Common header when search is not enabled
          CommonTopHeader(
            title: WalletKeys.wallet.stringToString,
            isTitleOnly: true,
            onBackButtonPressed: () {}, // Placeholder for back button action
            dividerColor: AppColors.checkBoxDisableColor,
          ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SVG image asset indicating no documents added
              SvgPicture.asset(Assets.images.noDocumentsAdded),
              AppDimensions.mediumXL.verticalSpace, // Vertical space
              // Title or default text indicating no document added
              (widget.title ?? WalletKeys.noDocumentAdded.stringToString).titleExtraBold(
                color: AppColors.black,
                size: AppDimensions.mediumXL.sp,
              ),
              AppDimensions.small.verticalSpace, // Vertical space
              if (!widget.isSearchEnabled)
                // Additional text when search is not enabled
                WalletKeys.thereIsNoDocumentAddedYet.stringToString.titleRegular(
                  size: AppDimensions.smallXXL.sp,
                  color: AppColors.black,
                ),
              if (!widget.isSearchEnabled)
                // Instruction text when search is not enabled
                WalletKeys.pleaseAddDocument.stringToString.titleRegular(
                  size: AppDimensions.smallXXL.sp,
                  color: AppColors.black,
                ),
              (!widget.isSearchEnabled)
                  ? AppDimensions.smallXL.verticalSpace // Space conditionally
                  : AppDimensions.mediumXXL.verticalSpace, // Space conditionally
              if (!widget.isSearchEnabled)
                // Button to add document when search is not enabled
                OutLinedButton(
                  buttonWidth: 190.w,
                  onTap: () {
                    // Navigate to add document screen if wallet ID is not empty
                    if (sl<SharedPreferencesHelper>().getString(PrefConstKeys.walletId).isNotEmpty) {
                      Navigator.pushNamed(context, Routes.addDoument);
                    } else {
                      // Show error message if wallet ID is empty
                      AppUtils.showSnackBar(
                        context,
                        WalletKeys.walletIdEmptyError.stringToString,
                      );
                    }
                  },
                  title: WalletKeys.addDocument.stringToString,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
