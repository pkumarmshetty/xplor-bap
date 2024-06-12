import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xplor/features/multi_lang/domain/mappers/on_boarding/on_boardings_keys.dart';
import 'package:xplor/features/on_boarding/presentation/blocs/otp_bloc/otp_bloc.dart';
import 'package:xplor/features/on_boarding/presentation/widgets/common_pin_code_text_field_view.dart';
import 'package:xplor/utils/app_colors.dart';
import 'package:xplor/utils/extensions/conversion.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/extensions/padding.dart';
import 'package:xplor/utils/extensions/space.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';

import '../../../../../core/check_route.dart';
import '../../../../../utils/app_dimensions.dart';
import '../../../../../utils/widgets/build_button.dart';
import '../../widgets/build_gradient_with_card.dart';
import '../../widgets/build_welcome.dart';

/// This class represents the OTP verification view.
class OtpView extends StatefulWidget {
  const OtpView({super.key});

  @override
  State<OtpView> createState() => _OtpViewState();
}

/// The state class for the OTP view.
class _OtpViewState extends State<OtpView> {
  bool isValid = false;
  final TextEditingController textEditingController = TextEditingController();
  Timer? resendTimer;
  int remainingTime = 30;

  @override
  void initState() {
    super.initState();

    startResendTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<OtpBloc, OtpState>(
        listener: (context, state) {
          if (state is SuccessOtpState) {
            Navigator.pushNamed(
              context,
              checkRouteBasedOnUserJourney(),
            );
          }
        },
        child: BlocBuilder<OtpBloc, OtpState>(
          builder: (context, state) {
            return buildScreenContent(_buildMainContent(context, state), _buildButtonWidget(state), context,
                (state is OtpLoadingState) ? true : false);
          },
        ),
      ),
    );
  }

  /// Builds the main content of the OTP view.
  Widget _buildMainContent(BuildContext context, OtpState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Display the welcome content with the title and subtitle.
        BlocBuilder<OtpBloc, OtpState>(
          builder: (context, state) {
            return Column(children: [
              AppDimensions.medium.vSpace(),
              WelcomeContentWidget(
                title: OnBoardingKeys.otpVerification.stringToString,
                subTitle:
                    '${OnBoardingKeys.enterSixDigitOtpThatWeHaveSentTo.stringToString} ${context.read<OtpBloc>().phoneNumber}',
              )
            ]);
          },
        ),

        AppDimensions.small.vSpace(),

        GestureDetector(
          onTap: () {
            Navigator.pop(context); // Call method to show dialog
          },
          child: '${OnBoardingKeys.wrongNumber.stringToString}?'.titleSemiBold(
            size: 14.sp,
            color: AppColors.primaryColor,
          ),
        ),

        AppDimensions.large.vSpace(),

        /// Build the OTP digit field.
        CommonPinCodeTextField(
          isReadOnly: (state is FailureOtpState &&
                  state.message!.isNotEmpty &&
                  state.message!.contains(OnBoardingKeys.exceeded.stringToString))
              ? true
              : false,
          textEditingController: textEditingController,
          onChanged: (value) => context.read<OtpBloc>().add(PhoneOtpValidatorEvent(otp: value)),
        ),
        if (state is FailureOtpState && state.message!.isNotEmpty)
          Column(
            children: [
              state.message.toString().titleSemiBold(size: 12.sp, color: AppColors.errorColor),
              AppDimensions.smallXL.vSpace(),
            ],
          ),

        /// Display the resend OTP option.
        _resendOtp(context, state),
        AppDimensions.smallXL.vSpace(),
      ],
    ).symmetricPadding(
      horizontal: AppDimensions.medium,
    );
  }

  /// Builds the resend OTP option.
  Widget _resendOtp(BuildContext context, OtpState state) {
    return GestureDetector(
      child: remainingTime > 0
          ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              '${OnBoardingKeys.sendCodeAgainIn.stringToString} '.titleBold(
                size: 12.sp,
                color: AppColors.subTitleText,
              ),
              (Conversion.formatSeconds(remainingTime)).titleRegular(size: 12.sp, color: AppColors.subTitleText)
            ])
          : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              '${OnBoardingKeys.didntReceiveCode.stringToString} '
                  .titleMedium(size: 12.sp, color: AppColors.subTitleText),
              OnBoardingKeys.resend.stringToString.titleSemiBold(size: 12.sp, color: AppColors.primaryColor)
            ]),
      onTap: () {
        if (remainingTime == 0) {
          textEditingController.clear();

          context.read<OtpBloc>().add(const SendOtpEvent());
          setState(() {
            remainingTime = 30;
          });
          startResendTimer();
        }
      },
    );
  }

  @override
  void dispose() {
    resendTimer?.cancel();
    super.dispose();
  }

  /// Starts the timer for OTP resend.
  void startResendTimer() {
    if (resendTimer != null) {
      resendTimer?.cancel();
    }
    resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        resendTimer?.cancel();
      }
    });
  }

  Widget _buildButtonWidget(OtpState state) {
    /// Build the verification button.
    return BlocBuilder<OtpBloc, OtpState>(
      builder: (context, state) {
        return ButtonWidget(
          title: OnBoardingKeys.verify.stringToString,
          isValid: state is OtpValidState,
          onPressed: () {
            context.read<OtpBloc>().add(PhoneOtpVerifyEvent(otp: textEditingController.text));
          },
        );
      },
    );
  }
}
