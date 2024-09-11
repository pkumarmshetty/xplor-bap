import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/widgets/build_button.dart';
import '../../../multi_lang/domain/mappers/mpin/generate_mpin_keys.dart';
import '../../../on_boarding/presentation/widgets/common_pin_code_text_field_view.dart';
import '../blocs/reset_mpin_bloc.dart';

class ResetMpinWidget extends StatefulWidget {
  const ResetMpinWidget({super.key});

  @override
  State<ResetMpinWidget> createState() => _ResetMpinWidgetState();
}

class _ResetMpinWidgetState extends State<ResetMpinWidget> {
  late TextEditingController originalPinController;
  late TextEditingController confirmPinController;

  @override
  void initState() {
    originalPinController = TextEditingController();
    confirmPinController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResetMpinBloc, ResetMpinState>(builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GenerateMpinKeys.enterMPin.stringToString.titleBold(size: 14.sp),
          AppDimensions.extraSmall.verticalSpace,

          /// Build the OTP digit field.
          CommonPinCodeTextField(
            hidePin: true,
            // pinBorderColor: AppColors,
            pinFilledColor: AppColors.primaryColor.withOpacity(0.05),
            textEditingController: originalPinController,
            onChanged: (value) => context.read<ResetMpinBloc>().add(
                ResetMpinChangedEvent(originalPin: originalPinController.text, confirmPin: confirmPinController.text)),
          ),
          AppDimensions.extraSmall.verticalSpace,

          GenerateMpinKeys.reEnterMPin.stringToString.titleBold(size: 14.sp),
          AppDimensions.extraSmall.verticalSpace,

          /// Build the OTP digit field.
          CommonPinCodeTextField(
            hidePin: true,
            pinBorderColor: AppColors.primaryColor,
            pinFilledColor: AppColors.primaryColor.withOpacity(0.05),
            textEditingController: confirmPinController,
            onChanged: (value) => context.read<ResetMpinBloc>().add(
                ResetMpinChangedEvent(originalPin: originalPinController.text, confirmPin: confirmPinController.text)),
          ),

          (state is ResetMpinUpdatedState &&
                  (state.mpinState == MpinState.failure || state.mpinState == MpinState.misMatched))
              ? Column(
                  children: [
                    state.mpinErrorMessage.toString().titleSemiBold(
                        size: 12.sp, color: AppColors.errorColor, maxLine: 3, overflow: TextOverflow.visible),
                    AppDimensions.smallXL.verticalSpace,
                  ],
                )
              : Container(),

          ButtonWidget(
            customText: GenerateMpinKeys.verify.stringToString.titleBold(size: 14.sp, color: AppColors.white),
            onPressed: () {
              context
                  .read<ResetMpinBloc>()
                  .add(ResetMpinApiEvent(pin1: originalPinController.text, pin2: confirmPinController.text));
            },
            isValid: (state is ResetMpinUpdatedState && state.mpinState == MpinState.completed) ? true : false,
          )
        ],
      );
    });
  }
}
