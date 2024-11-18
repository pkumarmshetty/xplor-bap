part of 'verify_otp_view.dart';

SliverAppBar verifyOtpSliverAppBar(BuildContext context) {
  return SliverAppBar(
    surfaceTintColor: AppColors.white,
    leading: GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        height: 38.w,
        width: 38.w,
        decoration: BoxDecoration(
          color: AppColors.blueWith10Opacity,
          // Set your desired background color
          borderRadius: BorderRadius.circular(9.0), // Set your desired border radius
        ),
        child:
            SvgPicture.asset(height: 9.w, width: 9.w, Assets.images.icBack).paddingAll(padding: AppDimensions.smallXL),
      ).singleSidePadding(left: AppDimensions.medium, top: AppDimensions.medium),
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
    pinned: true,
    floating: false,
    snap: false,
    // Other SliverAppBar properties as needed
  );
}

SliverPadding verifyOtpSliverPadding(
    BuildContext context, OtpState state, Widget resendOtpWidget, TextEditingController textEditingController) {
  return SliverPadding(
    padding: const EdgeInsets.symmetric(
      horizontal: AppDimensions.medium,
      vertical: kFloatingActionButtonMargin,
    ),
    sliver: SliverList(
      delegate: SliverChildListDelegate(
        [
          AppDimensions.mediumXL.verticalSpace,
          Center(
            child: SvgPicture.asset(
              height: 195.w,
              width: 195.w,
              Assets.images.verifyOtpScreenLogo,
            ),
          ),
          AppDimensions.smallXL.verticalSpace,
          Center(
            child: OnBoardingKeys.otpVerification.stringToString
                .titleExtraBold(size: 32.sp, color: AppColors.countryCodeColor),
          ),
          AppDimensions.extraSmall.verticalSpace,
          Center(
            child:
                '${OnBoardingKeys.enterSixDigitOtpThatWeHaveSentTo.stringToString} ${context.read<OtpBloc>().phoneNumber}'
                    .titleRegular(size: 14.sp, color: AppColors.grey64697a, align: TextAlign.center),
          ),
          AppDimensions.extraSmall.verticalSpace,
          GestureDetector(
            onTap: () {
              Navigator.pop(context); // Call method to show dialog
            },
            child: Center(
              child: OnBoardingKeys.wrongNumber.stringToString
                  .titleSemiBold(color: AppColors.primaryColor, size: 13.sp, align: TextAlign.center),
            ),
          ).symmetricPadding(horizontal: AppDimensions.medium),
          AppDimensions.mediumXL.verticalSpace,
          pinWidget(state, context, resendOtpWidget, textEditingController)
        ],
      ),
    ),
  );
}

SliverFillRemaining verifyOtpSliverFillRemaining(
    BuildContext context, OtpState state, TextEditingController textEditingController) {
  return SliverFillRemaining(
      hasScrollBody: false,
      child: Column(
        children: [
          const Spacer(),
          CircularButton(
            isValid: state is OtpValidState,
            title: OnBoardingKeys.verify.stringToString,
            onPressed: () {
              context.read<OtpBloc>().add(PhoneOtpVerifyEvent(otp: textEditingController.text));
            },
          ).symmetricPadding(
            horizontal: AppDimensions.medium,
            vertical: AppDimensions.large.w,
          ),
        ],
      ));
}
