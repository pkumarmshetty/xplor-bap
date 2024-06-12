import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xplor/const/local_storage/shared_preferences_helper.dart';
import 'package:xplor/core/dependency_injection.dart';
import 'package:xplor/features/mpin/presentation/blocs/reset_mpin_bloc.dart';
import 'package:xplor/features/multi_lang/domain/mappers/mpin/generate_mpin_keys.dart';
import 'package:xplor/features/on_boarding/presentation/widgets/common_pin_code_text_field_view.dart';
import 'package:xplor/gen/assets.gen.dart';
import 'package:xplor/utils/app_colors.dart';
import 'package:xplor/utils/app_dimensions.dart';
import 'package:xplor/utils/common_top_header.dart';
import 'package:xplor/utils/extensions/conversion.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/extensions/padding.dart';
import 'package:xplor/utils/extensions/space.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';
import 'package:xplor/utils/widgets/app_background_widget.dart';
import 'package:xplor/utils/widgets/build_button.dart';
import 'package:xplor/utils/widgets/loading_animation.dart';

class ResetMpinScreen extends StatefulWidget {
  const ResetMpinScreen({super.key});

  @override
  State<ResetMpinScreen> createState() => _ResetMpinScreenState();
}

class _ResetMpinScreenState extends State<ResetMpinScreen> {
  @override
  void initState() {
    startResendTimer();
    super.initState();
  }

  final TextEditingController otpController = TextEditingController();

  final TextEditingController originalPinController = TextEditingController();

  final TextEditingController confirmPinController = TextEditingController();
  int resendOtpInSeconds = 30;
  Timer? _timer;
  String userNumber = sl<SharedPreferencesHelper>().getString(PrefConstKeys.phoneNumber);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackgroundDecoration(
        child: SafeArea(
          child: BlocListener<ResetMpinBloc, ResetMpinState>(
            listener: (context, state) {
              if (state is ResetMpinUpdatedState && state.mpinState == MpinState.success) {
                Navigator.pop(context);
                /* AppUtils.showSnackBar(context,
                    GenerateMpinKeys.mPinResetSuccessfully.stringToString,
                    bgColor: AppColors.primaryColor);*/
              }
            },
            child: BlocBuilder<ResetMpinBloc, ResetMpinState>(
              builder: (context, state) {
                return Form(
                  // key: state.formKey,
                  child: Stack(
                    children: [
                      CustomScrollView(
                        slivers: <Widget>[
                          SliverToBoxAdapter(
                            child: _buildMainContent(
                              context,
                              state,
                            ),
                          ),
                        ],
                      ),
                      if (state is ResetMpinUpdatedState && state.isLoading) const LoadingAnimation(),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the main content of the OTP view.
  Widget _buildMainContent(BuildContext context, ResetMpinState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        CommonTopHeader(title: GenerateMpinKeys.resetMPin.stringToString, onBackButtonPressed: (){
          Navigator.of(context).pop();
        }),

        /// Display the welcome content with the title and subtitle.
        /*WelcomeContentWidget(
          title: "",
          subTitle: '${GenerateMpinKeys.enterSixDigitsOtp.stringToString} $userNumber',
        ).symmetricPadding(
          horizontal: AppDimensions.medium,
        ),*/

        AppDimensions.mediumXL.vSpace(),

        '${GenerateMpinKeys.enterSixDigitsOtp.stringToString} $userNumber'.titleRegular(size: 14.sp, color:AppColors.countryCodeColor).symmetricPadding(
          horizontal: AppDimensions.medium,
        ),

        AppDimensions.medium.vSpace(),

        GenerateMpinKeys.enterOtp.stringToString.titleBold(size: 14.sp).symmetricPadding(
          horizontal: AppDimensions.medium,
        ),

        5.verticalSpace,

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
                  AppDimensions.smallXL.vSpace(),
                ],
              ).symmetricPadding(
          horizontal: AppDimensions.medium,
        )
            : Container(),

        AppDimensions.small.vSpace(),

        (state is ResetMpinUpdatedState && state.otpState != OtpState.success)
            ? Center(child: _resendOtp(context)).symmetricPadding(
          horizontal: AppDimensions.medium,
        )
            : Container(),

        AppDimensions.small.vSpace(),

        (state is ResetMpinUpdatedState && state.otpState == OtpState.success)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    Assets.images.icVerifiedGreen,
                    width: 15.w,
                    height: 15.w,
                  ),
                  10.horizontalSpace,
                  GenerateMpinKeys.verified.stringToString.titleBold(size: 12.sp, color: AppColors.greenBorder0dc11f)
                ],
              ).symmetricPadding(
          horizontal: AppDimensions.medium,
        )
            : ButtonWidget(
                customText: GenerateMpinKeys.verifyOtp.stringToString.titleBold(size: 14.sp, color: AppColors.white),
                onPressed: () {
                  context.read<ResetMpinBloc>().add(VerifyOtpEvent(otp: otpController.text));
                },
                isValid: (state is ResetMpinUpdatedState && state.otpState == OtpState.completed) ? true : false,
              ).symmetricPadding(
          horizontal: AppDimensions.medium,
        ),

        AppDimensions.large.vSpace(),

        state is ResetMpinUpdatedState && state.otpState == OtpState.success ? resetMpinWidget().symmetricPadding(
          horizontal: AppDimensions.medium,
        ) : Container()
      ],
    );
  }

  Widget _resendOtp(BuildContext context) {
    return GestureDetector(
      child: resendOtpInSeconds > 0
          ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              '${GenerateMpinKeys.sendCodeAgainIn.stringToString} '.titleBold(
                size: 12.sp,
                color: AppColors.subTitleText,
              ),
              (Conversion.formatSeconds(resendOtpInSeconds)).titleRegular(size: 12.sp, color: AppColors.subTitleText)
            ])
          : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              '${GenerateMpinKeys.iDidntReceiveCode.stringToString} '
                  .titleMedium(size: 12.sp, color: AppColors.subTitleText),
              GenerateMpinKeys.resend.stringToString.titleBold(size: 12.sp, color: AppColors.primaryColor)
            ]),
      onTap: () {
        if (resendOtpInSeconds == 0) {
          otpController.clear();
          context.read<ResetMpinBloc>().add(ResetMpinOtpEvent());
          setState(() {
            resendOtpInSeconds = 30;
          });
          startResendTimer();
        }
      },
    );
  }

  Widget resetMpinWidget() {
    return BlocBuilder<ResetMpinBloc, ResetMpinState>(builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GenerateMpinKeys.enterMPin.stringToString.titleBold(size: 14.sp),
          5.verticalSpace,

          /// Build the OTP digit field.
          CommonPinCodeTextField(
            hidePin: true,
            pinBorderColor: AppColors.primaryColor,
            pinFilledColor: AppColors.primaryColor.withOpacity(0.05),
            textEditingController: originalPinController,
            onChanged: (value) => context.read<ResetMpinBloc>().add(
                ResetMpinChangedEvent(originalPin: originalPinController.text, confirmPin: confirmPinController.text)),
          ),
          5.verticalSpace,

          GenerateMpinKeys.reEnterMPin.stringToString.titleBold(size: 14.sp),
          5.verticalSpace,

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
                    AppDimensions.smallXL.vSpace(),
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

  void startResendTimer() {
    if (_timer != null) {
      _timer?.cancel();
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendOtpInSeconds > 0) {
        setState(() {
          --resendOtpInSeconds;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
