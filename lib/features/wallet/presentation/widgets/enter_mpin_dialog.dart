import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xplor/features/wallet/presentation/blocs/wallet_vc_bloc/wallet_vc_bloc.dart';
import 'package:xplor/features/wallet/presentation/blocs/wallet_vc_bloc/wallet_vc_event.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/app_utils/app_utils.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/extensions/padding.dart';
import '../../../../utils/extensions/space.dart';
import '../../../../utils/widgets/build_button.dart';
import '../../../../utils/widgets/top_header_for_dialogs.dart';
import '../../../on_boarding/presentation/widgets/common_pin_code_text_field_view.dart';
import '../blocs/enter_mpin_bloc/enter_mpin_bloc.dart';

/// Custom dialog for confirmation
class EnterMPinDialog extends StatefulWidget {
  /// Callback function for OK button press
  final VoidCallback onConfirmPressed;
  final String title;
  final bool isCrossIconVisible;

  const EnterMPinDialog({
    super.key,
    required this.onConfirmPressed,
    required this.title,
    required this.isCrossIconVisible,
  });

  @override
  State<EnterMPinDialog> createState() => _EnterMPinDialogState();
}

class _EnterMPinDialogState extends State<EnterMPinDialog> {
  var textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.medium),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: AppDimensions.medium),
        child: BlocListener<EnterMPinBloc, EnterMPinState>(
          listener: (context, state) {
            if (state is SuccessMPinState) {
              if (kDebugMode) {
                print('MPIN Verify');
              }
              AppUtils.shareFile('Sharing HSC Marksheet');
              context.read<WalletVcBloc>().add(const WalletDocumentsUnselectedEvent());
              Navigator.pop(context);
            }
          },
          child: BlocBuilder<EnterMPinBloc, EnterMPinState>(builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TopHeaderForDialogs(title: widget.title, isCrossIconVisible: widget.isCrossIconVisible),
                CommonPinCodeTextField(
                  hidePin: true,
                  textEditingController: textEditingController,
                  onChanged: (value) => context.read<EnterMPinBloc>().add(MPinValidatorEvent(mPIn: value)),
                ).symmetricPadding(horizontal: AppDimensions.mediumXL),
                if (state is FailureMPinState && state.message!.isNotEmpty)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      state.message
                          .toString()
                          .titleSemiBold(size: 12.sp, color: AppColors.errorColor)
                          .symmetricPadding(horizontal: AppDimensions.mediumXL),
                      AppDimensions.smallXL.vSpace(),
                    ],
                  ),
                /*Center(
                  child: 'Forgot PIN?'.titleBold(
                    size: 12.sp,
                    color: AppColors.primaryColor,
                  ),
                ),
                */
                AppDimensions.medium.vSpace(),
                ButtonWidget(
                  title: state is MPinLoadingState ? "Please wait..." : 'Verify & Share',
                  isValid: state is MPinValidState || state is MPinLoadingState,
                  onPressed: () {
                    if (state is MPinLoadingState) {
                      return;
                    }
                    context.read<EnterMPinBloc>().add(MPinVerifyEvent(mPin: textEditingController.text));
                  },
                ).symmetricPadding(horizontal: AppDimensions.mediumXL),
                AppDimensions.large.vSpace(),
              ],
            );
          }),
        ));
  }
}
