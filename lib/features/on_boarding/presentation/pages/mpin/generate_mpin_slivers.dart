part of 'generate_mpin_screen.dart';

SliverToBoxAdapter generateMPinSliverToBoxAdapter(BuildContext context, MpinState state,
    TextEditingController originalPinController, TextEditingController confirmPinController) {
  return SliverToBoxAdapter(
    child: Column(
      children: [
        CommonTopHeader(
            title: GenerateMpinKeys.generateMpin.stringToString,
            backgroundColor: Colors.transparent,
            dividerColor: AppColors.hintColor,
            onBackButtonPressed: () {
              Navigator.of(context).pop();
            }),
        _buildMainContent(context, state, originalPinController, confirmPinController),
      ],
    ),
  );
}

SliverFillRemaining generateMPinSliverFillRemaining(BuildContext context, MpinState state,
    TextEditingController originalPinController, TextEditingController confirmPinController) {
  return SliverFillRemaining(
      hasScrollBody: false,
      child: Column(
        children: [
          const Spacer(),
          CircularButton(
            onPressed: () {
              context.read<MpinBloc>().add(
                  ValidatePinsEvent(originalPin: originalPinController.text, confirmPin: confirmPinController.text));
            },
            isValid: state is PinCompletedState ? true : false,
            title: GenerateMpinKeys.verify.stringToString,
          ).symmetricPadding(horizontal: AppDimensions.medium, vertical: AppDimensions.large.w),
        ],
      ));
}

/// Builds the main content of the OTP view.
Widget _buildMainContent(BuildContext context, MpinState state, TextEditingController originalPinController,
    TextEditingController confirmPinController) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      AppDimensions.smallXXL.verticalSpace,

      /// Display the welcome content with the title and subtitle.
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(Assets.images.generateMpin),
          GenerateMpinKeys.generateMpin.stringToString.titleExtraBold(size: 32.sp),
          AppDimensions.extraSmall.verticalSpace,
          GenerateMpinKeys.generateMpinSecurelyForAccountAccess.stringToString
              .titleRegular(size: 14.sp, color: AppColors.grey64697a, align: TextAlign.center),
        ],
      ),

      AppDimensions.large.verticalSpace,

      Container(
        padding: const EdgeInsets.all(AppDimensions.smallXL),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(
            color: AppColors.searchShadowColor.withOpacity(0.1),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.medium),
          boxShadow: const [
            BoxShadow(
              color: AppColors.searchShadowColor, // Shadow color
              offset: Offset(0, 1), // Offset
              blurRadius: 1, // Blur radius
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GenerateMpinKeys.enterMPin.stringToString.titleBold(size: 14.sp, color: AppColors.grey64697a),
            AppDimensions.extraSmall.verticalSpace,

            /// Build the OTP digit field.
            CommonPinCodeTextField(
              hidePin: true,
              height: 48.sp,
              pinBorderColor: AppColors.primaryColor,
              pinFilledColor: AppColors.primaryColor.withOpacity(0.05),
              obscureIcon: SvgPicture.asset(Assets.images.obscuringIcon),
              textEditingController: originalPinController,
              onChanged: (value) => context
                  .read<MpinBloc>()
                  .add(PinChangedEvent(originalPin: originalPinController.text, confirmPin: confirmPinController.text)),
            ),

            GenerateMpinKeys.reEnter.stringToString.titleBold(size: 14.sp, color: AppColors.grey64697a),
            AppDimensions.extraSmall.verticalSpace,

            /// Build the OTP digit field.
            CommonPinCodeTextField(
              obscureIcon: SvgPicture.asset(Assets.images.obscuringIcon),
              hidePin: true,
              height: 48.sp,
              pinBorderColor: AppColors.primaryColor,
              pinFilledColor: AppColors.primaryColor.withOpacity(0.05),
              textEditingController: confirmPinController,
              onChanged: (value) => context
                  .read<MpinBloc>()
                  .add(PinChangedEvent(originalPin: originalPinController.text, confirmPin: confirmPinController.text)),
            ),
            (state is PinsMisMatchedState)
                ? Column(
                    children: [
                      state.errorMessage.toString().titleSemiBold(
                          size: 12.sp, color: AppColors.errorColor, maxLine: 3, overflow: TextOverflow.visible),
                      AppDimensions.smallXL.verticalSpace,
                    ],
                  )
                : Container(),

            (state is PinFailedState)
                ? Column(
                    children: [
                      state.errorMessage.toString().titleSemiBold(
                          size: 12.sp, color: AppColors.errorColor, maxLine: 3, overflow: TextOverflow.visible),
                      AppDimensions.smallXL.verticalSpace,
                    ],
                  )
                : Container()
          ],
        ),
      ),
      AppDimensions.large.verticalSpace,
    ],
  ).symmetricPadding(
    horizontal: AppDimensions.medium,
  );
}
