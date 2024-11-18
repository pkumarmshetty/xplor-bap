import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../multi_lang/domain/mappers/wallet/wallet_keys.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/common_top_header.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../config/routes/path_routing.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/utils.dart';
import '../../../../utils/widgets/build_button.dart';
import '../blocs/wallet_bloc/wallet_bloc.dart';
import '../widgets/my_consents_widgets/my_consent_widget.dart';
import '../widgets/my_document_widget/my_document_widget.dart';
import '../widgets/my_document_widget/tab_widget.dart';

/// Widget representing the view of the wallet documents.
class WalletDocumentView extends StatefulWidget {
  const WalletDocumentView({super.key});

  @override
  State<WalletDocumentView> createState() => _WalletDocumentViewState();
}

class _WalletDocumentViewState extends State<WalletDocumentView> {
  @override
  Widget build(BuildContext context) {
    var state = context.watch<WalletDataBloc>().state;

    return Stack(
      children: [
        Column(
          children: [
            // Common top header with wallet title
            CommonTopHeader(
              title: WalletKeys.wallet.stringToString,
              onBackButtonPressed: () {}, // Placeholder for back button action
              isTitleOnly: true,
              dividerColor: AppColors.hintColor,
            ),
            Column(
              children: [
                AppDimensions.mediumXL.verticalSpace, // Vertical space
                // Tab widget to switch between document and consent tabs
                TabWidget(index: state.tabIndex),
              ],
            ).symmetricPadding(horizontal: AppDimensions.mediumXL.w),
            // Horizontal padding
            AppDimensions.medium.verticalSpace,
            // Vertical space
            Expanded(
              child: tabWidget(state.tabIndex) // Widget based on selected tab index
                  .symmetricPadding(horizontal: AppDimensions.mediumXL.w), // Horizontal padding
            )
          ],
        ),
        // Add button displayed only on the "My Documents" tab
        (state.tabIndex == 0)
            ? Positioned(
                right: 0,
                bottom: 17.75,
                child: ButtonWidget(
                  width: 58.w,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.smallXL.w,
                    vertical: AppDimensions.smallXL.w,
                  ),
                  customText: SvgPicture.asset(Assets.images.add),
                  isValid: true,
                  // Example boolean to enable/disable button
                  onPressed: () => Navigator.pushNamed(context, Routes.addDoument), // Navigate to add document screen
                ).symmetricPadding(horizontal: AppDimensions.mediumXL.w)) // Horizontal padding
            : Container(),
        // Placeholder container when not on "My Documents" tab
      ],
    );
  }

  /// Returns the widget corresponding to the selected tab index.
  Widget tabWidget(int index) {
    switch (index) {
      case 0:
        return const MyDocumentWidget(); // Widget for "My Documents" tab
      case 1:
        return const MyConsentWidget(); // Widget for "My Consents" tab
      default:
        return Container(); // Default empty container
    }
  }
}
