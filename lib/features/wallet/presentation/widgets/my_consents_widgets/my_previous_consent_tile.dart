part of 'my_consent_list.dart';

_buildPreviousConsentsTile(int index, BuildContext context, PreviousConsentEntity data) {
  return Container(
    color: AppColors.cancelButtonBgColor,
    padding: EdgeInsets.zero,
    child: Theme(
      data: ThemeData(
        // Set the divider color to transparent
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        trailing: const SizedBox(),
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
                        "Inactive".titleSemiBold(size: 12.sp, color: AppColors.errorColor),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
