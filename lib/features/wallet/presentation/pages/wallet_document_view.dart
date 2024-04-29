import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/utils.dart';
import '../../../../utils/widgets/build_button.dart';
import '../blocs/wallet_bloc/wallet_bloc.dart';
import '../widgets/add_document_dialog_widget.dart';
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
          AppDimensions.mediumXL.vSpace(),
          TabWidget(
            index: state.tabIndex,
          ),
          AppDimensions.medium.sp.vSpace(),
          Expanded(
            child: tabWidget(state.tabIndex),
          )
        ],
      ),
      (state.tabIndex == 0)
          ? Positioned(
              right: 0,
              bottom: 17.75,
              child: SizedBox(
                height: 48.25.w,
                width: 48.25.w,
                child: ButtonWidget(
                    radius: 12.r,
                    isValid: true,
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return const AddDocumentDialogWidget();
                          });
                    },
                    customText: SvgPicture.asset(Assets.images.add)),
              ))
          : Container(),
    ]).symmetricPadding(horizontal: AppDimensions.mediumXL.w);
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

  void addDocumentDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AddDocumentDialogWidget();
        });
  }
}
