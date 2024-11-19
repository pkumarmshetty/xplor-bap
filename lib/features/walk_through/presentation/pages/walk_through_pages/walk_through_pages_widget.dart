part of 'walk_through_pages.dart';

Widget backButtonWidget() {
  return Container(
    height: 38.w,
    width: 38.w,
    margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.medium, vertical: AppDimensions.mediumXL),
    decoration: BoxDecoration(
      color: AppColors.blueWith10Opacity,
      // Set your desired background color
      borderRadius: BorderRadius.circular(10), // Set your desired border radius
    ),
    child: SvgPicture.asset(
            height: AppDimensions.medium.w,
            width: AppDimensions.medium.w,
            Assets.images.icBack)
        .paddingAll(padding: AppDimensions.smallXL),
  );
}

sliderViewItemsWidget(WalkThroughModel model, BuildContext context, int pos,
    Widget buttonWidget) {
  return Stack(
    children: [
      SvgPicture.asset(
        model.image,
        width: MediaQuery.of(context).size.width, // Set the width of the SVG
      ).symmetricPadding(vertical: AppDimensions.xxl),
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Container()),
          model.title.titleBlack().fadeAnimation(),
          AppDimensions.extraSmall.verticalSpace,
          model.subTitle
              .titleBold(color: AppColors.grey64697a, size: 14.sp)
              .fadeAnimation(),
          AppDimensions.smallXL.verticalSpace,
          Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.center,
            children: List.generate(
                3,
                (index) => Container(
                      height: AppDimensions.small,
                      width: AppDimensions.small,
                      margin: const EdgeInsets.only(
                          right: AppDimensions.extraSmall),
                      decoration: BoxDecoration(
                          color: pos == index
                              ? AppColors.primaryColor
                              : AppColors.grey200,
                          shape: BoxShape.circle),
                    )),
          ),
          50.verticalSpace,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (pos != 2)
                GestureDetector(
                  onTap: () {
                    if (sl<SharedPreferencesHelper>()
                        .getBoolean(PrefConstKeys.appForBelem)) {
                      Navigator.pushNamed(context, Routes.chooseDomain);
                    } else {
                      Navigator.pushNamed(context, Routes.chooseRole);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                        right: AppDimensions.medium,
                        top: AppDimensions.medium,
                        bottom: AppDimensions.medium),
                    color: Colors.transparent,
                    child: OnBoardingKeys.skip.stringToString
                        .titleMedium(color: AppColors.grey64697a, size: 14.sp),
                  ),
                ),
              const Spacer(),
              buttonWidget,
            ],
          ),
          AppDimensions.small.verticalSpace,
          Center(
            child: 'Powered by Open Source'
                .titleSemiBold(color: AppColors.primaryLightColor, size: 14.sp)
                .singleSidePadding(top: AppDimensions.small)
                .fadeInAnimated(),
          ),
        ],
      ).symmetricPadding(
          horizontal: AppDimensions.medium, vertical: AppDimensions.large),
    ],
  );
}
