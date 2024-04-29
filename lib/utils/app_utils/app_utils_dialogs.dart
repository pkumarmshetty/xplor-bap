part of 'app_utils.dart';

mixin AppUtilsDialogMixin {
  static void showAlertDialog(BuildContext context, bool isTokenClear) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 20),
            contentPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 25),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            titlePadding: const EdgeInsets.only(left: 20, right: 10, bottom: 20, top: 6),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                'Exit'.titleExtraBold(size: 20),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.crossIconColor),
                  // Set custom close icon
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
            content: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: 'Are you sure, you want to exit?\nAll progress will be lost.'.titleSemiBold(size: 16)),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ButtonWidget(
                        buttonBackgroundColor: AppColors.cancelButtonBgColor,
                        buttonForegroundColor: AppColors.subTitleText,
                        customText: 'Cancel'.titleMedium(size: 12, color: AppColors.subTitleText),
                        isValid: true,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: ButtonWidget(
                        fontSize: 12,
                        customText: 'Exit'.titleMedium(size: 12, color: AppColors.white),
                        isValid: true,
                        onPressed: () {
                          if (isTokenClear) {
                            sl<SharedPreferencesHelper>().setString(PrefConstKeys.token, "");
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
                ),
              ),
            ],
          );
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
                Row(
                  children: [
                    Expanded(
                      child: ButtonWidget(
                        buttonBackgroundColor: AppColors.cancelButtonBgColor,
                        buttonForegroundColor: AppColors.subTitleText,
                        customText: leftButtonMessage.titleMedium(size: 12.sp, color: AppColors.subTitleText),
                        isValid: true,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    AppDimensions.mediumXL.hSpace(),
                    Expanded(
                      child: ButtonWidget(
                        buttonBackgroundColor: AppColors.errorColor,
                        buttonForegroundColor: AppColors.white,
                        fontSize: 12.sp,
                        customText: rightButtonMessage.titleMedium(size: 12.sp, color: AppColors.white),
                        isValid: true,
                        onPressed: onConfirm,
                      ),
                    )
                  ],
                ).symmetricPadding(horizontal: AppDimensions.mediumXL),

                /// Vertical space below the OK button
                AppDimensions.large.vSpace(),
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
            title: 'Enter MPIN',
            isCrossIconVisible: true,
            onConfirmPressed: () {
              AppUtils.shareFile('Sharing HSC Marksheet');
            },
          );
        });
  }
}
