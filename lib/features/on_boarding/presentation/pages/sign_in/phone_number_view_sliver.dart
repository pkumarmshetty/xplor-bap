part of 'phone_number_view.dart';

SliverAppBar phoneNumberSliverAppBar(BuildContext context) {
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

SliverPadding phoneNumberSliverPadding(PhoneState state, BuildContext context) {
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
              Assets.images.phoneNumberScreenLogo,
            ),
          ),
          AppDimensions.smallXL.verticalSpace,
          Center(
            child: OnBoardingKeys.welcome.stringToString.titleExtraBold(size: 32.sp, color: AppColors.countryCodeColor),
          ),
          AppDimensions.extraSmall.verticalSpace,
          Center(
            child:
                OnBoardingKeys.beginYourJourney.stringToString.titleRegular(size: 14.sp, color: AppColors.grey64697a),
          ),
          AppDimensions.xxl.verticalSpace,
          AppDimensions.xxl.verticalSpace,
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.smallXL), // Border radius
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
                OnBoardingKeys.mobileNumber.stringToString.titleSemiBold(color: AppColors.blue050505, size: 16.sp),
                AppDimensions.smallXL.verticalSpace,
                _buildPhoneNumberForm(context),
                AppDimensions.smallXL.verticalSpace,
                if (state is FailurePhoneState)
                  Column(
                    children: [
                      state.message.toString().titleSemiBold(size: 12.sp, color: AppColors.errorColor),
                      AppDimensions.smallXL.verticalSpace,
                    ],
                  ),
                _buildSuggestionTitle(),
                AppDimensions.smallXL.verticalSpace,
              ],
            ).symmetricPadding(horizontal: AppDimensions.medium),
          )
        ],
      ),
    ),
  );
}

SliverFillRemaining phoneNumberSliverFillRemaining(PhoneState state, BuildContext context, bool userCheck) {
  return SliverFillRemaining(
      hasScrollBody: false,
      child: Column(
        children: [
          const Spacer(),
          CircularButton(
            isValid: state is PhoneValidState || state is SuccessPhoneState,
            title: OnBoardingKeys.sendOtp.stringToString,
            onPressed: () {
              AppUtils.closeKeyword;
              context.read<PhoneBloc>().add(
                    PhoneSubmitEvent(phone: mobileNumberController.text.replaceAll(" ", ""), userCheck: userCheck),
                  );
            },
          ).symmetricPadding(horizontal: AppDimensions.medium, vertical: AppDimensions.large),
        ],
      ));
}
