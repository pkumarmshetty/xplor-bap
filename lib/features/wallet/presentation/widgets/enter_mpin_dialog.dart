import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/routes/path_routing.dart';
import '../../../../config/services/app_services.dart';
import '../../../mpin/presentation/blocs/reset_mpin_bloc.dart';
import '../blocs/share_doc_vc_bloc/share_doc_vc_bloc.dart';
import '../blocs/wallet_vc_bloc/wallet_vc_bloc.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/app_utils/app_utils.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/extensions/padding.dart';
import '../../../../utils/widgets/build_button.dart';
import '../../../../utils/widgets/top_header_for_dialogs.dart';
import '../../../multi_lang/domain/mappers/wallet/wallet_keys.dart';
import '../../../on_boarding/presentation/widgets/common_pin_code_text_field_view.dart';
import '../blocs/enter_mpin_bloc/enter_mpin_bloc.dart';

/// `EnterMPinDialog` is a custom dialog widget used for entering an MPIN (Mobile Personal Identification Number).
/// It provides a user interface for entering the MPIN, handling validation, and initiating actions based on the entered MPIN.

class EnterMPinDialog extends StatefulWidget {
  final String title; // Title displayed on the dialog header
  final bool isCrossIconVisible; // Determines if a cross (close) icon is shown

  const EnterMPinDialog({
    super.key,
    required this.title,
    required this.isCrossIconVisible,
  });

  @override
  State<EnterMPinDialog> createState() => _EnterMPinDialogState();
}

class _EnterMPinDialogState extends State<EnterMPinDialog> {
  // TextEditingController for the PIN input field
  var textEditingController = TextEditingController();

  @override
  void initState() {
    // Initialize MPIN state by dispatching an event
    context.read<EnterMPinBloc>().add(const MPinInitialEvent());
    super.initState();
  }

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
            // Print a debug message when MPIN is successfully verified
            AppUtils.printLogs('MPIN Verify');
            // Trigger pin verification success event
            context.read<SharedDocVcBloc>().add(const PinVerifiedEvent());
            // Handle sharing the file if the flow type is consent
            if (context.read<WalletVcBloc>().flowType == FlowType.consent) {
              AppUtils.shareFile('');
              Navigator.pop(context); // Close the dialog
            }
          }
        },
        child: BlocBuilder<EnterMPinBloc, EnterMPinState>(
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top header of the dialog
                TopHeaderForDialogs(
                  title: widget.title,
                  isCrossIconVisible: widget.isCrossIconVisible,
                ),
                // PIN code input field
                CommonPinCodeTextField(
                  hidePin: true,
                  pinFilledColor: AppColors.primaryColor.withOpacity(0.05),
                  pinBorderColor: AppColors.primaryColor,
                  textEditingController: textEditingController,
                  onChanged: (value) {
                    // Validate the entered MPIN
                    context.read<EnterMPinBloc>().add(MPinValidatorEvent(mPIn: value));
                  },
                ).symmetricPadding(horizontal: AppDimensions.mediumXL),
                // Display error message if MPIN validation fails
                if (state is FailureMPinState && state.message!.isNotEmpty)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      state.message
                          .toString()
                          .titleSemiBold(
                              size: 12.sp, color: AppColors.errorColor, maxLine: 3, overflow: TextOverflow.visible)
                          .symmetricPadding(horizontal: AppDimensions.mediumXL),
                      AppDimensions.smallXL.verticalSpace,
                    ],
                  ),
                // Forgot MPIN link
                Center(
                  child: InkWell(
                    onTap: () {
                      // Navigate to reset MPIN screen
                      context.read<ResetMpinBloc>().add(ResetMpinOtpEvent());
                      Navigator.pushNamed(AppServices.navState.currentContext!, Routes.resetMpin);
                    },
                    child: '${WalletKeys.forgotMPin.stringToString}?'
                        .titleBold(color: AppColors.primaryColor, size: 12.sp),
                  ),
                ),
                AppDimensions.medium.verticalSpace,
                // Verify and share button
                ButtonWidget(
                  title: state is MPinLoadingState
                      ? WalletKeys.pleaseWait.stringToString
                      : WalletKeys.verifyShare.stringToString,
                  isValid: state is MPinValidState || state is MPinLoadingState,
                  onPressed: () {
                    if (state is MPinLoadingState) {
                      return;
                    }
                    // Dispatch event to verify the entered MPIN
                    context.read<EnterMPinBloc>().add(
                          MPinVerifyEvent(mPin: textEditingController.text),
                        );
                  },
                ).symmetricPadding(horizontal: AppDimensions.mediumXL),
                AppDimensions.large.verticalSpace,
              ],
            );
          },
        ),
      ),
    );
  }
}
