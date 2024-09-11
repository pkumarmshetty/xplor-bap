part of 'verify_otp_view.dart';

bool isValid = false;
Timer? resendTimer;
int remainingTime = 30;

Widget pinWidget(
    OtpState state, BuildContext context, Widget resendOtpWidget, TextEditingController textEditingController) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDimensions.smallXL),
      // Border radius
      side: BorderSide(
        color: AppColors.greye8e8e8, // Border color
        width: 0.5, // Border width
      ),
    ),
    surfaceTintColor: Colors.white,
    color: Colors.white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppDimensions.smallXL.verticalSpace,
        OnBoardingKeys.enterOtp.stringToString.titleSemiBold(color: AppColors.blue050505, size: 16.sp),
        AppDimensions.mediumXL.verticalSpace,
        CommonPinCodeTextField(
          pinBorderColor: AppColors.primaryColor,
          pinFilledColor: AppColors.primaryColor.withOpacity(0.05),
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
              state.message.toString().titleSemiBold(maxLine: 3, size: 12.sp, color: AppColors.errorColor),
              AppDimensions.smallXL.verticalSpace,
            ],
          ),

        /// Display the resend OTP option.
        resendOtpWidget,
        AppDimensions.smallXL.verticalSpace,
      ],
    ).symmetricPadding(horizontal: AppDimensions.medium),
  );
}

void startNavigation(BuildContext context) {
  if (sl<SharedPreferencesHelper>().getString(PrefConstKeys.loginFrom) == PrefConstKeys.seekerHomeKey) {
    if (Routes.kyc == checkRouteBasedOnUserJourney()) {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushNamed(
        context,
        checkRouteBasedOnUserJourney(),
      );
    } else {
      Navigator.pop(context);
      Navigator.pop(context);
    }
  } else {
    sl<SharedPreferencesHelper>().setBoolean('${PrefConstKeys.focus}Done', true);
    sl<SharedPreferencesHelper>().setBoolean('${PrefConstKeys.role}Done', true);
    sl<SharedPreferencesHelper>().setBoolean('${PrefConstKeys.category}Done', true);
    Navigator.pushNamedAndRemoveUntil(
      context,
      checkRouteBasedOnUserJourney(),
      (route) => false, // Do not allow back navigation
    );
  }

  sl<SharedPreferencesHelper>().setString(PrefConstKeys.phoneNumber, context.read<OtpBloc>().phoneNumber ?? "");
}
