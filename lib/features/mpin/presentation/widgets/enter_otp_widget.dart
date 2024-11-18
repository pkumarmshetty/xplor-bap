import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../blocs/reset_mpin_bloc.dart';
import 'resend_otp_widget.dart';
import 'reset_mpin_widget.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/extensions/padding.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../core/dependency_injection.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/common_top_header.dart';
import '../../../../utils/widgets/build_button.dart';
import '../../../multi_lang/domain/mappers/mpin/generate_mpin_keys.dart';
import '../../../on_boarding/presentation/widgets/common_pin_code_text_field_view.dart';

class EnterOtpForResetMpinWidget extends StatefulWidget {
  const EnterOtpForResetMpinWidget({super.key});

  @override
  State<EnterOtpForResetMpinWidget> createState() => _EnterOtpForResetMpinWidgetState();
}

class _EnterOtpForResetMpinWidgetState extends State<EnterOtpForResetMpinWidget> {
  final TextEditingController otpController = TextEditingController();

  String userNumber = sl<SharedPreferencesHelper>().getString(PrefConstKeys.phoneNumber);

  @override
  void initState() {
    startResendTimer();
    super.initState();
  }

  int resendOtpInSeconds = 30;
  Timer? _timer;

  void startResendTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendOtpInSeconds > 0) {
        setState(() {
          --resendOtpInSeconds;
        });
      } else {
        resendOtpInSeconds = 30;
        _timer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResetMpinBloc, ResetMpinState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonTopHeader(
                title: GenerateMpinKeys.resetMPin.stringToString,
                onBackButtonPressed: () {
                  Navigator.of(context).pop();
                }),
            AppDimensions.mediumXL.verticalSpace,
            '${GenerateMpinKeys.enterSixDigitsOtp.stringToString} $userNumber'
                .titleRegular(size: 14.sp, color: AppColors.countryCodeColor)
                .symmetricPadding(
                  horizontal: AppDimensions.medium,
                ),
            AppDimensions.medium.verticalSpace,
            GenerateMpinKeys.enterOtp.stringToString.titleBold(size: 14.sp).symmetricPadding(
                  horizontal: AppDimensions.medium,
                ),
            AppDimensions.extraSmall.verticalSpace,
            CommonPinCodeTextField(
              pinBorderColor: (state is ResetMpinUpdatedState && state.otpState == OtpState.success)
                  ? AppColors.greenBorder0dc11f
                  : AppColors.primaryColor,
              pinFilledColor: (state is ResetMpinUpdatedState && state.otpState == OtpState.success)
                  ? AppColors.greenBorder0dc11f.withOpacity(0.05)
                  : AppColors.primaryColor.withOpacity(0.05),
              hidePin: false,
              isReadOnly: (state is ResetMpinUpdatedState &&
                      (state.otpState == OtpState.success ||
                          state.otpErrorMessage.contains(GenerateMpinKeys.exceeded.stringToString)))
                  ? true
                  : false,
              textEditingController: otpController,
              onChanged: (value) => context.read<ResetMpinBloc>().add(MpinOtpChangedEvent(otp: otpController.text)),
            ).symmetricPadding(
              horizontal: AppDimensions.medium,
            ),
            (state is ResetMpinUpdatedState && (state.otpState == OtpState.failure))
                ? Column(
                    children: [
                      state.otpErrorMessage.toString().titleSemiBold(
                          size: 12.sp, color: AppColors.errorColor, maxLine: 3, overflow: TextOverflow.visible),
                      AppDimensions.smallXL.verticalSpace,
                    ],
                  ).symmetricPadding(
                    horizontal: AppDimensions.medium,
                  )
                : Container(),
            AppDimensions.small.verticalSpace,
            (state is ResetMpinUpdatedState && state.otpState != OtpState.success)
                ? Center(
                    child: ResendOtpWidget(
                    otpController: otpController,
                    startResendTimer: startResendTimer,
                    resendOtpInSeconds: resendOtpInSeconds,
                  )).symmetricPadding(
                    horizontal: AppDimensions.medium,
                  )
                : Container(),
            AppDimensions.small.verticalSpace,
            (state is ResetMpinUpdatedState && state.otpState == OtpState.success)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        Assets.images.icVerifiedGreen,
                        width: 15.w,
                        height: 15.w,
                      ),
                      AppDimensions.smallXL.w.horizontalSpace,
                      GenerateMpinKeys.verified.stringToString
                          .titleBold(size: 12.sp, color: AppColors.greenBorder0dc11f)
                    ],
                  ).symmetricPadding(
                    horizontal: AppDimensions.medium,
                  )
                : ButtonWidget(
                    customText:
                        GenerateMpinKeys.verifyOtp.stringToString.titleBold(size: 14.sp, color: AppColors.white),
                    onPressed: () {
                      context.read<ResetMpinBloc>().add(VerifyOtpEvent(otp: otpController.text));
                    },
                    isValid: (state is ResetMpinUpdatedState && state.otpState == OtpState.completed) ? true : false,
                  ).symmetricPadding(
                    horizontal: AppDimensions.medium,
                  ),
            AppDimensions.large.verticalSpace,
            state is ResetMpinUpdatedState && state.otpState == OtpState.success
                ? const ResetMpinWidget().symmetricPadding(
                    horizontal: AppDimensions.medium,
                  )
                : Container()
          ],
        );
      },
    );
  }
}
