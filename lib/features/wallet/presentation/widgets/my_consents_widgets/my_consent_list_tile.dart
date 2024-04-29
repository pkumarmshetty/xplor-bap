part of 'my_consent_list.dart';

_buildExpandableTile(int index, BuildContext context, SharedVcDataEntity data) {
  return Container(
    padding: EdgeInsets.zero,
    child: Theme(
      data: ThemeData(
        // Set the divider color to transparent
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Assets.images.consent.path,
              height: 44.w,
              width: 44.w,
            ),
            AppDimensions.smallXL.hSpace(),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    'Self Shared'.titleBold(
                      size: 14.sp,
                      color: AppColors.countryCodeColor,
                    ),
                    Row(
                      children: [
                        AppDimensions.extraSmall.vSpace(),
                        AppUtils.convertDateFormat(data.createdAt)
                            .titleSemiBold(size: 10.sp, color: AppColors.hintColor),
                        AppDimensions.extraSmall.hSpace(),
                        // Add space between the date/time and dot
                        '•'.titleSemiBold(size: 20.sp, color: AppColors.hintColor),
                        AppDimensions.extraSmall.hSpace(),
                        // Add space between the dot and the word "active"
                        data.status.titleSemiBold(size: 12.sp, color: AppColors.activeGreen),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        children: [
          ListTile(
              title: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: AppColors.consentBorderColor,
                width: 1.w,
              ),
              borderRadius: BorderRadius.circular(AppDimensions.small),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        'Shared File:'.titleSemiBold(
                          size: 10.sp,
                          color: AppColors.countryCodeColor,
                        ),
                        AppDimensions.extraExtraSmall.vSpace(),
                        data.vcDetails.name.titleRegular(size: 10.sp, color: AppColors.hintColor),
                      ],
                    ).singleSidePadding(
                      top: AppDimensions.medium,
                    ),
                    GestureDetector(
                        onTap: () {
                          String url = "${data.vcDetails.name}: ${data.restrictedUrl}";

                          sl<SharedPreferencesHelper>().setString(PrefConstKeys.sharedId, url);
                          AppUtilsDialogMixin.askForMPINDialog(context);
                        },
                        child: Container(
                          color: Colors.transparent,
                          padding: EdgeInsets.only(
                            left: 80.sp,
                            top: AppDimensions.medium,
                            right: AppDimensions.medium,
                          ),
                          child: Icon(
                            Icons.share,
                            size: 16.w,
                            color: AppColors.primaryColor,
                          ),
                        ))
                  ],
                ),
                'Consent given for:'.titleSemiBold(
                  size: 10.sp,
                  color: AppColors.countryCodeColor,
                ),
                AppDimensions.extraExtraSmall.vSpace(),
                data.remarks.titleRegular(size: 10.sp, color: AppColors.hintColor),
                AppDimensions.smallXL.vSpace(),
                Row(
                  children: [
                    Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      'Modified On:'.titleSemiBold(
                        size: 10.sp,
                        color: AppColors.countryCodeColor,
                      ),
                      AppDimensions.extraExtraSmall.vSpace(),
                      AppUtils.convertDateFormat(data.updatedAt).titleRegular(size: 10.sp, color: AppColors.hintColor),
                    ])),
                    AppDimensions.large.hSpace(),
                    Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      'Validity:'.titleSemiBold(
                        size: 10.sp,
                        color: AppColors.countryCodeColor,
                      ),
                      AppDimensions.extraExtraSmall.vSpace(),
                      AppUtils.convertValidityToDays(data.vcShareDetails.restrictions.expiresIn)
                          .titleRegular(size: 10.sp, color: AppColors.hintColor),
                    ]))
                  ],
                ),
                AppDimensions.smallXL.vSpace(),
                Row(
                  children: [
                    Expanded(
                      child: RevokeButtonWidget(
                        text: 'Revoke',
                        icon: Assets.images.deleteIcon,
                        radius: 4,
                        onPressed: () {
                          AppUtils.showAlertDialogForConfirmation(
                              context, 'Revoke', 'Are you sure, you want to revoke access?', 'Cancel', 'Revoke',
                              onConfirm: () {
                            // Example: Deriving a constant value from data
                            context.read<MyConsentBloc>().add(
                                  ConsentRevokeEvent(entity: data),
                                );
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ),
                    AppDimensions.large.hSpace(),
                    Expanded(
                      child: UpdateButtonWidget(
                        text: 'Update',
                        onPressed: () {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return UpdateConsentDialogWidget(entity: data, onConfirmPressed: () {});
                              });
                        },
                      ),
                    )
                  ],
                )
              ],
            ).singleSidePadding(
              bottom: AppDimensions.medium,
              left: AppDimensions.medium,
            ),
          ).singleSidePadding(bottom: AppDimensions.small)),
        ],
      ),
    ),
  );
}
