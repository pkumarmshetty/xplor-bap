part of 'app_utils.dart';

mixin AppUtilsDialogMixin {
  static void showAlertDialog(BuildContext context, bool isTokenClear) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return blurWidget(Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.medium),
              ),
              backgroundColor: AppColors.white,
              elevation: 0,
              insetPadding: const EdgeInsets.symmetric(horizontal: AppDimensions.medium),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Vertical space above the title
                  TopHeaderForDialogs(title: OnBoardingKeys.exitString.stringToString, isCrossIconVisible: false),
                  OnBoardingKeys.exitMessage.stringToString
                      .titleRegular(size: 14.sp, color: AppColors.grey64697a)
                      .symmetricPadding(horizontal: AppDimensions.mediumXL),
                  AppDimensions.small.vSpace(),
                  Row(
                    children: [
                      Expanded(
                        child: ButtonWidget(
                          isFilled: false,
                          radius: AppDimensions.small,
                          buttonBackgroundColor: AppColors.white,
                          buttonForegroundColor: AppColors.white,
                          customText:
                              OnBoardingKeys.cancel.stringToString.titleBold(size: 14, color: AppColors.primaryColor),
                          isValid: true,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      AppDimensions.small.hSpace(),
                      Expanded(
                        child: ButtonWidget(
                          radius: AppDimensions.small,
                          fontSize: 8.0,
                          customText:
                              OnBoardingKeys.exitString.stringToString.titleBold(size: 14, color: AppColors.white),
                          isValid: true,
                          onPressed: () {
                            if (isTokenClear) {
                              sl<SharedPreferencesHelper>().setString(PrefConstKeys.accessToken, "");
                            }
                            if (Platform.isAndroid) {
                              SystemNavigator.pop();
                            } else if (Platform.isIOS) {
                              exit(0);
                            }
                          },
                        ),
                      )
                    ],
                  ).symmetricPadding(horizontal: AppDimensions.mediumXL),
                  AppDimensions.small.vSpace(),
                ],
              )));
        });
  }

  static void showAlertDialogForConfirmation(BuildContext context, String title, String message,
      String leftButtonMessage, String rightButtonMessage, bool isCrossIconVisible, VoidCallback onConfirm) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.medium),
            ),
            backgroundColor: AppColors.white,
            elevation: 0,
            insetPadding: const EdgeInsets.symmetric(horizontal: AppDimensions.medium),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TopHeaderForDialogs(title: title, isCrossIconVisible: isCrossIconVisible),

                /// Message with custom styling
                message.titleSemiBold(size: 16.sp).symmetricPadding(horizontal: AppDimensions.mediumXL),

                /// Vertical space below the message
                AppDimensions.large.vSpace(),

                /// OK button
                ///
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.cancelButtonBgColor,
                          // Text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0), // Rounded edges
                          ),
                          elevation: 5, // Shadow
                        ),
                        child: leftButtonMessage
                            .titleMedium(color: AppColors.cancelStyle, size: 12.sp)
                            .paddingAll(padding: AppDimensions.smallXL.w),
                      ),
                    ),
                    AppDimensions.mediumXL.hSpace(),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => onConfirm(),
                        style: ElevatedButton.styleFrom(
                          surfaceTintColor: AppColors.errorColor,
                          backgroundColor: AppColors.errorColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0), // Rounded edges
                          ),
                          elevation: 5, // Shadow
                        ),
                        child: rightButtonMessage
                            .titleMedium(color: AppColors.white, size: 12.sp)
                            .paddingAll(padding: AppDimensions.smallXL.w),
                      ),
                    ),
                  ],
                ).symmetricPadding(horizontal: AppDimensions.mediumXL),

                /// Vertical space below the OK button
                AppDimensions.xxl.vSpace(),
              ],
            ),
          );
        });
  }

  static void linkGeneratedDialog(
      BuildContext context, String title, String message, String buttonText, VoidCallback onConfirm) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.medium),
            ),
            backgroundColor: AppColors.white,
            elevation: 0,
            insetPadding: const EdgeInsets.symmetric(horizontal: AppDimensions.medium),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TopHeaderForDialogs(title: title, isCrossIconVisible: false),

                /// Message with custom styling
                message
                    .titleSemiBold(size: 14.sp, maxLine: 6, color: AppColors.grey64697a)
                    .symmetricPadding(horizontal: AppDimensions.mediumXL),

                /// Vertical space below the message
                AppDimensions.large.vSpace(),

                /// OK button
                CircularButton(onPressed: () => onConfirm(), isValid: true, title: buttonText)
                    .symmetricPadding(horizontal: AppDimensions.mediumXL),

                /// Vertical space below the OK button
                AppDimensions.xxl.vSpace(),
              ],
            ),
          );
        });
  }

  static void askForMPINDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return EnterMPinDialog(
            title: GenerateMpinKeys.enterMPin.stringToString,
            isCrossIconVisible: true,
          );
        });
  }
}
