import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xplor/features/multi_lang/domain/mappers/wallet/wallet_keys.dart';
import 'package:xplor/utils/app_colors.dart';
import 'package:xplor/utils/common_top_header.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';

import '../../../../config/routes/path_routing.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/utils.dart';
import '../../../../utils/widgets/build_button.dart';
import '../blocs/wallet_bloc/wallet_bloc.dart';
import '../widgets/my_consents_widgets/my_consent_widget.dart';
import '../widgets/my_document_widget/my_document_widget.dart';
import '../widgets/my_document_widget/tab_widget.dart';

class WalletDocumentView extends StatefulWidget {
  const WalletDocumentView({super.key});

  @override
  State<WalletDocumentView> createState() => _WalletDocumentViewState();
}

class _WalletDocumentViewState extends State<WalletDocumentView> {
  @override
  Widget build(BuildContext context) {
    var state = context.watch<WalletDataBloc>().state;

    return Stack(children: [
      Column(
        children: [
          CommonTopHeader(
            title: WalletKeys.wallet.stringToString,
            onBackButtonPressed: () {},
            isTitleOnly: true,
            dividerColor: AppColors.hintColor,
          ),
          Column(
            children: [
              AppDimensions.mediumXL.vSpace(),
              TabWidget(
                index: state.tabIndex,
              ),
            ],
          ).symmetricPadding(horizontal: AppDimensions.mediumXL.w),
          AppDimensions.medium.sp.vSpace(),
          Expanded(
            child: tabWidget(state.tabIndex).symmetricPadding(horizontal: AppDimensions.mediumXL.w),
          )
        ],
      ),
      (state.tabIndex == 0)
          ? Positioned(
              right: 0,
              bottom: 17.75,
              child: ButtonWidget(
                width: 58.w,
                padding: EdgeInsets.symmetric(horizontal: AppDimensions.smallXL.w, vertical: AppDimensions.smallXL.w),
                customText: SvgPicture.asset(Assets.images.add),
                isValid: true,
                onPressed: () => Navigator.pushNamed(context, Routes.addDoument),
              ).symmetricPadding(horizontal: AppDimensions.mediumXL.w))
          : Container(),
    ]);
  }

  Widget tabWidget(int index) {
    switch (index) {
      case 0:
        return const MyDocumentWidget();
      case 1:
        return const MyConsentWidget();
      default:
        return Container();
    }
  }
}
