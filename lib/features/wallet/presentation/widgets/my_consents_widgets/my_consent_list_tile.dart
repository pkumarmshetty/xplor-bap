part of 'my_consent_list.dart';

/// Build the expandable tile for a given [index] and [data]
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
            AppDimensions.smallXL.w.horizontalSpace,
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    data.sharedWithEntity.titleBold(
                      size: AppDimensions.smallXXL.sp,
                      color: AppColors.countryCodeColor,
                    ),
                    Row(
                      children: [
                        AppDimensions.extraSmall.verticalSpace,
                        AppUtils.convertDateFormat(data.createdAt)
                            .titleSemiBold(
                                size: 10.sp, color: AppColors.hintColor),
                        AppDimensions.extraSmall.w.horizontalSpace,
                        // Add space between the date/time and dot
                        '•'.titleSemiBold(
                            size: AppDimensions.mediumXL.sp,
                            color: AppColors.hintColor),
                        AppDimensions.extraSmall.w.horizontalSpace,
                        // Add space between the dot and the word "active"
                        data.status.titleSemiBold(
                            size: AppDimensions.smallXL.sp,
                            color: AppColors.activeGreen),
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WalletKeys.sharedFile.stringToString.titleSemiBold(
                            size: 10.sp,
                            color: AppColors.countryCodeColor,
                          ),
                          AppDimensions.extraExtraSmall.verticalSpace,
                          data.vcDetails.name.titleRegular(
                              size: 10.sp,
                              color: AppColors.hintColor,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ],
                      ).singleSidePadding(
                        top: AppDimensions.medium,
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          context.read<WalletVcBloc>().flowType =
                              FlowType.consent;
                          String url =
                              "${data.vcDetails.name}: ${data.restrictedUrl}";

                          sl<SharedPreferencesHelper>()
                              .setString(PrefConstKeys.sharedId, url);
                          AppUtilsDialogMixin.askForMPINDialog(context);
                        },
                        child: Container(
                          color: Colors.transparent,
                          padding: const EdgeInsets.only(
                            left: AppDimensions.medium,
                            top: AppDimensions.medium,
                            right: AppDimensions.medium,
                          ),
                          child: Icon(
                            Icons.share,
                            size: AppDimensions.medium.w,
                            color: AppColors.primaryColor,
                          ),
                        ))
                  ],
                ),
                AppDimensions.small.verticalSpace,
                WalletKeys.consentGivenFor.stringToString.titleSemiBold(
                  size: 10.sp,
                  color: AppColors.countryCodeColor,
                ),
                AppDimensions.extraExtraSmall.verticalSpace,
                data.remarks
                    .titleRegular(size: 10.sp, color: AppColors.hintColor),
                AppDimensions.smallXL.verticalSpace,
                Row(
                  children: [
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          WalletKeys.modifiedOn.stringToString.titleSemiBold(
                            size: 10.sp,
                            color: AppColors.countryCodeColor,
                          ),
                          AppDimensions.extraExtraSmall.verticalSpace,
                          AppUtils.convertDateFormat(data.updatedAt)
                              .titleRegular(
                                  size: 10.sp, color: AppColors.hintColor),
                        ])),
                    AppDimensions.large.w.horizontalSpace,
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          WalletKeys.validity.stringToString.titleSemiBold(
                            size: 10.sp,
                            color: AppColors.countryCodeColor,
                          ),
                          AppDimensions.extraExtraSmall.verticalSpace,
                          AppUtils.convertValidityToDays(
                                  data.vcShareDetails.restrictions.expiresIn)
                              .titleRegular(
                                  size: 10.sp, color: AppColors.hintColor),
                        ]))
                  ],
                ),
                AppDimensions.smallXL.verticalSpace,
                Row(
                  children: [
                    Expanded(
                      child: RevokeButtonWidget(
                        text: WalletKeys.revoke.stringToString,
                        icon: SvgPicture.asset(
                          Assets.images.deleteIcon,
                          colorFilter: const ColorFilter.mode(
                            AppColors.redColor,
                            BlendMode.srcIn,
                          ),
                          height: AppDimensions.medium.w,
                          width: AppDimensions.medium.w,
                        ),
                        radius: 4,
                        onPressed: () {
                          AppUtils.showAlertDialogForRevokeAccess(
                              context,
                              WalletKeys.revoke.stringToString,
                              '${WalletKeys.revokeMessage.stringToString}?',
                              WalletKeys.cancel.stringToString,
                              WalletKeys.revoke.stringToString,
                              false, () {
                            // Example: Deriving a constant value from data
                            context.read<MyConsentBloc>().add(
                                  ConsentRevokeEvent(entity: data),
                                );
                            Navigator.pop(context);
                          });
                        },
                      ).singleSidePadding(right: AppDimensions.medium),
                    ),
                    AppDimensions.smallXL.w.horizontalSpace,
                    Expanded(
                      child: UpdateButtonWidget(
                        text: WalletKeys.update.stringToString,
                        onPressed: () {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return UpdateConsentDialogWidget(
                                    entity: data, onConfirmPressed: () {});
                              });
                        },
                      ).singleSidePadding(right: AppDimensions.medium),
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
